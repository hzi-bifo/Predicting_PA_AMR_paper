gpa='~/pseudo_genomics/results/featuresAnalysis/v2/gpa/annot.uniq.txt ~/pseudo_genomics/results/assembly/v2/roary/v5/out_95/indels/indel_annot.txt '
snp='~/pseudo_genomics/results/featuresAnalysis/v2/non-syn_snps/non_syn_snps_aa_uq.uniq.txt '
expr='~/pseudo_genomics/data/gene_expression/v2/rpg_414_log.txt --do_standardization '
annot=("$gpa" "$snp" "$expr" "$gpa $expr" "$gpa $snp" "$snp $expr" "$gpa $snp $expr")
annot_name=("gpa" "snps" "expr" "gpa_expr" "gpa_snps" "expr_snps" "gpa_expr_snps")
for j in "${!annot[@]}"; do
    for rep in {0..4}; do
        for i in {1..9}; do
            echo "traitarm --config config.json sample0.${i}_repition${rep}_${annot_name[$j]} subsampling/pheno_table_sample0.${i}_repition${rep}.txt ${annot_name[$j]} --opt_measure F1-score_macro  --annotation_tables ${annot[$j]}  ";
        done
    done
done
