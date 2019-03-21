import pandas as pd
def collect(out, miscl_validation, miscl_cv):
    samples = [] 
    for f in miscl_validation:
        mode = "_".join(f.split("/")[-2].split("_")[1:])
        miscl = pd.read_csv(f, sep = "\t", index_col = 0)
        drug = f.split("/")[-1].split("_")[0]
        for i in miscl.index:
            if miscl.loc[i,"gold standard"] == 1.0:
                samples.append([i, mode, drug, "resistant misclassified", "validation"])
            else:
                samples.append([i, mode, drug, "susceptible misclassified", "validation"])
    for f in miscl_cv:
        mode = "_".join(f.split("/")[2].split("_")[1:-2])
        miscl = pd.read_csv(f, sep = "\t", index_col = 0)
        drug = f.split("/")[-1].split("_")[0]
        for i in miscl.index:
            if miscl.loc[i,"ground_truth"] == -1:
                samples.append([i, mode, drug, "susceptible misclassified", "cross-validation"])
            else:
                samples.append([i, mode, drug, "resistant misclassified", "cross-validation"])
    out_table = pd.DataFrame(samples)
    out_table.columns = ["sample", "mode", "drug", "misclassified type", "validation set"]
    out_table.sort_values(by = ["mode", "drug", "sample", "validation set"], inplace = True)
    out_table.to_csv(out, sep = "\t", index = None)




        
if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser("collect misclassified samples from Model-T files")
    parser.add_argument("out", help="output table of misclassified samples")
    parser.add_argument("--miscl_validation", help='misclassified validation', nargs = "*")
    parser.add_argument("--miscl_cv", help='misclassified cross validation', nargs = "*")
    args = parser.parse_args()
    collect(**vars(args))
