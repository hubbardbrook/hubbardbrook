##
##
## Microbial Biomass C
##    Alex Young 7/5/2022

library(ggplot2) # graphing
library(tidyr) # dataframe manipulation
library(lubridate) # for handling date times
library(plotly) # making interactive graphs


# Package ID: knb-lter-hbr.67.23 Cataloging System:https://pasta.edirepository.org.
# Data set title: Long-term measurements of microbial biomass and activity at the Hubbard Brook Experimental Forest 1994 â present.
inUrl1  <- "https://pasta.lternet.edu/package/data/eml/knb-lter-hbr/67/23/e37c133ebf3f4ac6c1f8c2f7e612ea86" 
infile1 <- tempfile()
try(download.file(inUrl1,infile1,method="curl"))
if (is.na(file.size(infile1))) download.file(inUrl1,infile1,method="auto")

dt1 <-read.csv(infile1,header=F 
               ,skip=1
               ,sep=","  
               ,quot='"' 
               , col.names=c(
                 "Project",     
                 "Date",     
                 "Year",     
                 "Se",     
                 "Treatment",     
                 "El",     
                 "Plot",     
                 "Hor",     
                 "BIOC",     
                 "RESPC",     
                 "BION",     
                 "NO3",     
                 "NH4",     
                 "NIT",     
                 "MIN",     
                 "DEA",     
                 "H2O",     
                 "pH"    ), check.names=TRUE)

unlink(infile1)

# Fix any interval or ratio columns mistakenly read in as nominal and nominal columns read as numeric or dates read as strings

if (class(dt1$Project)!="factor") dt1$Project<- as.factor(dt1$Project)                                   
# attempting to convert dt1$Date dateTime string to R date structure (date or POSIXct)                                
tmpDateFormat<-"%Y-%m-%d"
tmp1Date<-as.Date(dt1$Date,format=tmpDateFormat)
# Keep the new dates only if they all converted correctly
if(length(tmp1Date) == length(tmp1Date[!is.na(tmp1Date)])){dt1$Date <- tmp1Date } else {print("Date conversion failed for dt1$Date. Please inspect the data and do the date conversion yourself.")}                                                                    
rm(tmpDateFormat,tmp1Date) 
if (class(dt1$Se)!="factor") dt1$Se<- as.factor(dt1$Se)
if (class(dt1$Treatment)!="factor") dt1$Treatment<- as.factor(dt1$Treatment)
if (class(dt1$El)!="factor") dt1$El<- as.factor(dt1$El)
if (class(dt1$Plot)!="factor") dt1$Plot<- as.factor(dt1$Plot)
if (class(dt1$Hor)!="factor") dt1$Hor<- as.factor(dt1$Hor)
if (class(dt1$BIOC)=="factor") dt1$BIOC <-as.numeric(levels(dt1$BIOC))[as.integer(dt1$BIOC) ]               
if (class(dt1$BIOC)=="character") dt1$BIOC <-as.numeric(dt1$BIOC)
if (class(dt1$RESPC)=="factor") dt1$RESPC <-as.numeric(levels(dt1$RESPC))[as.integer(dt1$RESPC) ]               
if (class(dt1$RESPC)=="character") dt1$RESPC <-as.numeric(dt1$RESPC)
if (class(dt1$BION)=="factor") dt1$BION <-as.numeric(levels(dt1$BION))[as.integer(dt1$BION) ]               
if (class(dt1$BION)=="character") dt1$BION <-as.numeric(dt1$BION)
if (class(dt1$NO3)=="factor") dt1$NO3 <-as.numeric(levels(dt1$NO3))[as.integer(dt1$NO3) ]               
if (class(dt1$NO3)=="character") dt1$NO3 <-as.numeric(dt1$NO3)
if (class(dt1$NH4)=="factor") dt1$NH4 <-as.numeric(levels(dt1$NH4))[as.integer(dt1$NH4) ]               
if (class(dt1$NH4)=="character") dt1$NH4 <-as.numeric(dt1$NH4)
if (class(dt1$NIT)=="factor") dt1$NIT <-as.numeric(levels(dt1$NIT))[as.integer(dt1$NIT) ]               
if (class(dt1$NIT)=="character") dt1$NIT <-as.numeric(dt1$NIT)
if (class(dt1$MIN)=="factor") dt1$MIN <-as.numeric(levels(dt1$MIN))[as.integer(dt1$MIN) ]               
if (class(dt1$MIN)=="character") dt1$MIN <-as.numeric(dt1$MIN)
if (class(dt1$DEA)=="factor") dt1$DEA <-as.numeric(levels(dt1$DEA))[as.integer(dt1$DEA) ]               
if (class(dt1$DEA)=="character") dt1$DEA <-as.numeric(dt1$DEA)
if (class(dt1$H2O)=="factor") dt1$H2O <-as.numeric(levels(dt1$H2O))[as.integer(dt1$H2O) ]               
if (class(dt1$H2O)=="character") dt1$H2O <-as.numeric(dt1$H2O)
if (class(dt1$pH)=="factor") dt1$pH <-as.numeric(levels(dt1$pH))[as.integer(dt1$pH) ]               
if (class(dt1$pH)=="character") dt1$pH <-as.numeric(dt1$pH)

