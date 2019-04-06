import pandas as pd

def process_feature_name(name):
    fields = name.split(",")
    if len(fields) == 3:
        return "GPA", fields[0], fields[1], fields[2].split("|")[0], ""
    else:
        fields2 = name.split("_")
        if len(fields2) > 3:
            pos = fields2[2]
            if len(fields) == 2:
                return "SNP", fields[0], fields[1].split("_")[0],"", pos 
            else:
                return "SNP", "_".join([fields2[0], fields2[1]]), "","", pos 
        else:
            return "EXPR", fields[0], "", "", ""

def process(feats, out_table):
    feats = pd.read_csv(feats, sep = '\t')
    feats_red = feats.loc[(feats.drug == "Tobramycin") & (feats.loc[:, 'mode'] == "gpa_expr") | (feats.drug == "Ceftazidim") & (feats.loc[:, 'mode'] == "gpa_expr") | (feats.drug == "Meropenem") & (feats.loc[:, 'mode'] == "gpa_expr") | (feats.drug == "Ciprofloxacin") & (feats.loc[:, 'mode'] == "snps"), :]
    feats_red.loc[:, 'drug'] = ["TOB" if i == "Tobramycin" else "CAZ" if i == "Ceftazidim" else "MEM" if i == "Meropenem" else "CIP" for i in feats_red.loc[:, 'drug']]
    feats_red.loc[:, 'mode'] = ["GPA_EXPR" if i == "gpa_expr" else "SNPs" for i in feats_red.loc[:, 'mode']]
    feats_red = feats_red.groupby(['drug'], as_index = False).nth(range(15)).reset_index()
    #convert feature names
    feat_conv = [process_feature_name(i) for i in feats_red.feature]
        #print(process_feature_name(i))
    feats_red =  pd.concat([feats_red, pd.DataFrame(feat_conv, columns = ["data type", "PA14/CARD gene_id", "PA14/CARD gene_acc", "Prokka/Roary gene_id", "position"])], axis = 1)
    feats_red.rename(columns = {"mode" : "data combination"}, inplace = True)
    feats_red = feats_red.loc[:, ["drug", "data combination", "data type", "PA14/CARD gene_id", "PA14/CARD gene_acc", "Prokka/Roary gene_id", "position"]]
    print(feats_red)
    feats_red.to_csv("best_feats_selected_formatted.txt", index = None, sep = "\t")
    

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser("produce top x feature table for the best data combination for each drug")
    parser.add_argument("feats", help='feature summary table')
    parser.add_argument("out_table", help='output table to be used for plotting')
    args = parser.parse_args()
    process(**vars(args))
