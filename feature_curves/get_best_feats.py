import pandas as pd
def run(best_models, out_table):
    best_models = pd.read_csv(best_models, sep = "\t", index_col = None) 
    out_feats = pd.DataFrame()
    for i in best_models.index:
        model = best_models.loc[i, 'mode']
        drug = best_models.loc[i]['drug']
        cparam = best_models.loc[i]['c_param']
        #no_feats = best_models.loc[i]['no_feats']
        feats = pd.read_csv("repitition0_%s_standard_cv/traitar-model_observed_out/%s_S-vs-R_non-zero+weights.txt" %(model, drug), sep = "\t")
        feats.rename(columns = {"Unnamed: 0": "feature"}, inplace = True)
        feats.rename(columns = {"%s_0" % cparam: "SVM_weight"}, inplace = True)
        feats = feats.loc[:, ["feature", "SVM_weight", "TN", "FP", "FN", "TP", "MACC"]]
        feats = feats.loc[feats.loc[:, "SVM_weight"] != 0, ]
        feats.insert(0, "drug",drug)
        feats.insert(0, "mode", model)
        feats.insert(0, "cparam",cparam)
        if out_feats.shape[0] == 0:
            out_feats = feats
        else:
            out_feats = pd.concat([feats, out_feats])
    out_feats.loc[:, "SVM_weight_abs"] = out_feats.loc[:, "SVM_weight"].apply(lambda x: abs(x))
    out_feats.sort_values(by = ["drug", "mode", "SVM_weight_abs"], ascending = False, inplace= True)
    out_feats.drop(axis = 1, labels = "SVM_weight_abs")
    out_feats.to_csv(out_table, sep = "\t", index = None)
         
if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser("extract best feature for the target models")
    parser.add_argument("best_models", help="table with the target models")
    parser.add_argument("out_table", help='output table')
    args = parser.parse_args()
    run(**vars(args))
