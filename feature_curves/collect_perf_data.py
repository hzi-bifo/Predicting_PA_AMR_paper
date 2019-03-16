
import pandas as pd

def read(performances, out_table):
    out = pd.DataFrame() 
    for performance in performances:
        perf = pd.read_csv(performance, sep = "\t", index_col = 0)
        cv_mode = "_".join(performance.split("/")[0].split("_")[-2:])
        drug = performance.split("/")[-1].split("_")[0]
        replicate = performance.split("_")[0][-1]
        mode = "_".join(performance.split("/")[0].split("_")[1:-2])
        out_temp = pd.DataFrame(perf)
        out_temp.loc[:, "measure"]  = out_temp.index
        out_temp = out_temp.melt(id_vars = "measure", var_name = "c_param", value_name = "value")
        out_temp.loc[:, "drug"] = drug
        out_temp.loc[:, "replicate"] = replicate 
        out_temp.loc[:, "mode"] =  mode
        out = pd.concat([out, out_temp], axis = 0)

    out.index.name = "measure"
    out.to_csv(out_table, sep = "\t", index = None)

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser("prepare performance vs number of features for plotting")
    parser.add_argument("out_table", help='output table to be used for plotting')
    parser.add_argument("--performances", nargs = "*", help='performance per C param overview')
    args = parser.parse_args()
    read(**vars(args))
