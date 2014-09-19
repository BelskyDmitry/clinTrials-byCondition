library(shiny); library(shinyapps)

shinyUI(fluidPage(theme="bootstrap.css",

  # Application title
  titlePanel("U.S. Cities With Live Clinical Trials by Health Condition",
             windowTitle="U.S. Cities With Live Clinical Trials by Health Condition"
             ),
  
  # Search and city batch input
  fluidRow(
    column(3,
           textInput("conditionSearch", label="Search by condition", value=""),
           helpText("E.g.: ischemic stroke"),
           actionButton("findCond","Search")
    ),
    column(3, offset=1,
           numericInput("numPage","Show city batch number",1,min=1,step=1)
    ) 
  ),
  tags$br(),
  fluidRow(column(12,tags$a(href="help.html", "Help"))),
  
  # Search result answer, and a short wait message.
  fluidRow(column(12,h3(textOutput("search")))),
  fluidRow(column(12,h6(textOutput("wait")))),
  
  # The map
  fluidRow(column(12,htmlOutput("Gmap"))),
    
  # The table of cities
  fluidRow(column(12,tableOutput("viewCSCs"))),
  
  tags$hr(), 
  tags$h3("Why Do This?"),
  tags$p("There are many possible applications, but just for starters:"),
  tags$ul(
    tags$li("A medical products company may want to know where trials are being run for a condition of interest."),
    tags$li("People want to understand which metro areas contain the most active research for a medical condition.")
  ),
  tags$h3("Attribution and Credit"),
  tags$p(
    "The data source for this application is ", tags$a(href="www.clinicaltrials.gov","ClinicalTrials.gov"),". ",
    "The mapping and geolocation services are provided by ", 
    tags$a(href="https://google-developers.appspot.com/chart/","Google Charts API. "),
    "Application hosting thanks to ",
    tags$a(href="http://www.rstudio.com/","R Studio"), " and ",
    tags$a(href="https://www.shinyapps.io","ShinyApps"),"."
  ),
  tags$h3("Authorship"),
  tags$p(
    tags$a(href="http://gary-chung.com","Gary Chung")," | ",
    tags$a(href="https://github.com/gunkadoodah/clinTrials-byCondition.git","Github")
  )
))
