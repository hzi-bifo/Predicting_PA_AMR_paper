import pandas as pd

def read(performances, measure, no_samples, out_table, is_per_drug):
    out = pd.DataFrame() 
    for performance in performances:
        #get sub sampling
        fraction = performance.split("sample")[1].split("_")[0]
        #check if processing nested cv results or single cv performance estimates
        perf = pd.read_csv(performance, sep = "\t", index_col = 0)
        if is_per_drug:
            #drug = performance.split("/")[-1].split("_")[0]
            mode = "_".join(performance.split("/")[0].split("_")[2:])
            out_temp = pd.DataFrame([mode, perf.index, perf.loc[:, measure].iloc[0], int(no_samples * float(fraction))])
            out_temp.index = ["mode", "drug", measure, "no_samples"]
            out_temp = out_temp.T
            
        else:
            mode = "_".join(performance.split("/")[0].split("_")[2:])
            out_temp = pd.DataFrame(perf.loc[:, measure])
            out_temp = out_temp.assign(no_samples =  int(no_samples * float(fraction)), measure = measure, mode = mode)
            #out_temp.index = ["mode", "drug", measure, "no_samples"]
            #out_temp.insert(0 , "no_samples",  int(no_samples * float(fraction)))
        out = pd.concat([out, out_temp])
    out.index = [i.split("_")[0] for i in out.index]
    out.index.name = "drug"       
    out.to_csv(out_table, sep = "\t")

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser("prepare performance vs number of features for plotting")
    parser.add_argument("measure", help='measure to be select from the performance overview e.g. auc, bacc')
    parser.add_argument("out_table", help='output table to be used for plotting')
    parser.add_argument("no_samples", type = int, help='number of samples')
    parser.add_argument("--performances", nargs = "*", help='Model-T nested-cv performance overview file')
    parser.add_argument("--is_per_drug", action = "store_true")
    args = parser.parse_args()
    read(**vars(args))


