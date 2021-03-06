setwd("c:/R/exploratory2/")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
## question 1
Nationalsum <- tapply(NEI$Emissions,NEI$year,sum)
plot( as.numeric(names(Nationalsum)),Nationalsum,
      type = "l", xlab= "Year", ylab="National Total Emission")
## question 2
Baltimore <- NEI[NEI$fips == "24510",]
Baltimoresum <- tapply(Baltimore$Emissions,Baltimore$year,sum)
plot( as.numeric(names(Baltimoresum)),Baltimoresum,
      type = "l", xlab= "Year", ylab="Baltimore Total Emission")
## question 3

library(ggplot2)
Baltimore <- NEI[NEI$fips == "24510",]
Baltimoresum <- aggregate(Emissions ~ year + type,data=Baltimore,sum)
g <- qplot(year,Emissions,data=Baltimoresum,colour=factor(type),type = "l")
g + geom_point() +stat_smooth()

## question 4
Logical1 <- grepl("[Cc]ombustion",SCC$Short.Name)
Logical2 <- grepl("[Cc]oal",SCC$Short.Name)
Logical=Logical1 & Logical2
NEISCC <- NEI[NEI$SCC %in% SCC$SCC[Logical],]
Name<-sub("Ext Comb \\/","",SCC$Short.Name[Logical])
Name<-sub("Atmospheric Fluidized Bed Combustion","",Name)
Name<-sub(": | - ","",Name)
NEISCC$SCC <- factor(NEISCC$SCC,
                  labels=Name)
NEISCCsum <- aggregate(Emissions ~ year + SCC,data=NEISCC,sum)
g <-qplot(year,Emissions,data=NEISCCsum,colour=factor(SCC),type = "l")
g + geom_point() +stat_smooth()

## question 5
Motor <- function(fipsx = "06037"){
  Logical <- grepl("[Mm]otor",SCC$Short.Name)
  Location <- NEI[NEI$fips == fipsx,]
  NEISCC <- Location[Location$SCC %in% SCC$SCC[Logical],]
  Name<- cbind(as.character(SCC$SCC[Logical]),
                 as.character(SCC$Short.Name[Logical]))
  
#   NEISCC$SCC <- factor(NEISCC$SCC,
#                        levels=Name[,1],
#                        labels=Name[,2])
  NEISCCsum <- aggregate(Emissions ~ year,data=NEISCC,sum)
  return(NEISCCsum)
}
NEISCCsum <- Motor("24510")
  g <-qplot(year,Emissions,data=NEISCCsum,type = "l")
  g + geom_point() +stat_smooth()

## question 6
NEISCCBaltimore <- Motor("24510")
NEISCCCAL <- Motor("06037")
NEISCCsum <- rbind(cbind(NEISCCBaltimore,Location="Baltimore"),
                   cbind(NEISCCCAL,Location="Los Angeles"))
g <-qplot(year,Emissions,data=NEISCCsum,colour=factor(Location),type = "l")

g + geom_point() +stat_smooth()

