# Predicting antimicrobial resistance in Pseudomonas aeruginosa with machine learning-enabled molecular diagnostics
This repository contains instructions to re-produce the main analyses and figures in the paper. The DNAseq and RNAseq data can be dowloaded from NCBI’s Gene Expression Omnibus and the Short Read Archive using the accessions: GSE123544 (RNAseq) and PRJNA526797 (DNAseq).
## Processing sequencing data: from raw sequencing data to features with seq2geno as input to the machine learning-based AMR prediction 
The Seq2Geno package wraps variant calling, phylogenetic tree inference, pan-genome analysis etc.. It produces the input molecular features for the subsequent antimicrobial resistance classification from the raw sequencing data. For details see the repository of [Seq2Geno](https://github.com/thkuo/seq2geno/tree/577aea67f5a8da1e4f470e35e4447b2943cb4c42).
Figure phylogenetic and geographic distribution of Pseudomonas aerugionosa strains:
The folder *Figure01* contains the data and scripts required to produce Figure 1. More specifically, *figure_1a.R* creates the map that shows the origin of the Pseudomonas strains used in this study, *figure_1b_bar.R* and *figure_1b_pie.R* visualize the extent of drug resistance across all strains, and finally *tree_visualize.R* produces a depiction of the phylogenetic tree of strains including a number of reference isolates.  
![alt text](https://github.com/hzi-bifo/Fighting_PA_AMR_paper/blob/master/figure01/Pseudomonas_fig01_v8.png)
## AMR classification with support vector machine classification using Model-T
The SVM classification was done with Model-T https://github.com/aweimann/Model-T, which is based on scikit-learn and was used as the prediction engine in our previous work on bacterial trait prediction (Weimann et al. mSystems 2016).
learning_curves/learning_curves.info, feature_curves/feature_curves.info and mic_misclassified/mic_misclassified.info are bash scripts that re-produce the respective part of the analysis using the processed sequencing data. Handle with care: They are not intended to be run in one go. For convenience, smaller result tables are included in this repository. 
### AMR prediction across different combination of data types and different evaluation schemes.
learning_curves/perf_barplot.R using the classification performance summary data in tables learning_curves/perf_all.txt and feature_curves/validation_overall.txt produces Figure 3 and Figure 5 of the paper.
![alt text](https://github.com/hzi-bifo/Fighting_PA_AMR_paper/blob/master/learning_curves/cv_acc_standardcv_barplot_all_measures.png)
![alt text](https://github.com/hzi-bifo/Fighting_PA_AMR_paper/blob/master/learning_curves/cv_acc_standard_vs_blockcv_boxplot_all.png)
### Performance saturation by number of features
feature_curves/feat_and_cparam2perf.R using the classification performance summary data in feat_perf.txt restricted to the best data combinations in best_models.txt produces Figure 4. 
![alt text](https://github.com/hzi-bifo/Fighting_PA_AMR_paper/blob/master/feature_curves/c-param_vs_perf.png)
### Performance saturation by number of samples
learning_curves/learning_curves.info is a bash script that scripts the entire pipeline for this part of the analysis. It is not intended to be run in one go.
learning_curves/plot_learning_curve_data.R using the performance summary data in table learning_curves/cv_perf_summary.txt produces Figure 6.
![alt text](https://github.com/hzi-bifo/Fighting_PA_AMR_paper/blob/master/learning_curves/learning_curve_selected.png)
### Analyzing misclassified samples
mic_misclassified/mic_miscl_barplot.R using the drug resistance prediction outcome of all strains in table miscl_all_w_validation.txt produces Figure 7. 
![alt text](https://github.com/hzi-bifo/Fighting_PA_AMR_paper/blob/master/mic_misclassified/mic_vs_miscl_selected.png)
mic_misclassified/breakpoint_enrichment.R uses the table mic_misclassified/miscl_all_w_validation.txt to check for an enrichment of misclassified samples close to the resistance breakpoint and produces table mic_misclassified/misclassified_enrichment_sig.txt. 

misclassified_phylogeny/graphlan.sh produces Supplementary Figures 3-6 requiring GraPlAn using the pre-generated XML in misclassified_phylogeny/tree_annot_Tobra.xml etc..

![alt text](https://github.com/hzi-bifo/Fighting_PA_AMR_paper/blob/master/misclassified_phylogeny/tree_cefta.png)
![alt text](https://github.com/hzi-bifo/Fighting_PA_AMR_paper/blob/master/misclassified_phylogeny/tree_cipro.png)
![alt text](https://github.com/hzi-bifo/Fighting_PA_AMR_paper/blob/master/misclassified_phylogeny/tree_mero.png)
![alt text](https://github.com/hzi-bifo/Fighting_PA_AMR_paper/blob/master/misclassified_phylogeny/tree_tobra.png)
## Comparing different ML classifiers with Geno2Pheno
The Geno2Pheno package employs a broad range of classifiers for resistance prediction. See https://github.com/hzi-bifo/Geno2Pheno for details and commands to re-produce the analysis.
![alt text](https://github.com/hzi-bifo/Fighting_PA_AMR_paper/blob/master/ml_classifier_comparison/Sup_Fig_1_classifier_comparison.png)
![alt text](https://github.com/hzi-bifo/Fighting_PA_AMR_paper/blob/master/ml_classifier_comparison/Sup_Fig_2_classifier_comparison_validation.png)
