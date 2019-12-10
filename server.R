server <- function(input, output, session) {
  
  output$menuopts <- renderUI({
    
    if(input$menu == "Party by Party") {
      
      fluidRow(
        
        column(12, tags$h3("Vote distribution by Party"), 
               pickerInput("party", "Select Party", multiple = F, selected = "Con",  width = "100%",
                           choices = parties$Party,
                           choicesOpt = list(content =
                                               mapply(parties$Party, parties$img, FUN = function(Party, img) {
                                                 HTML(paste(
                                                   tags$img(src=img, width=30, height=22),
                                                   Party
                                                 ))
                                               }, SIMPLIFY = FALSE, USE.NAMES = FALSE)))),
               # selectInput("party", "Select Party", choices = parties, width = '100%')),
        column(12, tags$p("This map shows geographical vote distribution by party. Bigger parties' distributions obviously 
                      reflects population distribution to a great extent, but regional variances can be seen when switching between
                      the parties."))
      )
      
      
      
    # } else if (input$menu == "Swings") {
    #   
    #   tags$p("Introductory text here")
    #   
    #   selectInput("swings", "Select Party", choices = parties, width = '100%')
      
    } else {
      
      fluidRow(
        
        column(12, tags$h3("National Vote Distribution"),
               tags$p("This map represents vote distribution by party in the 2019 UK General Election.")),
        column(12, tags$p("Traditional election maps show constituencies won as blocks of colour, over-representing the importance of constituency land area and under-representing areas of higher population density.")),
        column(12, tags$p("Each dot shown opposite represents 250 votes for a party. Dots are distributed randomly within each constituency and do not represent precise vote location.")),
        column(12, tags$p("TO USE: Zoom in to see more detail. Hover over dots to see party details."))
      )
      
      
      
    }
  })
  
  partydata <- reactive({
    
    dots %>% 
    filter(Party == input$party)
    
  })
  
  output$map <- renderMapdeck({
    
    mapdeck(token = key, style = mapdeck_style('dark'), pitch = 20, location = c(-2.5, 54.5), zoom = 4.7) 
    
  })
  
  observe({
    
    if(input$menu == "2019 Votes") {
      
      mapdeck_update(map_id = "map") %>%
        clear_hexagon(layer_id = "pbp") %>% 
        clear_hexagon(layer_id = "swing")
      
      mapdeck_update(map_id = "map") %>%
        add_scatterplot(
          data = dots,
          lat = "y",
          lon = "x",
          radius = 150,
          fill_colour = "Hex",
          layer_id = "votes",
          legend = F,
          update_view = F,
          tooltip = "Party",
          legend_options = list(
            fill_colour = list(title = "Party")))
      
    } else if (input$menu == "Party by Party") {
      
      mapdeck_update(map_id = "map") %>%
        clear_scatterplot(layer_id = "votes") %>% 
        clear_hexagon(layer_id = "swing")
      
      observeEvent(input$party, {
        
        col <- colours %>% 
          filter(Party == input$party) %>% 
          select(Party, col1:col6) %>% 
          gather(Col, Code, -1) %>% 
          select(Code) %>% 
          pull()
        
        mapdeck_update(map_id = "map") %>%
          add_hexagon(
            data = partydata(),
            lat = "y",
            lon = "x",
            elevation_scale = 70,
            update_view = F,
            layer_id = "pbp",
            # cell_size = 6,
            # opacity = 0.3,
            colour_range = col)
        
      })
      
    }
  })
  
  
}