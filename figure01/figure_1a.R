#####
# A map to show the sampling frequencies

library(ggmap)
library(phytools)

#####
# target samples
tr_f<-'OneLarge.gapReplaced.var2.gt90.fasttree'
tr<- read.newick(tr_f)
strains<- tr$tip.label
strains<- strains[grep(pattern = 'Ref', invert = T, x = strains)]

#####
# read samples table
samples_f<- 'locations.txt'
samples_df<-read.table(file = samples_f, sep= '\t', 
                       header= T, comment.char = '', 
                       stringsAsFactors = F, 
                       encoding = "UTF-8")
samples_df<- samples_df[samples_df$Isolate %in% strains, ]

#####
# coordinates
cor_f<- 'locations_coordinates.txt'
cor_df<-read.table(file = cor_f, sep= '\t', 
                       header= T, comment.char = '', stringsAsFactors = F, encoding = 'utf-8')
lon<-cor_df$City_lon
names(lon)<- cor_df$City_alt
lat<-cor_df$City_lat
names(lat)<- cor_df$City_alt
location_colors<- cor_df$color
names(location_colors)<- cor_df$City_alt
loc_dict<- cor_df$City_alt
names(loc_dict)<- cor_df$Origin
samples_df$City_alt<- loc_dict[samples_df$Origin]


#####
# prepare the data
cities<- samples_df$City_alt
loc_counts<- as.data.frame(table(cities), stringsAsFactors = F)
colnames(loc_counts)<- c('location', 'counts')
loc_counts$lon<-lon[loc_counts$location]
loc_counts$lat<-lat[loc_counts$location]
loc_counts<- loc_counts[loc_counts$location != 'nd',]


# the map: method 2
map <- map_data("world")
target_locs<- loc_counts$location
circle_scale<- 0.3
ggplot() +
  geom_polygon(data = map, aes(x = long, y = lat, group = group), fill = "white",colour = "#818181") +
  geom_point(aes(x=lon, y=lat, size= counts), color= "#596673", data=loc_counts, alpha=0.8)+
  labs(title = "Sampling distribution")+
  scale_color_manual(values= location_colors, limits = target_locs)+
  scale_size_continuous(name= 'sampling size', breaks= c(30, 60, 90, 120))+
  theme(legend.key = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        axis.text = element_blank(),
        panel.grid = element_blank(),
        panel.border= element_rect(colour = 'grey90', fill = NA),
        panel.background = element_rect(fill = "white")
        ) +
  coord_cartesian(xlim = c(min(loc_counts$lon), max(loc_counts$lon)), 
                  ylim = c(min(loc_counts$lat), max(loc_counts$lat)))
ggsave('fig_1a.pdf')
