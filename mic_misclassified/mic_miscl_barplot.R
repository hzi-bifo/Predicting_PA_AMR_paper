library(argparse)
library(ggplot2)
library(forcats)
library(dplyr)
library(plyr)
library(tidyr)
library(readr)
library(argparse)
miscl_df <- read_tsv("miscl_all_w_validation.txt")
drugs = c("Ciprofloxacin", "Tobramycin", "Ceftazidim", "Meropenem")
miscl_df <- filter(miscl_df, drug == "Ciprofloxacin" & mode == "snps" | drug == "Ceftazidim" & mode == "gpa_expr" | drug == "Tobramycin" & mode == "gpa_expr" | drug == "Meropenem" & mode == "gpa_expr")
miscl_df$drug <- recode(miscl_df$drug, Ciprofloxacin= "CIP", Meropenem = "MEM", Ceftazidim = "CAZ", Tobramycin = "TOB")
miscl_df$mode <- recode(miscl_df$mode, snps= "SNPs", gpa_expr= "GPA+EXPR")
p <- ggplot(data = miscl_df, aes(x = as.factor(MIC), y = value, fill = fct_relevel(variable,  "misclassified", "correct","intermediate (not classified)"))) +
    geom_bar(stat = "identity") + facet_wrap(~ drug + mode) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1))+
    theme(legend.position="bottom", legend.box = "horizontal") +
    theme_light() +
    xlab("MIC") +
    ylab("#isolates")+
    scale_fill_manual(labels=c("misclassified", "correctly classified", "intermediate (not classified)"), values = c('#d95f02','#1b9e77','#7570b3')) + 
    labs(fill = "drug sensitivity")
ggsave(paste("mic_vs_miscl_selected.png", sep = ""))
