install.packages("ggplot2")
install.packages("dplyr")
library(ggplot2)
library(dplyr)

my_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

if(!dir.exists("./Data")) {
  dir.create("./Data")
  download.file(my_url, "pm25data.zip")
}

unzip("pm25data.zip", exdir = "./Data")

##Now we read the RDS files and convert them to data tables.

summary <- tbl_df(readRDS("./Data/Source_Classification_Code.rds"))
sourceclass <- tbl_df(readRDS("./Data/summarySCC_PM25.rds"))

with(sourceclass, plot(Emissions, year))






