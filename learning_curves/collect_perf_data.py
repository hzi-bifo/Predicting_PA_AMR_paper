
import pandas as pd

def read(performances, out_table):
    out = pd.DataFrame() 
    for performance in performances:
        perf = pd.read_csv(performance, sep = "\t", index_col = 0)
        cv_mode = "_".join(performance.split("/")[0].split("_")[-2:])
        mode = "_".join(performance.split("/")[0].split("_")[1:-2])
        out_temp = pd.DataFrame(perf)
        out_temp.loc[:, "cv_mode"] =  cv_mode
        out_temp.loc[:, "mode"] =  mode
        out = pd.concat([out, out_temp], axis = 0)
    out.index = [drug.split("_")[0] for drug in out.index]
    out.index.name = "drug"
    out.to_csv(out_table, sep = "\t")

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser("prepare performance vs number of features for plotting")
    parser.add_argument("out_table", help='output table to be used for plotting')
    parser.add_argument("--performances", nargs = "*", help='Model-T nested-cv performance overview file')
    args = parser.parse_args()
    read(**vars(args))
