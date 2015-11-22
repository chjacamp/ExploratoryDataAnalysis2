require(ggplot2)
require(dplyr)

my_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

if(!dir.exists("./Data")) {
  dir.create("./Data")
  download.file(my_url, "pm25data.zip")
}

unzip("pm25data.zip", exdir = "./Data")

## Now we read the RDS files and convert them to data tables.

summary <- readRDS("./Data/Source_Classification_Code.rds")
sourceclass <- readRDS("./Data/summarySCC_PM25.rds")

## Combustion sources related to coal - FIND THEM.

x <- grepl("Comb(.*)Coal", summary$EI.Sector)

## Subset rows of summary where x is true

y <- summary[x,]

## Convert the SCC rows to characters in y

i <- sapply(y, is.factor)
y[i] <- lapply(y[i], as.character)

# Subset sourceclass by proper SCC values, thanks to Karen Upright
# from the class forums!

z <- sourceclass[sourceclass[,2] %in% y[,1], ]

# Across the US is a little unspecific so I just ran all of them.
# Another option may be a lattice plot.

png("plot4.png")
p <- ggplot(z, aes(x =factor(year), y = Emissions/1000)) +
  geom_bar(stat="identity")
dev.off()


