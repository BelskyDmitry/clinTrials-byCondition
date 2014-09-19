---
title       : Live Clinical Trials by Medical Condition
subtitle    : Version 1.0
author      : Gary Chung
job         : Explorer  
framework   : revealjs        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : zenburn      # 
revealjs    :
  theme : simple
  transition : linear
bootstrap   :
  theme : amelia
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides


---

## How many diabetes clinical <br> trials are in my local area?
<br>
# Let's find out.
<br><br>
<small> A short story by [Gary Chung](http://gary-chung.com) / [@gunkadoodah](http://twitter.com/gunkadoodah) </small>


--- ds:global &vertical

## Click on Search...

<a href="#" class="image navigate-down">
  <img width="440" height="250" 
    src="https://dl.dropboxusercontent.com/u/3991613/cthc/cthc_state2.png" alt="Search for diabetes">
</a>

Hey!<br><br>
Go down.<br>
&#9660;

*** ds:soothe

## That's a cool map!
### So what happens if I click on Dallas, TX?

&#9660;

<a href="#" class="image navigate-down">
  <img
    src="https://dl.dropboxusercontent.com/u/3991613/cthc/cthc_state3.png" alt="A map of the U.S.">
</a>



*** ds:alert

## 19 trials in my hometown? <br> Interesting.
Okay, let's move on &#9654;

<a href="#" class="image navigate-next">
  <img
    src="https://dl.dropboxusercontent.com/u/3991613/cthc/cthc_state4.png" alt="Hover over Dallas">
</a>


---

## How It Works

Query [ClinicalTrials.gov](http://clinicaltrials.gov) by the search term and parameters. The [XML package](http://cran.r-project.org/web/packages/XML) is required.

```r
xml.url <- paste("http://clinicaltrials.gov/ct2/results?cond=", 
   URLencode(inputQ, reserved=TRUE),"&pg=",pageNum,
   "&recr=Open&no_unk=Y&flds=k&cntry1=NA%3AUS&displayxml=true", sep="") 
```

After processing this a bit, get the list of cities and states for each clinical trial returned.

```r
xml.url <- paste("http://clinicaltrials.gov/ct2/show/",nctid,
   "?id=",nctid,"&displayxml=true",sep="")
# <more code to extract city and state from each trial child node>
```

Pass a data frame of cities and states, counted using the `table()` function, to Google GeoChart from the [googleVis package](http://cran.r-project.org/web/packages/googleVis).

```r
gvisGeoChart(CityStateCountry,locationvar="locationCSC",sizevar="Trials",
   options=list(displayMode="markers",resolution="metros",
  width=800,height=500,region="US")
```


--- 

## A Running Example
### A table of cities for the first acne trial found on ClinicalTrials.gov
<br>



```r
results <- assembleUrl("Acne")
getCSC(results$NCTs)
```

```
##         Country          State         City
## 1 United States North Carolina      Concord
## 2 United States North Carolina      Concord
## 3 United States North Carolina     Davidson
## 4 United States North Carolina   Harrisburg
## 5 United States North Carolina Huntersville
## 6 United States North Carolina   Kannapolis
```
<em>As of September 19, 2014...</em><br>
The first trial is running in six cities in North Carolina.<br><br>
The actual application returns results for 20 trials at a time.


---
## See the Live App Here
[gchung.shinyapps.io/Coursera09/](https://gchung.shinyapps.io/Coursera09/) | [Github](https://github.com/gunkadoodah/clinTrials-byCondition.git)
<br><br>
<small>
### Attribution and Credit
The data source for this application is [ClinicalTrials.gov](www.clinicaltrials.gov). The mapping and geolocation services are provided by [Google Charts API](https://google-developers.appspot.com/chart/). Application hosting thanks to [R Studio](http://www.rstudio.com/) and [ShinyApps](https://www.shinyapps.io).
<br><br>
### Authorship
[Gary Chung](http://gary-chung.com) | [@gunkadoodah](http://twitter.com/gunkadoodah)
</small>
