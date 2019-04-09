library(tidyverse)
t <- read_tsv("cv_perf_summary.txt")
t <- filter(t, drug == "Ciprofloxacin" & mode == "snps" | drug == "Ceftazidim" & mode == "gpa_expr" | drug == "Tobramycin" & mode == "gpa_expr" | drug == "Meropenem" & mode == "gpa_expr") 
t$drug <- recode(t$drug, Ciprofloxacin= "CIP", Meropenem = "MEM", Ceftazidim = "CAZ", Tobramycin = "TOB")
t$mode <- recode(t$mode, snps= "SNPs", gpa_expr= "GPA+EXPR")
plot <- ggplot(t,  aes(as.factor(no_samples), `F1-score_macro`))  +
    geom_boxplot(aes(y = `F1-score_macro`, x = as.factor(no_samples)))+
    facet_wrap(~ drug + mode) + geom_point()+
     theme_light()+
    xlab("#samples")
ggsave(paste("learning_curve_selected.png", sep = ""))
