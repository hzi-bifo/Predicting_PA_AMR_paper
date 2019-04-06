library(tidyverse)
#theme_set(theme_light(base_size = rel(2)))

perf <- read_tsv("~/pseudo_genomics/results/classification/v8/learning_curves/v3/perf_all.txt")
perf$drug <- recode(perf$drug, Ciprofloxacin= "CIP", Meropenem = "MEM", Ceftazidim = "CAZ", Tobramycin = "TOB")
perf_cv <- perf
perf_validation <- read_tsv("~/pseudo_genomics/results/classification/v8/feature_curves/v4/validation_overall.txt")
perf_validation$drug <- recode(perf_validation$drug, Ciprofloxacin= "CIP", Meropenem = "MEM", Ceftazidim = "CAZ", Tobramycin = "TOB")
perf_validation <- perf_validation %>% select(-one_of("neg_recall", "precision"))
perf <- perf %>% select(-one_of("neg_recall", "neg_recall_std", "precision", "precision_std", "F1-score_micro", "F1-score_micro_std","AUC", "npv_std", "precision_std", "balanced_accuracy_std", "F1-score_macro_std", "pos_recall_std" ))
perf <- full_join(perf, perf_validation, on = c("mode", "drug", "F1-score_macro"))


#discard Colistin results
perf <- filter(perf, (drug == "CIP") | (drug == "MEM") | (drug == "TOB") | (drug == "CAZ"))
p <- ggplot(perf, aes(x = mode, y = `F1-score_macro`
                      , color = cv_mode)) +
     theme_light()+
     theme(legend.position="bottom", legend.box = "horizontal") +
     geom_boxplot(outlier.size = 0.5, lwd = 0.4) + 
     facet_grid(drug ~ .) +
     labs(y = "F1-score macro", x = "", color = "") + 
     scale_x_discrete(labels=c("EXPR", "EXPR+SNPs", "GPA", "GPA+EXPR", "GPA+EXPR+SNPs", "GPA+SNPs", "SNPs")) + 
     scale_color_brewer(labels=c("block cv", "standard cv", "validation"), palette = "Set1") + 
     coord_flip()
ggsave(paste("cv_acc_standard_vs_blockcv_boxplot_all.png", sep = ""))

perf <- perf_cv %>% select(-one_of("neg_recall_std", "precision_std", "F1-score_micro", "F1-score_micro_std","AUC", "npv_std", "precision_std", "balanced_accuracy_std", "F1-score_macro_std", "pos_recall_std", "balanced_accuracy", "balanced_accuracy_std"))
perf_cvmode <- perf %>% gather(measure, value, pos_recall, neg_recall, npv, `F1-score_macro`, precision)
group_by(perf_cvmode,  cv_mode, drug, mode, measure) %>% summarize(mean = sprintf("%0.2f", sd(value)), std = sprintf("%0.2f", mean(value))) %>% write_tsv("perf_all_aggregated.txt")
perf_cvmode <- perf_cvmode %>% filter(cv_mode == "standard_cv")
perf_cvmode <- filter(perf_cvmode, (drug == "CIP") | (drug == "MEM") | (drug == "TOB") | (drug == "CAZ"))
p <- ggplot(perf_cvmode, aes(x = measure, y = value, color = mode)) +
    coord_cartesian(ylim = c(0.5, 1)) +
    geom_boxplot(outlier.size = 0.5, lwd = 0.4) + 
    facet_grid(drug ~ .) +
    theme_light()+
    theme(legend.position="bottom", legend.box = "horizontal") +
    #theme_light(base_size = rel(5))+
    labs(color = "")+
    labs(x  = "")+
    labs(y  = "")+
    scale_x_discrete(labels=rev(c("predictive value R", "sensitivity R", "predictive value S", "sensitivity S", "F1-macro"))) + 
    scale_color_brewer(labels=c("EXPR", "EXPR+SNPs", "GPA", "GPA+EXPR", "GPA+EXPR+SNPs", "GPA+SNPs", "SNPS"), palette = "Dark2") + 
    #theme(legend.text = element_text(size = rel(2))) +
    coord_flip() + 
    ggsave(paste("cv_acc_standardcv_barplot_all_measures.png", sep = ""))
