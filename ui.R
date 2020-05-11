# Get data:
#library(devtools)
#install.packages("remotes")
#remotes::install_github("pvictor/shinyparticles", force = TRUE)

library(r2d3)

library(dashboardthemes)
library(gapminder)

# Charge libraries:
library(ggplot2)
library(gganimate)
library(dplyr)
library(png)
library(grid)
library(stringr)
library(lubridate)
library(tidyr)

library(ggalluvial)

library(gganimate)
library(plotly)

library(animation)

library(networkD3)

library(orca)
library(shiny)
library(shinythemes)
library(shinydashboard)





######

ui <- dashboardPage(

                    
                    
                    
  dashboardHeader(title = "Simulating Non-Emergency Hospital Room Capacity in R             ", titleWidth = 600),
  dashboardSidebar(theme_grey_dark,
    
      # Custom CSS to hide the default logout panel
     
    
    
    sliderInput('mean', 'Mean Patients each Hour:',
                min = 10, max = 70, value = 15),
    sliderInput('sd', 'Standard Deviation:',
                min = 1, max = 10, value = 5),
    
    sliderInput('room1', 'Hourly Capacity - Patient Room One:',
                min = 2, max = 15, value = 5),
    sliderInput('room2', 'Hourly Capacity - Patient Room Two:',
                min = 2, max = 15, value = 5),
    sliderInput('room3', 'Hourly Capacity - Patient Room Three:',
                min = 2, max = 15, value = 5),
    sliderInput('room4', 'Hourly Capacity - Patient Room Four:',
                min = 2, max = 15, value = 5),
    sliderInput('room5', 'Hourly Capacity - Patient Room Five:',
                min = 2, max = 15, value = 5)
    
    
 
    
    ),
  
  
  

  
  
  dashboardBody(theme_grey_dark, 
 
    fluidRow(
                  valueBoxOutput("patientbox"),
                  valueBoxOutput("patientbox2"),
                  valueBoxOutput("patientbox3")
                  
                ),
  

 
   
    fluidRow(
    
      box(title = "", solidHeader = T,
          width = 12, height=1,  collapsible = T,
          
          
          plotlyOutput("plot1")))
    
 
    

  ) # body
  
)







