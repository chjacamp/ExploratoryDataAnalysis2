require(dplyr)

my_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

if(!dir.exists("./Data")) {
  dir.create("./Data")
  download.file(my_url, "pm25data.zip")
  unzip("pm25data.zip", exdir = "./Data")
}

## Now we read the RDS files and convert them to data tables.

summary <- tbl_df(readRDS("./Data/Source_Classification_Code.rds"))
sourceclass <- tbl_df(readRDS("./Data/summarySCC_PM25.rds"))



## Subset based on type (on-road) which should capture motor vehicles emissions.

onlyBalt <- filter(sourceclass, fips == "24510", type=="ON-ROAD")

## Plot emissions as a bargraph.

Baltmeans <- onlyBalt %>% 
  group_by(year) %>% 
  summarize(emissions = mean(Emissions)) 

png("plot5.png")
barplot(Baltmeans$emissions, 
        ylab = "PM2.5 in tons", 
        names.arg=Baltmeans$year,
        col="red", 
        main="Total PM2.5 Emissions in Baltimore by Year from Motor Vehicles")
dev.off()
