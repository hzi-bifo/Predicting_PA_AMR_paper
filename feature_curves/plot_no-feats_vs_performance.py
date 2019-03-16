import pandas as pd

def read(weights, performances, measure, out_table, aggr_features):
    out = pd.DataFrame() 
    #iterate over all input files and corresponding performance
    feat_dict = {} 
    for weight, performance in zip(weights, performances):
        target = performance.split("/")[-1].split("_")[0]
        #gpa, gpa_expr
        mode = "_".join(performance.split("/")[0].split("_")[1:-2])
        #feature weights
        weights = pd.read_csv(weight, sep = "\t", index_col = 0)
        #count non zero features
        feat_counts = weights.iloc[:, :(weights.shape[1] - 6)].apply(lambda x: (x.astype('float') != 0).sum())
        for i in range(22):
            if not mode + "_" + target in feat_dict:
                feat_dict[mode + "_" + target] = []
            feat_dict[mode + "_" + target].extend(weights.loc[weights.iloc[:, i] != 0, ].iloc[:, i].index)
        feat_counts.name = "no_feats"
        feat_counts.index = [float(i.split("_")[0]) for i in feat_counts.index]
        print(feat_counts)
        #read performance
        performance = pd.read_csv(performance, sep = "\t", index_col = 0).loc[measure, ]
        print performance
        #performance = pd.concat([performance.loc[measure, ], pd.DataFrame(performance.columns)], axis = 1)
        #aggregate with existing data
        out_temp = pd.concat([feat_counts, performance], axis = 1)
        out_temp.insert(0, "drug", target)
        out_temp.insert(0, "mode", mode)
        out = pd.concat([out, out_temp], axis = 0)
    out['c_param'] = out.index
    out.to_csv(out_table, sep = "\t", index = False)
    aggr = pd.DataFrame.from_dict(feat_dict, orient = 'index')
    aggr = aggr.unstack().dropna()
    aggr.index = aggr.index.get_level_values(1) 
    aggr = aggr.groupby(aggr.index).value_counts()
    aggr.to_csv(aggr_features, sep = "\t")




if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser("prepare performance vs number of features for plotting")
    parser.add_argument("measure", help='measure to read from performance file e.g. auc or bacc')
    parser.add_argument("out_table", help='measure to read from performance file e.g. auc or bacc')
    parser.add_argument("aggr_features", help='concatenated list of features')
    parser.add_argument("--weights", nargs = "*", help='Model-T non-zero feature file')
    parser.add_argument("--performances", nargs = "*", help='Model-T performance overview file')
    args = parser.parse_args()
    read(**vars(args))


