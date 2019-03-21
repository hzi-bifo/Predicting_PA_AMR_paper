library(tidyverse)
miscl <- read_tsv("miscl_all_w_validation.txt")
miscl <- filter(miscl, drug == "Ceftazidim" & mode == "gpa_expr" | drug == "Ciprofloxacin" & mode == "snps" | drug == "Tobramycin" & mode == "gpa_expr" | drug == "Meropenem" & mode == "gpa_expr")
MIC_sorted <- sort(unique(miscl$MIC) ) 
#stop criterion
out_tibble <- tibble(drug = numeric(), mode =  numeric(), lower = numeric(), upper = numeric(), p_val = numeric(), inner_cor = numeric(), inner_miscl = numeric(), outer_cor = numeric(), outer_miscl = numeric()) 
#apply it to all drugs and modi
sapply(unique(miscl$mode), function(i){
    sapply(unique(miscl$drug), function(j){
        drug_s <- filter(miscl, mode == i, drug == j)
        breakpoint <-filter(drug_s, variable == "intermediate (not classified)")$MIC
        drug_s <- drug_s %>% filter(variable != "intermediate (not classified)")
        left <- breakpoint
        right <- breakpoint
        while(sum(MIC_sorted < left) > 1 & sum(MIC_sorted > right) > 1){
            left <- tail(MIC_sorted[MIC_sorted < left], n = 1)
            #skip MIC == 3
            if(left == 3)
            {
                left <- tail(MIC_sorted[MIC_sorted < left], n = 1)
            }
            right <- MIC_sorted[MIC_sorted > right][1]
            #skip MIC == 3
            if(right == 3)
            {
                right <- MIC_sorted[MIC_sorted > right][1]
            }
            inner <- drug_s %>% filter(MIC >= left & MIC <= right) %>% group_by(variable) %>% summarize(inner= sum(value)) 
            outer <- drug_s %>% filter(MIC < left | MIC > right) %>% group_by(variable) %>% summarize(outer = sum(value)) 
            test <- full_join(inner, outer)
            #test[2, c(2,3)] <- test[2, c(2,3)] - test[1, c(2,3)]
            print(test)
            test_outcome <- fisher.test(data.frame(test$outer, test$inner), alternative = "greater")
            out_tibble <<- add_row(out_tibble, inner_miscl = test$inner[1], inner_cor = test$inner[2], outer_miscl = test$outer[1], outer_cor = test$outer[2], mode = i, drug = j, lower = left, upper = right, p_val = test_outcome$p.value)
        }
    })
})
out_tibble <- out_tibble %>% group_by(drug, mode) %>% mutate(pval.adj = p.adjust(p_val, method = 'BH')) %>% mutate(is_sig = pval.adj < 0.1)
write_tsv(out_tibble, "misclassified_enrichment_sig.txt")
