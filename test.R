
###DOWNLOAD KEY FILES ###
path <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
sourcefiles <- "/Users/tunwinhla/datasciencecoursera/edacw2/src.zip"
download.file(path,sourcefiles)
unzip(sourcefiles)
#####

#### READ THE RDS FILES FROM UNZIP££££
nei <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

####### LOAD RELEVANT LIBRARIES
library(tidyverse)

##### CODE in relevant data cats 
nei$fips <- as.factor(nei$fips)
nei$type <- as.factor(nei$type)

#### QUESTION-  1 
d1 <- nei %>% 
        group_by(year) %>% 
        summarise(totemis = sum(Emissions))
p1 <- plot(d1,main = "total emissions from PM2.5 in the United States",xlab = "Years",ylab = "PM2.5 in tons",xlim=c(1999,2008), pch= 16)


#### QUESTION - 2
d2 <- nei %>% 
        filter(fips == "24510") %>%
        group_by(year) %>% 
        summarise(totemiss = sum(Emissions))

p2 <- plot(d2,main = "total emissions from PM2.5 in the Baltimore",xlab = "Years",ylab = "PM2.5 in tons",xlim=c(1999,2008), pch= 16)

##### QUESTION - 3
d3 <- nei %>% 
        filter(fips == "24510") %>% 
        group_by(year,type) %>% 
        summarise(totemis = sum(Emissions))

p3 <- ggplot(d3,aes(x=year,y=totemis,colour = type))+
        geom_point() + 
        geom_line()+
        ggtitle("PM2.5 Emissions in Baltimore by type" )

#### QUESTION -4 

# first we need to find scc that uses coal. 

d4 <- scc %>% select(SCC,Short.Name) %>% filter(str_detect(Short.Name,"Coal"))
scc_coal <- as.character(d4$SCC)

d5 <- nei %>%
        filter(SCC %in% scc_coal) %>%
        group_by(year) %>% 
        summarise (totemis = sum(Emissions))

p4 <- plot(d5,main = "Coal sources total emissions in the United States",xlab = "Years",ylab = "PM2.5 in tons",xlim=c(1999,2008), pch= 16)

#### QUESTION 5
scc_motor <- scc %>% 
                select(SCC,Short.Name) %>%
                filter(str_detect(Short.Name,"Motor"))%>% 
                select(SCC)
scc_motor <- as.character(scc_motor$SCC)

q5 <- nei %>% 
        filter(SCC %in% scc_motor) %>%
        filter(fips == "24510")%>%
        group_by(year)%>%
        summarise(totemis = sum(Emissions))

p5 <- plot(q5, main = "Motor Vehicle associated emissions in Baltimore City", ylab = "PM2.5 in tons",pch = 16)

##### QUESTIONS 6
q6 <- nei %>% 
        filter (SCC %in% scc_motor) %>%
        filter(fips == "24510" | fips == "06037") %>% 
        group_by(year,fips) %>%
        summarise(totemis = sum(Emissions))

p6 <- ggplot(data = q6, aes(x=year,y=totemis,colour = fips)) +
        geom_point() +
        geom_line() +
        ggtitle("Motor Vehicle admissions in Baltimore City vs Los Angeles County")
#export as png 

png(filename= "plot3.svg",width = 480, height = 480, units = "px")
dev.off()
