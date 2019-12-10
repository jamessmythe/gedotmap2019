library(mapdeck)
library(sf)
library(colourvalues)
library(tidyverse)
library(shiny)
library(shinythemes)
library(shinyWidgets)

key <- "pk.eyJ1IjoiamFtZXM3MjcwIiwiYSI6ImNrM3lqZmVqczFnbW0za29wbzVtc3Y5YjEifQ.Ba5VL68Iy5KVER7hmC_FDA"

load("2019_data.RData")

parties <- dots %>% 
  select(Party) %>% 
  unique() %>% 
  mutate(img = paste0(Party, ".png"))