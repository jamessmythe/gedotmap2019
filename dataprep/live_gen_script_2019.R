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
  rename(pcon18cd = PCONCODE) %>% 
  select(-X)

ge2019 <- read.csv("dataprep/ge2019.csv", stringsAsFactors = F) %>% 
  rename(pcon18cd = PCONCODE) 

uk <- readOGR(dsn = "dataprep/shapefiles/2019_coords.shp")

uk@data <- merge(uk@data, ge2019, by = "pcon18cd") %>% 
  merge(regs, by = "pcon18cd")

uk2 <- uk%>%
  spTransform(CRS("+proj=longlat +datum=WGS84"))

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
  left_join(select(colours, Party, Hex))

rm(uk, uk2, regs, parties, ge2019, regions)

save.image("2019_data.RData")

