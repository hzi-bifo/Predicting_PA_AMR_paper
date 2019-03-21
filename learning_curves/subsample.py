import pandas as pd
import random
random.seed(0)

def replace(targets, samples, out_dir, out_name, repitions, sample_points):
    targets = pd.read_csv(targets, sep = "\t", index_col = 0)
    samples = pd.read_csv(samples,index_col = 0, header = None)
    targets = targets.loc[samples.index,]
    for rep in range(repitions):
        shuffled = range(targets.shape[0])
        random.shuffle(shuffled)
        for i in sample_points:
            targets_sub = targets.iloc[shuffled[: int(targets.shape[0] * i)]]
            targets_sub.to_csv("%s/%s_sample%s_repition%s.txt" %(out_dir, out_name, i, rep), sep = "\t")


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser("create samples to compute learning curves")
    parser.add_argument("targets", help="feature table")
    parser.add_argument("samples", help="restrict to these samples")
    parser.add_argument("out_dir", help="output directory")
    parser.add_argument("out_name", help="output file prefix")
    parser.add_argument("--repitions", type = int, default = 10, help="number of sub samples")
    parser.add_argument("--sample_points", type = int,  nargs = "*", default = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9], help="samples points to use")
    args = parser.parse_args()
    replace(**vars(args))