# Convert Missing Values to NA for non-dates
dt1$BIOC <- ifelse((trimws(as.character(dt1$BIOC))==trimws("-9999.99")),NA,dt1$BIOC)               
suppressWarnings(dt1$BIOC <- ifelse(!is.na(as.numeric("-9999.99")) & (trimws(as.character(dt1$BIOC))==as.character(as.numeric("-9999.99"))),NA,dt1$BIOC))
dt1$RESPC <- ifelse((trimws(as.character(dt1$RESPC))==trimws("-9999.99")),NA,dt1$RESPC)               
suppressWarnings(dt1$RESPC <- ifelse(!is.na(as.numeric("-9999.99")) & (trimws(as.character(dt1$RESPC))==as.character(as.numeric("-9999.99"))),NA,dt1$RESPC))
dt1$BION <- ifelse((trimws(as.character(dt1$BION))==trimws("-9999.99")),NA,dt1$BION)               
suppressWarnings(dt1$BION <- ifelse(!is.na(as.numeric("-9999.99")) & (trimws(as.character(dt1$BION))==as.character(as.numeric("-9999.99"))),NA,dt1$BION))
dt1$NO3 <- ifelse((trimws(as.character(dt1$NO3))==trimws("-9999.99")),NA,dt1$NO3)               
suppressWarnings(dt1$NO3 <- ifelse(!is.na(as.numeric("-9999.99")) & (trimws(as.character(dt1$NO3))==as.character(as.numeric("-9999.99"))),NA,dt1$NO3))
dt1$NH4 <- ifelse((trimws(as.character(dt1$NH4))==trimws("-9999.99")),NA,dt1$NH4)               
suppressWarnings(dt1$NH4 <- ifelse(!is.na(as.numeric("-9999.99")) & (trimws(as.character(dt1$NH4))==as.character(as.numeric("-9999.99"))),NA,dt1$NH4))
dt1$NIT <- ifelse((trimws(as.character(dt1$NIT))==trimws("-9999.99")),NA,dt1$NIT)               
suppressWarnings(dt1$NIT <- ifelse(!is.na(as.numeric("-9999.99")) & (trimws(as.character(dt1$NIT))==as.character(as.numeric("-9999.99"))),NA,dt1$NIT))
dt1$MIN <- ifelse((trimws(as.character(dt1$MIN))==trimws("-9999.99")),NA,dt1$MIN)               
suppressWarnings(dt1$MIN <- ifelse(!is.na(as.numeric("-9999.99")) & (trimws(as.character(dt1$MIN))==as.character(as.numeric("-9999.99"))),NA,dt1$MIN))
dt1$DEA <- ifelse((trimws(as.character(dt1$DEA))==trimws("-9999.99")),NA,dt1$DEA)               
suppressWarnings(dt1$DEA <- ifelse(!is.na(as.numeric("-9999.99")) & (trimws(as.character(dt1$DEA))==as.character(as.numeric("-9999.99"))),NA,dt1$DEA))
dt1$H2O <- ifelse((trimws(as.character(dt1$H2O))==trimws("-9999.99")),NA,dt1$H2O)               
suppressWarnings(dt1$H2O <- ifelse(!is.na(as.numeric("-9999.99")) & (trimws(as.character(dt1$H2O))==as.character(as.numeric("-9999.99"))),NA,dt1$H2O))
dt1$pH <- ifelse((trimws(as.character(dt1$pH))==trimws("-9999.99")),NA,dt1$pH)               
suppressWarnings(dt1$pH <- ifelse(!is.na(as.numeric("-9999.99")) & (trimws(as.character(dt1$pH))==as.character(as.numeric("-9999.99"))),NA,dt1$pH))

