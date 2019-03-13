#####
# The stacked bar chart about resistance counts
library(phytools)
library(ggplot2)
library(reshape2)
library(plyr)
library(RColorBrewer)
#####
# target samples
tr_f<-'OneLarge.gapReplaced.var2.gt90.fasttree'
tr<- read.newick(tr_f)
strains<- tr$tip.label
strains<- strains[grep(pattern = 'Ref', invert = T, x = strains)]

#####
# read table
samples_f<- 'pheno_table_CLSI_S-vs-R.txt'
samples_df<-read.table(file = samples_f, sep= '\t', 
                       header= T, comment.char = '', stringsAsFactors = F, na.strings = '')
colnames(samples_df)<- c('Isolate', 'TOB', 'CAZ', 'CIP', 'MEM', 'Col')
samples_df<- samples_df[, colnames(samples_df) != 'Col']
samples_df[samples_df == 1]<- 'Resistant'
samples_df[samples_df == 0]<- 'Sensitive'
samples_df[is.na(samples_df)]<- 'Intermediate'

#####
# stacked bar plot
colors<-c('#E41A1C', '#FFFF33', '#4DAF4A')
names(colors)<- c('Resistant', 'Intermediate', 'Sensitive')
sub_samples_df<- samples_df[samples_df$Isolate %in% strains, ]
long_sub_samples_df<- melt(sub_samples_df, id.vars = c('Isolate'))
long_sub_samples_count_df<- ddply(long_sub_samples_df, .(long_sub_samples_df$variable, long_sub_samples_df$value), nrow)
colnames(long_sub_samples_count_df)<-c('drug', 'resistance', 'counts')

ggplot(long_sub_samples_count_df, aes(x=drug, y=counts, fill= factor(resistance, levels= c('Sensitive', 'Intermediate', 'Resistant')), label= counts))+
  scale_fill_manual(values=colors)+
  scale_y_continuous(limits = c(0, 420), expand = c(0, 0))+
  geom_bar(stat="identity")+
  theme_classic()+
  labs(fill = "resistance")+
  theme(axis.text.x = element_text(angle = 0, hjust = 0.5))
ggsave('fig_1b.pdf')
