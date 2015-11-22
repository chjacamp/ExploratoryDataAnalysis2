require(ggplot2)
require(dplyr)

my_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

if(!dir.exists("./Data")) {
  dir.create("./Data")
  download.file(my_url, "pm25data.zip")
}

unzip("pm25data.zip", exdir = "./Data")

## Now we read the RDS files and convert them to data tables.

summary <- tbl_df(readRDS("./Data/Source_Classification_Code.rds"))
sourceclass <- tbl_df(readRDS("./Data/summarySCC_PM25.rds"))

## Combustion sources related to coal - FIND THEM.

x <- grepl("Comb(.*)Coal", summary$EI.Sector)

## Subset rows of summary where x is true

y <- summary[x,]

sourceclass[sourceclass[,2] %in% y[,1], ]
