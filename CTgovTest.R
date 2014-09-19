getSearchCount <- function(inputQ) {
  
}

assembleUrl <- function(inputQ) {
#   paste("http://clinicaltrials.gov/search?term=", URLencode(inputQ, reserved=TRUE),
#         "&count=10000&recr=Open&displayxml=true", sep="")
  # Save the URL of the xml file in a variable
  xml.url <- paste("http://clinicaltrials.gov/ct2/results?cond=", URLencode(inputQ, reserved=TRUE),
                   "&pg=1&recr=Open&no_unk=Y&flds=k&cntry1=NA%3AUS&displayxml=true", sep="") 
  # Use the xmlTreeParse function to parse xml file directly from the web
  xmlfile <- xmlTreeParse(xml.url, useInternalNodes=TRUE, ignoreBlanks=F)
  # Save the search count
  searchCt <- as.numeric(xmlAttrs(xmlRoot(xmlfile)))
  # Remove the first element, which is the search parameter parent node
  xmltop = xmlRoot(xmlfile)[-1] 
  # Extract out all the XML values from the child nodes
  temp <- lapply(xmltop, function(x) t(xmlSApply(x,xmlValue)))
  # Converts into a data frame
  temp2 <- data.frame(matrix(unlist(temp), ncol=8, byrow=T)) 
  # Adds back in the names of the columns
  names(temp2)<-dimnames(temp[[1]])[[2]] 
  
  return(list("NCTs"=as.vector(temp2$nct_id),"searchCount"=searchCt))
  
}

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

  # Filter out any countries other than the U.S., which will still occur for multi-national studies.
  csc <- subset(csc,csc$country=="United States")
  
  return(csc)
}