#####

head(dt1)

table(dt1$Treatment)

table(dt1$Hor)

## add names for elevations
dt1[dt1$El=="U", "Elevation"]<-"Upper"
dt1[dt1$El=="SF", "Elevation"]<-"Spruce Fir"
dt1[dt1$El=="H", "Elevation"]<-"High"
dt1[dt1$El=="M", "Elevation"]<-"Mid"
dt1[dt1$El=="L", "Elevation"]<-"Low"
table(dt1$Elevation)

table(dt1$s)
dt1[dt1$Se=="F", "Season"]<-"Fall"
dt1[dt1$Se=="W", "Season"]<-"Winter"
dt1[dt1$Se=="SP", "Season"]<-"Spring"
dt1[dt1$Se=="SU", "Season"]<-"Summer"
table(dt1$Season)

dt1[dt1$Hor=="Oi/Oe", "Horizon"]<-"Oie"
dt1[dt1$Hor=="Oa/A", "Horizon"]<-"Oa"
dt1[dt1$Hor=="Min", "Horizon"]<-"Mineral"


# now factor in the right order
dt1$Elevation<-factor(dt1$Elevation, levels=c("Low","Mid","High","Spruce Fir","Upper"))

dt1$Horizon<-factor(dt1$Horizon, levels=c("Oie","Oa", "Mineral"))


######################

## to get correct annual values, only use the low, mid, high, and spruce/fir.
## only use samples from July
## only use samples from Bear brook

##########  annual averages, then graph

#  4 zones-   low, mid, high, spruce fir. only summers. only Bear brook

July<-dt1[dt1$Season=="Summer",]
uj<-July[!July$Elevation=="Upper",]
buj<-uj[uj$Treatment=="BearBrook",]


##########
biocav<-aggregate(list(BIOC=buj$BIOC), by=list(Year=buj$Year, Horizon=buj$Horizon), FUN="mean", na.rm=T)

head(biocav)

microC<-ggplot(biocav, aes(x=Year, y=BIOC, col=Horizon))+
  geom_point()+geom_line()+
  theme_bw()+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  labs(col='Soil horizon')+
  scale_color_manual(values=c("deepskyblue2","orange","grey"))+
  ylab("Microbial biomass (mg C/kg)")+guides(col="none")
microC
picroC<-ggplotly(microC)
picroC

htmlwidgets::saveWidget(as_widget(picroC), "soilBiology/f1_micro_biomass_C.html")

####  Average to the year level Biomass N
bionav<-aggregate(list(BION=buj$BION), by=list(Year=buj$Year, Horizon=buj$Horizon), FUN="mean", na.rm=T)
head(bionav)



