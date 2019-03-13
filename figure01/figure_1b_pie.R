library(ggplot2)
library(RColorBrewer)
library(scales)
# the phenotype table
phe_f<-'pheno_table_CLSI_S-vs-R.txt'
phe_tab<- read.csv2(phe_f, sep= '\t', header =T, stringsAsFactors = F, na.strings = '')
strains<- phe_tab[,1]
phe_tab[,1]<- NULL
phe_tab<- rbind(apply(phe_tab, MARGIN= 2, function(x) as.numeric(x)))
# exclude Colistin
phe_tab<- phe_tab[,1:4]
rownames(phe_tab)<- strains

# simple counts
counts<- apply(phe_tab, 1, function(r) length(r[r==1 & !is.na(r)])) # 1: resistant
names(counts)<- rownames(phe_tab)
counts.df<- as.data.frame(table(counts))
counts.df$counts<- as.character(counts.df$counts)
counts.df$label<- percent(counts.df$Freq/sum(counts.df$Freq))
counts.df$new.label<- apply(counts.df, MARGIN = 1, 
                            function(x) paste0(as.character(x[2]), '\n', '(', x[3], ')'))
ceiling<- cumsum(counts.df$Freq)
floor<- c(0, cumsum(counts.df$Freq)[1:(nrow(counts.df)-1)])
middle<- (ceiling+floor)/2
counts.df$label.loc<- middle
counts.df$counts<- factor(counts.df$counts, levels= c('4', '3', '2' ,'1', '0'))
# colors for each block
colors<- rev(brewer.pal(n=7, 'Blues')[3:7])
pie_p<- ggplot(counts.df, aes(x= '', y= Freq, fill= counts))+
  geom_bar(width = 1, stat = "identity")+
  scale_fill_manual(
    values=colors,
    name = "number of resistances",
    breaks= c('0', '1', '2', '3', '4'))+
  geom_text(aes(y = label.loc, 
                label = new.label), size=3)+
  coord_polar('y', start= 0, direction= 1)+
  theme_minimal()+
  theme(
    legend.position = 'bottom',
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.border = element_blank(),
    panel.grid=element_blank(),
    axis.ticks = element_blank(),
    axis.text.x=element_blank(),
    plot.title=element_text(size=14, face="bold")
  )
ggsave('drug_pie.pdf')
