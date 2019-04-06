import pandas as pd

def read(best_models, performances, out_table):
    out = pd.DataFrame() 
    bm = pd.read_csv(best_models, header = 0, sep = "\t")
    for performance in performances:
        perf = pd.read_csv(performance, sep = "\t", index_col = 0)
        cv_mode = "validation" 
        mode = "_".join(performance.split("/")[0].split("_")[1:])
        out_temp = pd.DataFrame(perf)
        out_temp.loc[:, "cv_mode"] =  cv_mode
        out_temp.loc[:, "mode"] =  mode
        out_temp.loc[:, "c_param"] = [float(i.split("_")[-1]) for i in out_temp.index]
        out = pd.concat([out, out_temp], axis = 0)
        #bm.loc[(bm.mode == mode) & (bm.drug == drug), :] 
    out.loc[:, "drug"]  = [drug.split("_")[0] for drug in out.index]
    #out.index.name = "drug"
    print out.columns
    print  bm.columns
    out = bm.merge(out,how = "inner", on = ["drug", "c_param", "mode"])
    out.to_csv(out_table, sep = "\t", index = None)

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser("prepare performance vs number of features for plotting")
    parser.add_argument("best_models", help='table with the best model with c param for each configuration')
    parser.add_argument("out_table", help='output table to be used for plotting')
    parser.add_argument("--performances", nargs = "*", help='Model-T nested-cv performance overview file')
    args = parser.parse_args()
    read(**vars(args))
