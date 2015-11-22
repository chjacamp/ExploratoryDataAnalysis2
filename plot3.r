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

## Remove a pesky outlier
baltData <- subset(baltData, Emissions < 1000)

## Managable y-axis size
pm25Balt <- mutate(baltData, emissions=Emissions/1000)

##plot it!
png("plot3.png", width = 620, height = 620)

p <- ggplot(pm25Balt, aes(x =factor(year), y = emissions)) +
  geom_bar(stat="identity")
p + facet_grid(. ~ type) + labs(title="Particulate Matter per Year by Type across US")

dev.off()

