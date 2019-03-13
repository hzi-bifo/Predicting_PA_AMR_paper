#####
# Visualization of the Pseudomonas tree
#####

##### UPDATES
library(ggplot2)
library(phytools)
library(ggtree)
library(RColorBrewer)
library(ggsci)
# Function for plotting colors side-by-side
pal <- function(col, border = "light gray", ...){
  n <- length(col)
  plot(0, 0, type="n", xlim = c(0, 1), ylim = c(0, 1),
       axes = FALSE, xlab = "", ylab = "", ...)
  rect(0:(n-1)/n, 0, 1:n/n, 1, col = col, border = border)
}

#####
## Load the tree
tr_f<- 'OneLarge.gapReplaced.var2.gt90.fasttree'
tr<- read.newick(tr_f)
outgroup<- get.offspring.tip(tr, node= 834)
#tr<- root(tr, outgroup = outgroup)
tr<- midpoint.root(tr)
tr_drop<- drop.tip(object = tr, tip = outgroup)
tr<- tr_drop

#####
## The annotation information
# locations
strains<- tr$tip.label
locations_dict<- gsub('^([A-Za-z]+).+', "\\1", strains)
names(locations_dict)<- strains
location_conversion_dict<- c('E', 'MS')
location_conversion_dict<- c('Essen', 'Münster', 'Münster', 'Berlin', 'Frankfurt',
                             'Hannover', 'others', 'others', 'others', 'others', 
                             'reference')
names(location_conversion_dict)<- c('CF', 'M', 'MS', 'CH', 'F',
                                    'MHH', 'ESP', 'ZG', 'PSAE', 'Vb',
                                    'RefCln')

#names(location_conversion_dict)<- c('CF', 'M')
locations_dict[locations_dict %in% names(location_conversion_dict)]<- 
  location_conversion_dict[locations_dict[locations_dict %in% names(location_conversion_dict)]]

# MLSTs
mlst_f<- 'seqtype2itol.txt'
mlst_df<- read.csv(mlst_f, skip= 4, header= FALSE, sep = '\t', colClasses = 'character', row.names = 1)
mlst_dict<- mlst_df[strains, 1]
names(mlst_dict)<- strains
mlst_dict[!grepl('^[0-9]+$', mlst_dict)]<- 'others'
mlst_counts<- table(mlst_dict)
target_mlst<- names(mlst_counts[(mlst_counts >= 10) & (names(mlst_counts) != 'others')])
target_mlst<- target_mlst[order(-mlst_counts[target_mlst])]
mlst_dict[!(mlst_dict %in% target_mlst)]<- 'others'

#####
## visualize
tr_info<- fortify(tr)
## add locations
tr_info$loc<- ''
tr_info[tr_info$isTip, 'loc']<- locations_dict[sapply(tr_info[tr_info$isTip, 'label'],  function(x) as.character(x))]
## add the mlsts
tr_info$MLST<- NA
tr_info[tr_info$isTip, 'MLST']<- mlst_dict[sapply(tr_info[tr_info$isTip, 'label'],  function(x) as.character(x))]
tr_info[! (tr_info$MLST %in% target_mlst), 'MLST']<- NA 
# tr_info[!is.na(tr_info$MLST), ]$MLST<- factor(tr_info[!is.na(tr_info$MLST), ]$MLST, 
#                                          levels = unique(tr_info[!is.na(tr_info$MLST), ]$MLST)[order(table(tr_info[!is.na(tr_info$MLST), ]$MLST))])
## references
tr_info$isRef<- FALSE
tr_info[grep('Ref', tr_info$label),'isRef']<- TRUE
tr_info$RefName<- NA
tr_info[grep('Ref', tr_info$label),'RefName']<- sapply(tr_info[grep('Ref', tr_info$label),'label'], function(x) gsub('RefCln_', '', x))

####
## colors
# target MLSTs
# RColorBrewer
mlst_colors<- c('darkturquoise', brewer.pal(n=9, 'Set1'))
names(mlst_colors)<- target_mlst
# hospitals
locations<- names(table(locations_dict))
locations<- locations[order(-table(locations_dict))]
location_colors<- c("#80B1D3", "#FDB462", "#BEBADA", "#FFFFB3","#B3DE69", 'white', 'black')
names(location_colors)<- c(  'Frankfurt', 'Berlin','Münster','Essen',  'Hannover', 'others', 'reference')


## the tree
ggtree(tr_info, size= 0.1, aes(color= MLST))+
  geom_point2(aes(subset=isRef), size= 0.5, color= 'darkblue')+
  geom_text2(aes(subset=isRef, label= RefName), size= 2, hjust= 'left', nudge_x= 0.02)+
  geom_treescale(x= 0, y=-10, offset = -10, width = 0.04, linesize = 0.1, fontsize = 2)+
  scale_color_manual(values= mlst_colors, na.value= 'grey10', breaks= target_mlst)+
  theme(legend.position = 'right')
ggsave('fig_1c.pdf')
