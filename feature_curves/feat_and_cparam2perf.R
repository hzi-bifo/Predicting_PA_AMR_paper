library(tidyverse)

perf <- read_tsv("feat_perf.txt")
best <- read_tsv("best_models.txt")

#group_by(perf, drug, mode, measure) %>% summarize(mean = sprintf("%0.2f", sd(value)), std = sprintf("%0.2f", mean(value))) %>% write_tsv("perf_all_aggregated.txt")
#perf <- filter(perf, measure == "F1-score_macro")
#perf_sum <- group_by(perf, drug, mode, measure, c_param) %>% r(std = sd(value), mean = mean(value)) 
#perf_max <- perf_sum %>% filter(measure == "F1-score_macro") %>% group_by(drug, mode, measure) %>% filter(mean == max(mean))
#perf_sum %>% mutate(mean = sprintf("%0.2f", mean), std = sprintf("%0.2f", std)) %>% write_tsv("perf_all_aggregated.txt")
perf <- filter(perf, mode == "snps" & drug == "Ciprofloxacin" | (mode == "gpa_expr" & (drug == "Meropenem" | drug == "Ceftazidim" | drug == "Tobramycin")))
perf <- full_join(perf, best)
perf$drug <- recode(perf$drug, Ciprofloxacin= "CIP", Meropenem = "MEM", Ceftazidim = "CAZ", Tobramycin = "TOB")
perf <- gather(perf, type, value, no_feats, `F1-score_macro`)
perf <- mutate(perf, type = replace(type, type == "no_feats", "#markers"))


#sapply(drugs, function(drug){ 
    perf <- filter(perf, (drug == "CIP") | (drug == "MEM") | (drug == "TOB") | (drug == "CAZ"))
    p <- ggplot(data = perf) +
         geom_boxplot(data = subset(perf, type == "F1-score_macro"), aes(x = as.factor(c_param), y = value, color = measure), outlier.size = .5, lwd = .4) + 
         geom_point(data = subset(perf, type == "#markers"), aes(x = as.factor(c_param), y = value, color = measure), size = 1) + 
         facet_grid(type ~ drug, scale = "free_y") +
         scale_x_discrete(breaks = c(0.001,  0.01,  0.1, 0.5), labels = c("0.001" = 0.001, "0.01" = 0.01, "0.1" = 0.1, "0.5" = 0.5)) +
         scale_color_discrete(labels = c("optimal model", "non-optimal model")) +
         labs(y = "", x = "SVM C parameter", color ="") + 
         theme(legend.position="bottom", legend.box = "horizontal") +
         theme_light()+
ggsave(paste("c-param_vs_perf.png", sep = ""))
