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

## One issue I have with the phrasing of question 1 is that total PM2.5 
## will vary not only by the amount of pollution being released per year
## but also by the number of observations!

## Thus, a quick tally indicates that observations increased per year. 

badstats <- tally(group_by(sourceclass, year))
print("The number of observations may mask the actual decrease in total pollutant
      obseration per year")
print(badstats)


## To calculate the totals, I group by year and summarize Emissions per year.

pm25totals <- sourceclass %>% 
  group_by(year) %>% 
  summarize(sum(Emissions))

names(pm25totals) <- c("year", "emissions")
# Plot the result - suprising, since # observations are almost twice as high in 2008!

png("plot1.png")
with(pm25totals, plot(year, emissions,
                      ylab = "PM2.5 in tons", 
                      type = c("b"),
                      col="blue",
                      lwd="3",
                      pch=7,
                      main="Total PM2.5 Emissions in U.S. by Year"))
dev.off()






