library(tidyverse)
library(broom)
p <- read_tsv("perf_all.txt")
#test Mero gpa vs. gpa_expr
#test Cefta gpa vs. gpa_expr
#test Tobra gpa vs. gpa_expr
#Cipro EXPR + SNP not better than SNP 
# SNP Tobra not adding value to GPA or EXPR TOBRA
c1 <- c("gpa", "gpa", "gpa", "snps", "snps", "snps")
c2 <- c("gpa_expr", "gpa_expr", "gpa_expr", "expr_snps", "gpa_snps", "expr_snps")
drugs <- c("Meropenem", "Ceftazidim", "Tobramycin", "Ciprofloxacin", "Tobramycin", "Tobramycin")
res_all <- vector("list", 6)
for (i in c(1:6))
{
t1 <- p %>% filter( cv_mode == "standard_cv", drug == !!drugs[i], mode == !!c1[i]) %>% pull(`F1-score_macro`)
t2 <- p %>% filter( cv_mode == "standard_cv", drug ==!!drugs[i], mode == !!c2[i]) %>% pull(`F1-score_macro`)
print(c1[i])
print(c2[i])
print(drugs[i])
res <- tidy(t.test(t1, t2, alternative = "less")) %>% mutate(drug = drugs[i], `data type 1` = c1[i], `data type 2` = c2[i]) %>% print()
res_all[[i]] <- res 

}
print(res_all)
bind_rows(res_all) %>% write_tsv("clf_differences_t_test.txt")
