gpa='~/pseudo_genomics/results/featuresAnalysis/v2/gpa/annot.uniq.txt ~/pseudo_genomics/results/assembly/v2/roary/v5/out_95/indels/indel_annot.txt '
snp='~/pseudo_genomics/results/featuresAnalysis/v2/non-syn_snps/non_syn_snps_aa_uq.uniq.txt '
expr='~/pseudo_genomics/data/gene_expression/v2/rpg_414_log.txt --do_standardization '
annot=("$gpa" "$snp" "$expr" "$gpa $expr" "$gpa $snp" "$snp $expr" "$gpa $snp $expr")
annot_name=("gpa" "snps" "expr" "gpa_expr" "gpa_snps" "expr_snps" "gpa_expr_snps")
for j in "${!annot[@]}"; do
     for rep in {0..4}; do
            echo "traitarm sample1_repition${rep}_${annot_name[$j]}  ~/pseudo_genomics/data/MIC/v3/pheno_table_CLSI_S-vs-R.txt ${annot_name[$j]} --do_nested_cv --opt_measure F1-score_macro --without_seed --annotation_tables ${annot[$j]}  ";
    done
done
