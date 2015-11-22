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

## Subset the Baltimore set. I also wanted practice with grepl
## however unnecessary it is

onlyBalt <- grepl("24510", sourceclass$fips)
baltData <- sourceclass[onlyBalt,]

## The same issue in Q1 is present in the Baltimore set.

badstats <- tally(group_by(baltData, year))
print("The number of observations may mask the actual decrease in total pollutant
      obseration per year")
print(badstats)

## To calculate the totals, I group by year and summarize Emissions per year.

baltData <- subset(baltData, Emissions < 1000)

pm25Balt <- mutate(baltData, emissions=Emissions/1000)

## Subset based on type (on-road) which should capture motor vehicles emissions.

pm25BaltOnRoad <- filter(pm25Balt, type=="ON-ROAD")

## Plot emissions as a bargraph.

png("plot5.png")
barplot(pm25BaltOnRoad$Emissions, 
        ylab = "PM2.5 in tons", 
        names.arg=pm25BaltOnRoad$year,
        col="red", 
        main="Total PM2.5 Emissions in Baltimore by Year from Motor Vehicles")
