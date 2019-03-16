gpa='~/pseudo_genomics/results/featuresAnalysis/v2/gpa/annot.uniq.txt ~/pseudo_genomics/results/assembly/v2/roary/v5/out_95/indels/indel_annot.txt '
snp='~/pseudo_genomics/results/featuresAnalysis/v2/non-syn_snps/non_syn_snps_aa_uq.uniq.txt '
expr='~/pseudo_genomics/data/gene_expression/v2/rpg_414_log.txt --do_standardization '
annot=("$gpa" "$snp" "$expr" "$gpa $expr" "$gpa $snp" "$snp $expr" "$gpa $snp $expr")
cv=("standard_cv")
#cv=("standardcv")
cv_folds=("standard_cv/*folds.txt" "block_cv/*folds.txt")
annot_name=("gpa" "snps" "expr" "gpa_expr" "gpa_snps" "expr_snps" "gpa_expr_snps")
for rep in {0..4}; do
    for j in "${!annot[@]}"; do
            #mkdir ${annot_name[$j]}
            for i in "${!cv[@]}"; do
                echo "traitarm repitition${rep[$i]}_${annot_name[$j]}_${cv[$i]} ~/pseudo_genomics/data/MIC/v3/pheno_table_CLSI_S-vs-R.txt  ${annot_name[$j]} --out_model ${annot_name[$j]}_${cv[$i]} --opt_measure F1-score_macro  --annotation_tables ${annot[$j]} --cv_folds ~/pseudo_genomics/results/classification/v8/learning_curves/v2/${cv[$i]}${rep}/*folds.txt --cpus 1  --without_seed --config config.json";
            done
    done
done
