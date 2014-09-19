# WORKING CODE FOR IMPLEMENTING THE MAP RETURN
# Does not run, used for development.

# Load the XML package
#  install.packages("XML")
#  library(XML)
  
assembleUrl <- function(inputQ) {
  # Save the URL of the xml file in a variable
  xml.url <- paste("http://clinicaltrials.gov/search?term=", URLencode(inputQ, reserved=TRUE),
              "&count=10000&recr=Open&displayxml=true", sep="") 
  # Use the xmlTreeParse function to parse xml file directly from the web
  xmlfile <- xmlTreeParse(xml.url, useInternalNodes=TRUE, ignoreBlanks=F)
  # Remove the first element, which is the search parameter parent node
  xmltop = xmlRoot(xmlfile)[-1] 
  # Extract out all the XML values from the child nodes
  temp <- lapply(xmltop, function(x) t(xmlSApply(x,xmlValue)))
  # Converts into a data frame
  temp2 <- data.frame(matrix(unlist(temp), ncol=8, byrow=T)) 
  # Adds back in the names of the columns
  names(temp2)<-dimnames(temp[[1]])[[2]] 
  
  return(as.vector(temp2$nct_id))
  
}

# Save the URL of the xml file in a variable
  xml.url <- "http://clinicaltrials.gov/search?term=acne&count=5&recr=Open&displayxml=true"
  
# Use the xmlTreeParse function to parse xml file directly from the web
  xmlfile <- xmlTreeParse(xml.url, useInternalNodes=TRUE, ignoreBlanks=F)
#   xmlfile <- xmlParse(xml.url, useInternalNodes=TRUE)
  
#   xmlfile <- xmlRoot(xmlTreeParse(xml.url, useInternalNodes=TRUE, ignoreBlanks=F))
#   
#   doc = xmlRoot(xmlTreeParse(xml.url))
#   table(names(doc))
#   fields = xmlApply(doc, names)
#   table(sapply(fields, identical, fields[[1]]))
  
# Use the xmlRoot-function to access the top node

xmltop = xmlRoot(xmlfile)[-1] # Removes the first element, which is the search parameter parent node

# have a look at the XML-code of the first subnodes:

# print(xmltop)[1:2]
  
  # To extract the XML-values from the document, use xmlSApply:
  
#   temp <- xmlSApply(xmltop, function(x) xmlSApply(x, xmlValue))
  
  temp <- lapply(xmltop, function(x) t(xmlSApply(x,xmlValue))) # Extracts out all the XML values from the child nodes
#   temp2 <- data.frame(unlist(temp))
#   temp2 <- as.data.frame(temp)
  
  temp2 <- data.frame(matrix(unlist(temp), ncol=8, byrow=T)) # Converts into a data frame
  names(temp2)<-dimnames(temp[[1]])[[2]] # Adds back in the names of the columns
  
  # Finally, get the data in a data-frame and have a look at the first rows and columns
#   
#   temp2 <- data.frame(t(temp),row.names=NULL)
#   temp2[1:5,1:4]



xml.url <- "http://clinicaltrials.gov/show/NCT01871519?displayxml=true"
xmlfile <- xmlTreeParse(xml.url, useInternalNodes=TRUE, ignoreBlanks=F)
xmltop = xmlRoot(xmlfile) # Removes the first element, which is the search parameter parent node
xmlSize(xmltop["location"]) # Returns the number of locations


# Stuff I put in server.R
if (!require(devtools)) { install.packages("devtools") }
library(devtools)

if (!require(rCharts)) { install.packages('rCharts') }
library(rCharts)

if (!require(maps)) { install.packages('maps') }
library(maps)

devtools::install_github('ShinyDash', 'trestletech')

require(RJSONIO); require(rCharts); require(RColorBrewer); # require(httr)

plotMap <- function(width = 1600, height = 800){
  L1 <- Leaflet$new()
  L1$tileLayer(provider = 'Stamen.TonerLite')
  L1$set(width = width, height = height)
  L1$setView(c(center_$lat, center_$lng), 13)
  #   L1$geoJson(toGeoJSON(data_), 
  #              onEachFeature = '#! function(feature, layer){
  #       layer.bindPopup(feature.properties.popup)
  #     } !#',
  #              pointToLayer =  "#! function(feature, latlng){
  #       return L.circleMarker(latlng, {
  #         radius: 4,
  #         fillColor: feature.properties.fillColor || 'red',    
  #         color: '#000',
  #         weight: 1,
  #         fillOpacity: 0.8
  #       })
  #     } !#")
  L1$enablePopover(TRUE)
  L1$fullScreen(TRUE)
  return(L1)
}
plotMap(600,300)

