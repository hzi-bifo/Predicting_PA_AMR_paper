# Fighting Pseudomonas AMR paper 
This repository contains instructions to re-produce the main analyses and figures in the paper.
## Processing sequencing data: from raw sequencing data to features with seq2geno as input to the machine learning-based AMR prediction 
Figure phylogenetic and geographic distribution of Pseudomonas aerugionosa strains:
The folder *figure01* contains the data and scripts required to produce figure 1. More specifically, *figure_1a.R* creates the map that shows the origin of the Pseudomonas strains used in this study, *figure_1b_bar.R* and *figure_1b_pie.R* visualize the extent of drug resistance across all strains, and finally *tree_visualize.R* produces a depiction of the phylogenetic tree of strains including a number of reference isolates.  
## AMR classification with support vector machine classification using Model-T
The SVM classification was done with Model-T https://github.com/aweimann/Model-T, which is a wrapper around scikit-learn and was used as the prediction engine in our previous work on bacterial trait prediction (Weimann et al. mSystems 2016).
### AMR prediction across diffferent combination of data types and different evaluation schemes.
learning_curves/perf_barplot.R using the classification performance summary data in tables learning_curves/perf_all.txt and feature_curves/validation_overall.txt produces Figure 3 and Figure 5 of the paper.
### Performance saturation by number of features
feature_curves/feat_and_cparam2perf.R using the classification performance summary data in feat_perf.txt restricted to the best data combinations in best_models.txt produces Figure 4. 
### Performance saturation by number of samples
learning_curves/plot_learning_curve_data.R using the performance summary data in table learning_curves/cv_perf_summary.txt produces Figure 6.
### Analyzing misclassified samples
mic_misclassified/mic_miscl_barplot.R using the drug resistance prediction outcome of all strains in table miscl_all_w_validation.txt produces Figure 7. 
mic_misclassified/breakpoint_enrichment.R uses the table mic_misclassified/miscl_all_w_validation.txt to check for an enrichment of misclassified samples close to the resistance breakpoint and produces table mic_misclassified/misclassified_enrichment_sig.txt. 
misclassified_phylogeny/graphlan.sh produces Supplementary Figures 3-6 requiring GraPlAn using the pre-generated XML in misclassified_phylogeny/tree_annot_Tobra.xml etc..
## Comparing different ML classifiers with geno2pheno 
Figure:
