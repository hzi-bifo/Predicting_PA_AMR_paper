import pandas as pd

def read(test_samples, phenotype_table, training, out_table):
    pheno_t = pd.read_csv(phenotype_table, sep = "\t", index_col = 0)
    for test in test_samples:
        with open(test, 'r') as f:
            samples = [s.strip() for s in f]
            target = "_".join(test.split('/')[-1].split("_")[:2])
            if not training:
                pheno_test = pheno_t.loc[samples, target]
                pheno_t.loc[:, target] = pd.np.nan 
                pheno_t.loc[samples, target] = pheno_test
            else:
                pheno_t.loc[samples, target] = pd.np.nan 
                
    pheno_t.to_csv(out_table, sep = "\t")
if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser("process test samples to create validation phenotype table")
    parser.add_argument("--training", action = "store_true", help = "create training phenotype table instead")
    parser.add_argument("--test_samples", nargs = "*")
    parser.add_argument("phenotype_table", help='MIC based phenotype table')
    parser.add_argument("out_table", help='output validation set phenotype table')
    args = parser.parse_args()
    read(**vars(args))
