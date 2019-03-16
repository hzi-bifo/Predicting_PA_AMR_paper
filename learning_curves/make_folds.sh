for i in {0..4}; do
    mkdir standard_cv${i}/
    mkdir block_cv${i}/
    echo "python ~/pseudo_genomics/src/PseudoGenomics/learning/make_cv_folds.py  10 ~/pseudo_genomics/results/cv_folds/v3/standard_cv/training_pheno_table.txt standard_cv${i}/ --test_set 0.0"
    echo "python ~/pseudo_genomics/src/PseudoGenomics/learning/make_cv_folds.py  10 ~/pseudo_genomics/results/cv_folds/v3/standard_cv/training_pheno_table.txt block_cv${i}/  --blocks ~/pseudo_genomics/results/cv_folds/v2/block_cv/sample2seqtype.txt  --test_set 0.0"
done

