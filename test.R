
###DOWNLOAD KEY FILES ###
path <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
sourcefiles <- "/Users/tunwinhla/datasciencecoursera/edacw2/src.zip"
download.file(path,sourcefiles)
unzip(sourcefiles)
#####

#### READ THE RDS FILES FROM UNZIP££££
nei <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")
#######