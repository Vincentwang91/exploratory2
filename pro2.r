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