microN<-ggplot(bionav, aes(x=Year, y=BION, col=Horizon))+
  geom_point()+geom_line()+
  theme_bw()+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  labs(col='Soil horizon')+
  scale_color_manual(values=c("deepskyblue2","orange","grey"))+
  ylab("Microbial biomass nitrogen (mg N/kg)")+guides(col="none")+guides(col="none")

picroN<-ggplotly(microN)
picroN

htmlwidgets::saveWidget(as_widget(picroN), "soilBiology/f2_micro_biomass_N.html")

####  Average to the year level bioC to N
biocav$horyear<-paste(biocav$Horizon, biocav$Year)
bionav$horyear<-paste(bionav$Horizon, bionav$Year)
biocav$BION<-bionav$BION[match(biocav$horyear, bionav$horyear)]
##
biocav$CN<-biocav$BIOC / biocav$BION



microCN<-ggplot(biocav, aes(x=Year, y=CN, col=Horizon))+
  geom_point()+geom_line()+
  theme_bw()+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  labs(col='Soil horizon')+
  scale_color_manual(values=c("deepskyblue2","orange","grey"))+
  ylab("Microbial biomass C:N")+guides(col="none")
microCN
picroCN<-ggplotly(microCN)
picroCN

htmlwidgets::saveWidget(as_widget(picroCN), "soilBiology/f3_micro_CN.html")


####  Average to the year level soil respiration
respav<-aggregate(list(Resp=buj$RESPC), by=list(Year=buj$Year, Horizon=buj$Horizon), FUN="mean", na.rm=T)
head(respav)



microresp<-ggplot(respav, aes(x=Year, y=Resp, col=Horizon))+
  geom_point()+geom_line()+
  theme_bw()+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  labs(col='Soil horizon')+
  scale_color_manual(values=c("deepskyblue2","orange","grey"))+
  ylab("Microbial respiration (mg C/kg/day)")+guides(col="none")
microresp
picroresp<-ggplotly(microresp)
picroresp

htmlwidgets::saveWidget(as_widget(picroresp), "soilBiology/f4_micro_respiration.html")



####  Average to the year level, denitrigication potential
respdea<-aggregate(list(DEA=buj$DEA), by=list(Year=buj$Year, Horizon=buj$Horizon), FUN="mean", na.rm=T)


microdea<-ggplot(respdea, aes(x=Year, y=DEA, col=Horizon))+
  geom_point()+geom_line()+
  theme_bw()+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  labs(col='Soil horizon')+
  scale_color_manual(values=c("deepskyblue2","orange","grey"))+
  ylab("Denitrification potential (mg/kg/day)")+guides(col="none")
microdea

picrodea<-ggplotly(microdea)
picrodea

htmlwidgets::saveWidget(as_widget(picrodea), "soilBiology/f5_micro_Denitrification.html")


####  Average to the year level, DEA-BIOC
head(respdea)
respdea$horyear<-paste(respdea$Horizon, respdea$Year)

biocav$dea<-respdea$DEA[match(biocav$horyear, respdea$horyear)]
biocav$deabioc<-biocav$dea/biocav$BIOC




head(buj)

microdeabioc<-ggplot(biocav, aes(x=Year, y=deabioc, col=Horizon))+
  geom_point()+geom_line()+
  theme_bw()+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  labs(col='Soil horizon')+
  scale_color_manual(values=c("deepskyblue2","orange","grey"))+
  ylab("DEA : BIOC")+guides(col="none")
picrodeabioc<-ggplotly(microdeabioc)
picrodeabioc

htmlwidgets::saveWidget(as_widget(picrodeabioc), "soilBiology/f6_denitrification_biomass_C.html")


###################################################################################################
###################################################################################################

#################  

###################################################################################################
###################################################################################################











#  West of 6 (bear brook?) and W1 N mineralization

head(dt1)
table(dt1$Treatment)

#  4 zones-   low, mid, high, spruce fir. only summers. only Bear brook

July<-dt1[dt1$Season=="Summer",]
uj<-July[!July$Elevation=="Upper",]
iuj<-July[July$Horizon=="Oie",]

