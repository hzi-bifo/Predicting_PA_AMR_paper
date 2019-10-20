import pandas as pd
def process(feats, out_overlap, out_weights, out_feats):
    #read features
    overlap = pd.DataFrame(pd.np.zeros([0, 6]))
    overlap.columns = ["drug1", "drug2", "mode", "overlap", "no_feats1", "no_feats2"]
    weights = pd.DataFrame(pd.np.zeros([0, 5]))
    overlap_feats =  None 
    weights.columns = ["drug1", "drug2", "mode", "fraction1", "fraction2"]
    feats = pd.read_csv(feats, header = 0, sep = "\t")
    #for data type in unique feature combination
    drugs1 = ["Ciprofloxacin", "Ciprofloxacin","Ciprofloxacin", "Tobramycin", "Tobramycin", "Meropenem"]
    drugs2 = ["Tobramycin", "Meropenem", "Ceftazidim", "Meropenem", "Ceftazidim","Ceftazidim"]
    for d1, d2, j in zip(drugs1, drugs2, range(len(drugs1))):
        for dt, k in zip(feats.loc[:, "mode"].unique(), range(len(feats.loc[:, "mode"].unique()))):
            feats1 = feats.loc[(feats.loc[:, "mode"] == dt) & (feats.loc[:, "drug"] == d1),]
            feats2 = feats.loc[(feats.loc[:, "mode"] == dt) & (feats.loc[:, "drug"] == d2),]
            f1inf2 = [i in  feats2.loc[:, "feature"].values for i in feats1.loc[:, "feature"]]
            print(f1inf2)
            #how many features are shared?
            f2inf1 = [i in feats1.loc[:, "feature"].values for i in feats2.loc[:, "feature"]]
            overlap_feats1 = feats1.loc[f1inf2, ]
            overlap_feats2 = feats2.loc[f2inf1, ]
            overlap.loc[len(drugs1) * j + k] =  [d1, d2, dt, overlap_feats1.shape[0], feats1.shape[0], feats2.shape[0]]
            #and how much of the total weight do they represent for each such classifier?
            feat_share1 =  float(overlap_feats1.loc[:, "SVM_weight_abs"].sum())/feats1.loc[:, "SVM_weight_abs"].sum()
            feat_share2 =  float(overlap_feats2.loc[:, "SVM_weight_abs"].sum())/feats2.loc[:, "SVM_weight_abs"].sum()
            weights.loc[len(drugs1) * j + k] = [d1, d2, dt, feat_share1, feat_share2]
            #what are the overlapping features
            overlap_feats1.loc[:, "SVM_weight_drug2" ] = feats2.loc[f2inf1]["SVM_weight"]
            overlap_feats1 = overlap_feats1.assign(drug2 =  d2)
            if overlap_feats  is None:
                overlap_feats = overlap_feats1
            else:
                overlap_feats = pd.concat([overlap_feats1, overlap_feats])
            overlap_feats.to_csv(out_feats, sep = "\t")
            weights.to_csv(out_weights, sep = "\t")
            overlap.to_csv(out_overlap, sep = "\t")

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser("check pairwise overlaps")
    parser.add_argument("feats", help='feature table')
    parser.add_argument("out_feats", help='feature table')
    parser.add_argument("out_overlap", help='table with no of features shared for each combination of drugs and data types')
    parser.add_argument("out_weights", help='table with fraction of weight that can be attributed to shared features')
    args = parser.parse_args()
    process(**vars(args))
