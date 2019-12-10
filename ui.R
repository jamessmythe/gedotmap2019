fluidPage(theme = shinytheme("slate"),
  
  tags$head(
    # includeScript("google-analytics.js"),
    tags$link(href = "styles.css", rel = "stylesheet", type = "text/css"),
    tags$link(href = "favicon.ico", rel = "shortcut icon", type = "image/x-icon")
  ),
  
  fluidRow(
    # column(5, tags$img(src = "web_logo.png")),
    column(5, tags$a("Culture of Insight", 
                     onclick="customHref('https://www.cultureofinsight.com')",  
                     tags$img(src = "web_logo.png", alt= "CoI")
    )),
    column(7, tags$h1("2019 UK General Election Vote Map"), style = "padding-left:50px; text-align:right;")
  ),
          
  sidebarPanel(
    
    radioGroupButtons("menu", label = "Select data view", choices = c("2019 Votes", "Party by Party"),# "Swings"),
                      status = "primary", direction = "vertical", justified = T),
    
    uiOutput("menuopts")

  ),
  mainPanel(
    
    mapdeckOutput("map", height = '600px')

  )
)
