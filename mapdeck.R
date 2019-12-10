library(mapdeck)
library(sf)
library(colourvalues)
library(tidyverse)

key <- "pk.eyJ1IjoiamFtZXM3MjcwIiwiYSI6ImNrM3lqZmVqczFnbW0za29wbzVtc3Y5YjEifQ.Ba5VL68Iy5KVER7hmC_FDA"

mapdeck(token = key, style = mapdeck_style('dark'), pitch = 45 ) %>%
  add_scatterplot(
    data = dots,
    lat = "y",
    lon = "x",
    radius = 100,
    fill_colour = "Hex",
    layer_id = "scatter",
    legend = F,
    tooltip = "Party",
    legend_options = list(
      fill_colour = list(title = "Party")))

con <- dots %>% 
  filter(Party == "Con")

lab <- dots %>% 
  filter(Party == "Lab")

colour_palettes()
show_colours()

mapdeck(token = key, style = mapdeck_style('dark'), pitch = 45, location = c(-2.5, 53.5), zoom = 4.7) %>%
  add_hexagon(
    data = lab,
    lat = "y",
    lon = "x",
    elevation_scale = 100,
    update_view = F,
    colour_range = colourvalues::colour_values(1:6, palette = "reds"))

%>%
  add_screengrid(
    data = lab,
    lat = "y",
    lon = "x",
    cell_size = 6,
    opacity = 0.3,
    colour_range = colourvalues::colour_values(1:6, palette = "reds"))
