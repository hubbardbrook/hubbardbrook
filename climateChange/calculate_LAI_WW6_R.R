##
##
## LAI for W6
##    Alex Young 7/5/2022

library(ggplot2) # graphing
library(tidyr) # dataframe manipulation
library(lubridate) # for handling date times
library(plotly)



# Package ID: knb-lter-hbr.294.1 Cataloging System:https://pasta.edirepository.org.
# Data set title: Hubbard Brook Experimental Forest: Leaf Area Index (LAI) Bear Brook Watershed (West of Watershed 6).
inUrl1  <- "https://pasta.lternet.edu/package/data/eml/knb-lter-hbr/294/1/03ae67760de3cc30bfbca4e7f695c59d" 
infile1 <- tempfile()
try(download.file(inUrl1,infile1,method="curl"))
if (is.na(file.size(infile1))) download.file(inUrl1,infile1,method="auto")


dt1 <-read.csv(infile1,header=F 
               ,skip=1
               ,sep=","  
               ,quot='"' 
               , col.names=c(
                 "Plot",     
                 "Year",     
                 "Trap",     
                 "LAI"    ), check.names=TRUE)

unlink(infile1)

# Fix any interval or ratio columns mistakenly read in as nominal and nominal columns read as numeric or dates read as strings

if (class(dt1$Plot)!="factor") dt1$Plot<- as.factor(dt1$Plot)
if (class(dt1$Trap)!="factor") dt1$Trap<- as.factor(dt1$Trap)
if (class(dt1$LAI)=="factor") dt1$LAI <-as.numeric(levels(dt1$LAI))[as.integer(dt1$LAI) ]               
if (class(dt1$LAI)=="character") dt1$LAI <-as.numeric(dt1$LAI)

# Convert Missing Values to NA for non-dates

dt1$LAI <- ifelse((trimws(as.character(dt1$LAI))==trimws("-999.99")),NA,dt1$LAI)               
suppressWarnings(dt1$LAI <- ifelse(!is.na(as.numeric("-999.99")) & (trimws(as.character(dt1$LAI))==as.character(as.numeric("-999.99"))),NA,dt1$LAI))

head(dt1)
table(dt1$Plot)


lai_year<-aggregate(list(LAI=dt1$LAI), by=list(Year=dt1$Year), FUN="mean", na.rm=T)

lai_plot<-aggregate(list(LAI=dt1$LAI), by=list(Year=dt1$Year, Elevation=dt1$Plot), FUN="mean", na.rm=T)

lai_plot$Elevation<-factor(lai_plot$Elevation, levels=c("Upper","High","Mid","Low"))

g1<-ggplot(lai_year, aes(x=Year, y=LAI))+geom_point()+  geom_line()+
  geom_point(data=lai_plot, aes(x=Year, y=LAI, col=Elevation))+
  geom_line(data=lai_plot, aes(x=Year, y=LAI, col=Elevation))+
  theme_bw()+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  ylab("Leaf area index")


p1<-ggplotly(g1) %>%
  layout(title = list(text = paste0('Average leaf area index in Bear Brook at the Hubbard Brook Experimental Forest.',
                                    '<br>',
                                    '<sup>',
                                    'This figure is updated with current data available in the Envrironmental Data Initiative Repository (https://portal.edirepository.org)',
                                    '</sup>')))
p1

htmlwidgets::saveWidget(as_widget(p1), "climateChange/LAI_WW6.html")

