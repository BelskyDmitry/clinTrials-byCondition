# Install the necessary packages
  if (!require(XML)) install.packages("XML")
  if (!require(shiny)) install.packages("shiny")
  if (!require(googleVis)) install.packages("googleVis")
  library(XML); library(shiny); library(googleVis)

shinyServer(function(input, output) {  
  
  # Only call the assembleUrl and getCSC functions once per search.
  # These are direct requests to ClinicalTrials.gov.
    # A list, including a vector of NCT IDs, and the number of clinical trials found.
    searchReturn <- reactive({assembleUrl(input$conditionSearch,input$numPage)})
    # A data frame of all the cities, states, and countries for the trials returned from assembleUrl().
    csc <- reactive({do.call(rbind,lapply(as.list(searchReturn()$NCTs),getCSC))})
  
  output$search <- renderText({
    if(input$findCond>0){
      isolate({
        paste("You found ",searchReturn()$searchCount," live U.S. trials for ",input$conditionSearch, 
              ". Showing batch ",input$numPage," of ",ceiling(searchReturn()$searchCount/20),
              " batches of cities available.",sep="")
               })
    }
  })

  output$wait <- renderText({
    if(input$findCond>0){"Please be patient as the cities load..."}
  })
  
  output$viewCSCs <- renderTable({
    if(input$findCond>0){
      isolate({
        temp <- csc()[order(as.character(csc()$Country),as.character(csc()$State),as.character(csc()$City)),]
        print.data.frame(temp,row.names=F)
      })
    }
  })
  
  output$Gmap <- renderGvis({
    if(input$findCond>0){
      isolate({
        temp<-csc()
        # Concatenate City and State (assuming this is the U.S.-only build) to be geocoded by Google.
        temp$locvar<-paste(temp$City,", ",temp$State,sep="")
        # Tabulate the frequencies of each city.
        CityStateCountry<-data.frame(table(temp$locvar))
        names(CityStateCountry) <- c("locationCSC","Trials")
        gvisGeoChart(CityStateCountry,locationvar="locationCSC",sizevar="Trials",
                     options=list(
                       displayMode="markers",resolution="metros",width=800,height=500,region="US"
                     )
        )
      })
    }
  })
  
})