##########
nmin<-aggregate(list(MIN=iuj$MIN, NIT=iuj$NIT), by=list(Year=iuj$Year, Horizon=iuj$Horizon, WS=iuj$Treatment), FUN="mean", na.rm=T)


st.err <- function(x) {
  sd(x, na.rm=T)/sqrt(length(x))}

nse<-aggregate(list(MIN=iuj$MIN, NIT=iuj$NIT), by=list(Year=iuj$Year, Horizon=iuj$Horizon, WS=iuj$Treatment), FUN=st.err)
nmin$minse<-nse$MIN
nmin$nitse<-nse$NIT

table(nmin$Watershed)
nmin[nmin$WS=="BearBrook", "Watershed"]<-"West of W6"
nmin[nmin$WS=="W1", "Watershed"]<-"W1"

nmin$Watershed<-factor(nmin$Watershed, levels=c("West of W6","W1"))
head(nmin)

dodge<-position_dodge(1)
nitgraph<-ggplot(nmin[nmin$Year>1997,], aes(x=Year, y=NIT , fill=Watershed))+
  geom_bar(stat="identity",position=position_dodge())+
  scale_fill_manual(values=c("dark grey","light grey"))+
  geom_errorbar(aes(ymin=NIT-nitse, ymax=NIT+nitse), width=0.2, position=dodge)+
  theme_bw()+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  ylab(bquote("Potential net nitrification \n(mg N / kg / day)")) +   
  theme(plot.margin = margin(1, 1, 0.5, 0.5, "cm"))+
  
  
  geom_text(aes(x=2001, y=18, label="Wollastonite added"),size=4, color="blue") +
  geom_segment(x = 2000 , y= 2, xend = 2000, yend = 17,col="blue",
               arrow = arrow(length = unit(0.03, "npc"), ends = "both"))+
  scale_x_continuous(breaks =round(seq(1998, max(nmin$Year), by = 1)))+
  theme(axis.text.x = element_text(angle = 90),  text=element_text(size=12))

nitgraph

mingraph<-ggplot(nmin[nmin$Year>1997,], aes(x=Year, y=MIN , fill=Watershed))+geom_bar(stat="identity",position=position_dodge())+
  geom_bar(stat="identity",position=dodge, width=0.4)+
  scale_fill_manual(values=c("dark grey","light grey"))+
  geom_errorbar(aes(ymin=MIN-minse, ymax=MIN+minse), width=0.2, position=dodge)+
  theme_bw()+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
   ylab(bquote("Potential net N mineralization \n(mg N / kg / day)")) +   
  theme(plot.margin = margin(1, 1, 0.5, 0.5, "cm"))+
  geom_text(aes(x=2001, y=35, label="Wollastonite added"),size=4, color="blue") +
  geom_segment(x = 2000 , y= 5, xend = 2000, yend = 32,col="blue",
               arrow = arrow(length = unit(0.03, "npc"), ends = "both"))+
  scale_x_continuous(breaks =round(seq(1998, max(nmin$Year), by = 1)))+
  theme(axis.text.x = element_text(angle = 90),  text=element_text(size=12))
mingraph



m <- list(
  l = 200,
  r = 50,
  b = 100,
  t = 100,
  pad = 10
)


library(ggpubr)
ggarrange(mingraph,nitgraph, common.legend = T, nrow=2, legend="right")

mi<-ggplotly(mingraph,legendgroup = ~Watershed)%>%
  layout(margin=m)
ni<-ggplotly(nitgraph,legendgroup = ~Watershed)%>%
  layout(margin=m)


plotfinal<-subplot(style(mi, showlegend = F),ni, nrows=2,
                   shareX = TRUE, titleY=TRUE)

plotfinal
# this line writes the html file to create interactive graphs for the online book
htmlwidgets::saveWidget(as_widget(plotfinal), "NitrogenCycling/fig5_Nmin_Groffman.html")






