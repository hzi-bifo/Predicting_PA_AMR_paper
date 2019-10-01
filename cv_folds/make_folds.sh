for i in {0..4}; do
    mkdir standard_cv${i}/
    mkdir block_cv${i}/
    echo "python make_cv_folds.py  10 ~/pseudo_genomics/data/MIC/v3/pheno_table_CLSI_S-vs-R.txt standard_cv${i}/ --test_set 0.2"
    echo "python ~/pseudo_genomics/src/PseudoGenomics/learning/make_cv_folds.py  10 ~/pseudo_genomics/data/MIC/v3/pheno_table_CLSI_S-vs-R.txt block_cv${i}/  --blocks ~/pseudo_genomics/results/cv_folds/v2/block_cv/sample2seqtype.txt  --test_set 0.2"
done

