
# Housekeeping: require libraries, download and read files.

require(dplyr)

my_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

if(!dir.exists("./Data")) {
  dir.create("./Data")
  download.file(my_url, "pm25data.zip")
  unzip("pm25data.zip", exdir = "./Data")
}

sourceclass <- tbl_df(readRDS("./Data/summarySCC_PM25.rds"))

## Subset the Baltimore set by motor vehicles

onlyBalt <- filter(sourceclass, fips == "24510", type=="ON-ROAD")

## That was fun, let's do the same for LA

onlyLA <- filter(sourceclass, fips == "06037", type=="ON-ROAD")

## To calculate the means, I group by year and summarize Emissions per year.

LAmeans <- onlyLA %>% 
  group_by(year) %>% 
  summarize(emissions = mean(Emissions))

Baltmeans <- onlyBalt %>% 
  group_by(year) %>% 
  summarize(emissions = mean(Emissions)) 

## Plot emissions as a bargraph.

png("plot6.png")
par(mfrow=c(2,1))
  barplot(Baltmeans$emissions, 
        ylab = "PM2.5 in tons", 
        names.arg=Baltmeans$year,
        col="red", 
        main="Mean PM2.5 Emissions in Baltimore by Year from Motor Vehicles")

  barplot(LAmeans$emissions, 
          ylab = "PM2.5 in tons", 
          names.arg=LAmeans$year,
          col="blue", 
          main="Mean PM2.5 Emissions in LA by Year from Motor Vehicles")
dev.off()
