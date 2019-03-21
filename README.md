# Fighting Pseudomonas AMR paper 
This repository contains instructions to re-produce the main analyses and figures in the paper.
## Processing sequencing data: from raw sequencing data to features with seq2geno as input to the machine learning-based AMR prediction 
Figure phylogenetic and geographic distribution of Pseudomonas aerugionosa strains:
The folder *figure01* contains the data and scripts required to produce figure 1. More specifically, *figure_1a.R* creates the map that shows the origin of the Pseudomonas strains used in this study, *figure_1b_bar.R* and *figure_1b_pie.R* visualize the extent of drug resistance across all strains, and finally *tree_visualize.R* produces a depiction of the phylogenetic tree of strains including a number of reference isolates.  
## AMR classification with support vector machine classification using Model-T
The SVM classification was done with Model-T https://github.com/aweimann/Model-T, which is a wrapper around scikit-learn and was used as the prediction engine in our previous work on bacterial trait prediction (Weimann et al. mSystems 2016).
### AMR prediction across diffferent combination of data types and different evaluation schemes.
learning_curves/perf_barplot.R using the classification performance summary data in tables learning_curves/perf_all.txt and feature_curves/validation_overall.txt produces Figure 3 and Figure 5 of the paper.
![alt text](https://raw.githubusercontent.com/hzi-bifo/Fighting_PA_AMR_paper/master/learning_curves/cv_acc_standardcv_barplot_all_measures.png?token=ALaNNaMALZuHdcPUbbZfNchEQltS8zxZks5cmLSuwA%3D%3D)
![alt text](https://raw.githubusercontent.com/hzi-bifo/Fighting_PA_AMR_paper/master/learning_curves/cv_acc_standard_vs_blockcv_boxplot_all.png?token=ALaNNbjSxNNFHVkrCJehVgEJP-N3um-iks5cmLTdwA%3D%3D)
### Performance saturation by number of features
feature_curves/feat_and_cparam2perf.R using the classification performance summary data in feat_perf.txt restricted to the best data combinations in best_models.txt produces Figure 4. 
![alt text](https://github.com/hzi-bifo/Fighting_PA_AMR_paper/blob/master/feature_curves/c-param_vs_perf.png?raw=true)
### Performance saturation by number of samples
learning_curves/plot_learning_curve_data.R using the performance summary data in table learning_curves/cv_perf_summary.txt produces Figure 6.
![alt text](https://raw.githubusercontent.com/hzi-bifo/Fighting_PA_AMR_paper/master/learning_curves/learning_curve_selected.png?token=ALaNNYCIb0a2kk64BgMrz0sc2DcH0CgGks5cmLRhwA%3D%3D)
### Analyzing misclassified samples
mic_misclassified/mic_miscl_barplot.R using the drug resistance prediction outcome of all strains in table miscl_all_w_validation.txt produces Figure 7. 
![alt text](https://github.com/hzi-bifo/Fighting_PA_AMR_paper/blob/master/mic_misclassified/mic_vs_miscl_selected.png?raw=true)
mic_misclassified/breakpoint_enrichment.R uses the table mic_misclassified/miscl_all_w_validation.txt to check for an enrichment of misclassified samples close to the resistance breakpoint and produces table mic_misclassified/misclassified_enrichment_sig.txt. 

misclassified_phylogeny/graphlan.sh produces Supplementary Figures 3-6 requiring GraPlAn using the pre-generated XML in misclassified_phylogeny/tree_annot_Tobra.xml etc..

![alt text](https://raw.githubusercontent.com/hzi-bifo/Fighting_PA_AMR_paper/master/misclassified_phylogeny/tree_cefta.png?token=ALaNNU2IVQ_kAx8ScAlPS-wl4KoI_0Thks5cmLU6wA%3D%3D)
![alt text](https://github.com/hzi-bifo/Fighting_PA_AMR_paper/blob/master/misclassified_phylogeny/tree_cipro.png)
![alt text](https://github.com/hzi-bifo/Fighting_PA_AMR_paper/blob/master/misclassified_phylogeny/tree_mero.png)
![alt text](https://github.com/hzi-bifo/Fighting_PA_AMR_paper/blob/master/misclassified_phylogeny/tree_tobra.png)
## Comparing different ML classifiers with geno2pheno 
Figure:
