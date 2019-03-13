# Fighting Pseudomonas AMR paper 
This repository contains instructions to re-produce the main analyses and figures in the paper.
## Processing sequencing data: from raw sequencing data to features as input to the machine learning with seq2geno
Figure phylogenetic and geographic distribution of Pseudomonas aerugionosa strains:
The folder *figure01* contains the data and scripts required by figure 1. More specifically, *figure_1a.R* creates the map that shows sampling sizes, *figure_1b_bar.R* and *figure_1b_pie.R* visualize the drug statistics, and *tree_visualize.R* generates the plot of tree.  
## AMR classification with support vector machine classification using Model-T
### Saturation curves by number of samples
Figure: learning_curves/plot_learning_curve_data.R
### Saturation curves by number of features
Figure: feature_curves/feat_and_cparam2perf.R
### Analyzing misclassified samples
Figure MIC vs misclassified: mic_misclassified/mic_miscl_barplot.R
Test enrichments: breakpoint_enrichment.R 
Figure resistance prediction and phenotypic congruence in the context of the phylogeny:
## Comparing different ML classifiers with geno2pheno 
Figure:
