library(rgdal)
library(maptools)
library(rgeos)
library(tidyverse)
library(broom)
library(sp)

regions <- c("East", "East Midlands", "London", "North East", "North West",
             "Scotland", "South East", "South West", "Wales", "West Midlands",
             "Yorkshire and The Humber")

regs <- read.csv("dataprep/regions.csv") %>% 
  rename(pcon17cd = PCONCODE) %>% 
  select(-X)

ge2019 <- read.csv("dataprep/ge2019.csv", stringsAsFactors = F) %>% 
  rename(pcon17cd = PCONCODE) 

uk2 <- readOGR(dsn = "dataprep/shapefiles/2019_coords.shp")

uk2@data <- merge(uk2@data, ge2019, by = "pcon17cd") %>% 
  merge(regs, by = "pcon17cd")

uk2 <- uk2[uk2$REGN != "Northern Ireland",]%>%
  spTransform(CRS("+proj=longlat +datum=WGS84"))

num.dots <- select(uk2@data, Con:SNP) / 250
dotsInPolys(uk2, as.integer(num.dots), f="random")

sp.dfs <- lapply(names(num.dots), function(x) {
  
})

ge.dots.2019 <- function() {
  
  num.dots <- select(uk2@data, Con:SNP) / 250
  
  sp.dfs <- lapply(names(num.dots), function(x) {
    dotsInPolys(uk2, as.integer(num.dots[, x]), f="random")
  })
  
  dfs <- lapply(sp.dfs, function(x) {
    data.frame(coordinates(x)[,1:2])
  })
  
  parties <- names(num.dots)
  for (i in 1:length(parties)) {
    dfs[[i]]$Party <- parties[i]
  }
  
  dots.final <- bind_rows(dfs) %>% 
    mutate(Party = factor(Party, levels = parties))
  
  party_labels <- c("Con", "Lab", "LD", "Brexit",
                    "Green", "Ind", "PC", "Other", "SNP")
  levels <- c("Con", "Lab", "LD", "Brexit",
              "Green", "Ind", "PC", "Other", "SNP")
  dots.final$Party <- factor(party_labels[dots.final$Party], levels = levels)
  
  return(dots.final)
}

dots <- ge.dots.2019()

colours <- read.csv("dataprep/colours.csv", stringsAsFactors = F)

dots <- dots %>% 
  select(-Hex) %>% 
  left_join(select(colours, Party, Hex))

save.image("2019_data.RData")