test<-Leaflet$new()
test$set(width=600)
test$setView(c(33.763,-117.795),12)
test

if (!require(leaflet)) install_github("leaflet-shiny","jcheng5")


#Testing the assembly of locations

temp <- assembleUrl("vertebral compression fracture")

getCSC <- function(nctid) {
  # Create the URL for the trial and extract the XML contents
  xml.url <- paste("http://clinicaltrials.gov/ct2/show/",nctid,"?id=",nctid,"&displayxml=true",sep="")
  xmlfile <- xmlTreeParse(xml.url, useInternalNodes=TRUE, ignoreBlanks=F)
  xmltop = xmlRoot(xmlfile)
  
  # From the list of locations within the trial, extract the city, state, and country
  csc <- data.frame(cbind(
    country=unlist(lapply(xmltop["location"], function(x) xmlValue(x[["facility"]][["address"]][["country"]]))),
    state=unlist(lapply(xmltop["location"], function(x) xmlValue(x[["facility"]][["address"]][["state"]]))),  
    city=unlist(lapply(xmltop["location"], function(x) xmlValue(x[["facility"]][["address"]][["city"]])))
  ), row.names=NULL)
  # # Order the list
  # csc <- csc[order(csc$country,csc$state,csc$city),]
  return(csc)
}

# Create a data frame of all the locations for all the study centers for the searched term.
temp2 <- do.call(rbind,lapply(as.list(temp),getCSC))



temp <- assembleUrl("vertebral compression fracture")
temp <- assembleUrl("hypertension",2)$NCTs
# Create a data frame of all the locations for all the study centers for the searched term.
csc <- do.call(rbind,lapply(as.list(temp),getCSC))
csc[order(csc$country,csc$state,csc$city),]        
csc[order(csc$country,csc$state,csc$city,decreasing=T),]       
csc[order(csc$'city',decreasing=T),]       
gary<-order(csc$country)


# if (!require(plyr)) install.packages("plyr")
# temp4<-arrange(csc,country)

if (!require(googleVis)) install.packages("googleVis")
library(googleVis)

temp5<-csc
temp5$locvar<-paste(temp5$City," ",temp5$State," ",temp5$Country,sep="")
temp5$locvar<-paste(temp5$City,", ",temp5$State,sep="")
temp6<-data.frame(table(temp5$locvar))
names(temp6) <- c("locationCSC","# of live trials")

# agrep("lasy", "1 lazy 2")
# agrep("lasy", c(" 1 lazy 2", "1 lasy 2"), max = list(sub = 0))
# agrep("laysy", c("1 lazy", "1", "1 LAZY"), max = 2)
# agrep("laysy", c("1 lazy", "1", "1 LAZY"), max = 2, value = TRUE)
# agrep("laysy", c("1 lazy", "1", "1 LAZY"), max = 2, ignore.case = TRUE)

gary <- gvisGeoChart(temp6,locationvar="locationCSC",sizevar="# of live trials",
                     options=list(
                       displayMode="markers",resolution="metros",width=800,height=550,region="US"
                       )
                     )
plot(gary)

require(datasets)

states <- data.frame(state.name, state.x77)
G3 <- gvisGeoChart(states, "state.name", "Illiteracy",
                   options=list(region="US", displayMode="regions",
                                resolution="countries",
                                width=800, height=600))
plot(G3)
# 
# 
# xml.url <- paste("http://clinicaltrials.gov/ct2/results?cond=hypertension&pg=1&count=2&recr=Open&no_unk=Y&flds=k&displayxml=true", sep="") 
# # Use the xmlTreeParse function to parse xml file directly from the web
# xmlfile <- xmlTreeParse(xml.url, useInternalNodes=TRUE, ignoreBlanks=F)
# # Remove the first element, which is the search parameter parent node
# xmltop = xmlRoot(xmlfile)[-1] 
# # Extract out all the XML values from the child nodes
# temp <- lapply(xmltop, function(x) t(xmlSApply(x,xmlValue)))
# # Converts into a data frame
# temp2 <- data.frame(matrix(unlist(temp), ncol=8, byrow=T)) 