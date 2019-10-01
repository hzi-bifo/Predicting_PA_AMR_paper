import pandas as pd
import random
from sklearn.model_selection import StratifiedKFold, GroupKFold
from sklearn.model_selection import GroupShuffleSplit 


def make_folds(nfolds, pheno_table, blocks, out_dir, test_set):
    """create cv folds"""
    pheno_table_df = pd.read_csv(pheno_table, sep = "\t", index_col = 0)
    for target in pheno_table_df.columns:
        target_s = pheno_table_df.loc[:, target]
        target_s = target_s.loc[target_s.apply(pd.notnull)]
        sample_list = target_s.index.tolist()
        random.shuffle(sample_list)
        if test_set:
            sample_index = target_s.loc[sample_list].index
            if test_set and blocks: #make phylogenetically insulated test set for block cross validation
                blocks_df = pd.read_csv(blocks, index_col = 0, sep = "\t")
                gss = GroupShuffleSplit(2, test_size = test_set)
                training, test = gss.split(sample_list, groups = blocks_df.loc[sample_list, "group_id"].tolist()).next() 
                test_list = sample_index[test.tolist()]
                sample_list = sample_index[training.tolist()]
            else:
                test_len = int(round(len(sample_list)) * test_set)
                test_list = sample_list[:test_len]
                sample_list = sample_list[test_len:]
        sample_index = target_s.loc[sample_list].index
        if blocks:
            kf = GroupKFold(n_splits = nfolds)
            kf_split = kf.split(sample_list, groups = blocks_df.loc[sample_list, "group_id"].tolist())
        else:
            kf = StratifiedKFold(n_splits = nfolds)
            kf_split = kf.split(sample_list, target_s.loc[sample_index])
        with open("%s/%s_folds.txt" % (out_dir, target), 'w') as out_open:
            for train, test in kf_split:
                out_open.write("%s\n" % "\t".join(sample_index[test])) 
        if test_set:
            with open("%s/%s_test.txt" % (out_dir, target), 'w') as out_open:
                for elem in test_list:
                    out_open.write("%s\n" % elem) 

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser("create cv folds for AMR resistance data")
    parser.add_argument("nfolds", type = int, help='number of folds to create')
    parser.add_argument("pheno_table", help='list of samples')
    parser.add_argument("out_dir", help='out file for generated cv folds')
    parser.add_argument("--test_set", type = float, help = "percent test data")
    parser.add_argument("--blocks", help='mapping of samples to blocks; samples in the same block will not be included in the same training and test fold ')
    args = parser.parse_args()
    make_folds(**vars(args))

