import pandas as pd
def read(miscl_tables, out_table):
    atbs = ["Tobramycin", "Ciprofloxacin", "Meropenem", "Ceftazidim", "Colistin"]
    bps = [8.0, 2.0, 4.0, 16.0]
    atb2bp = dict([(atb, conc) for atb, conc in zip(atbs, bps)])
    mic_table = "/home/aweimann/pseudo_genomics/data/MIC/v3/final_isolates_paper_numeric.txt"
    mic_res = pd.read_csv(mic_table, sep = "\t", index_col = 0)
    res = mic_res.iloc[:, 5:10]
    res.columns = atbs
    mic = mic_res.iloc[:, :5]
    mic.columns = atbs
    #get number of R/I/S samples 
    #print res.apply(pd.Series.value_counts, axis = 0)
    #print mic.apply(pd.Series.value_counts, axis = 0)
    out_df = pd.DataFrame()
    for miscl in miscl_tables:
        target = miscl.split("/")[-1].split("_")[0]
        mode = "_".join(miscl.split("/")[-3].split("_")[1:-2])
        print mode, miscl
        miscls = pd.read_csv(miscl, index_col = 0, sep = "\t")
        mic_miscl = mic.loc[miscls.index, target]
        mic_miscl_counts = mic_miscl.value_counts()
        mic_counts = mic.apply(pd.Series.value_counts, axis = 0).loc[:, target]
        concat = pd.concat([mic_counts, mic_miscl_counts], axis = 1)
        concat = concat.reset_index()
        concat.columns = ["MIC", "correct", "misclassified"]
        concat.misclassified[pd.isnull(concat.loc[:, "misclassified"]) & pd.notnull(concat.loc[:, "correct"])] = 0
        #concat = concat.loc[pd.isnull(concat.loc[:, "misclassified"]) & pd.null(concat.loc[:, "correct"]), ]
        concat.correct = concat.correct - concat.misclassified
        concat = concat.melt(id_vars = ["MIC"], value_vars = ["correct", "misclassified"])
        if target in atb2bp:
            concat = concat.loc[concat.loc[:, "MIC",] != atb2bp[target], ]
            concat = concat.append({"MIC":atb2bp[target], "variable": "intermediate (not classified)", "value" : mic_counts.loc[atb2bp[target]]}, ignore_index = True)
        concat.loc[:, 'mode'] = mode
        concat.loc[:, 'drug'] =  target 
        concat = concat.loc[pd.notnull(concat.loc[:, "value"]), :]
        if mode == "":
            mode = "_".join(miscl.split("/")[-2].split("_")[1:])
            concat = concat.loc[concat.loc[:, 'variable'] == "misclassified", "value"]
            #print concat
            #print out_df.loc[(out_df.loc[:, 'variable'] == "correct") & (out_df.loc[:, 'drug'] == target) & (out_df.loc[:, 'mode'] == mode), "value"]
            out_df.loc[(out_df.loc[:, 'variable'] == "misclassified") & (out_df.loc[:, 'drug'] == target) & (out_df.loc[:, 'mode'] == mode), "value"] += concat
            out_df.loc[(out_df.loc[:, 'variable'] == "correct") & (out_df.loc[:, 'drug'] == target) & (out_df.loc[:, 'mode'] == mode), "value"] -= pd.np.array(concat)
            #print(out_df.loc[(out_df.loc[:, 'variable'] == "correct") & (out_df.loc[:, 'drug'] == target) & (out_df.loc[:, 'mode'] == mode), "value"])
        else:
            out_df = pd.concat([out_df, concat], axis = 0)
    out_df.to_csv(out_table, index = None, sep = "\t")


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser("collect misclassified samples and aggregate across conditions")
    parser.add_argument("out_table", help='output table to be used for plotting')
    parser.add_argument("--miscl_tables", nargs = "*", help='misclassified table')
    args = parser.parse_args()
    read(**vars(args))
