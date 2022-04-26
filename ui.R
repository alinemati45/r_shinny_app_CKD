library(shiny)
library(shinyAce)
library(pwr)
library(vcd)
library(tidyverse)
library(shiny)
library(ggmosaic)
library(caret)
library(purrr)
#
#    http://shiny.rstudio.com/
#
library(shinyAce)


library(shiny)
library(waiter)
library(bslib)

library(markdown)

#https://alinemati.shinyapps.io/CKD-App-main

#install.packages("rsconnect")
library(rsconnect)


# Define UI for application that draws a histogram
shinyUI(fixedPage(
  theme = bslib::bs_theme(bootswatch = "flatly"),
  
  use_waiter(),
  waiter_show_on_load(html = spin_flower()),
  
  
  
  ########## Adding loading message #########
  
  tags$head(tags$style(type="text/css", "
#loadmessage {
position: fixed;
top: 0px;
left: 0px;
width: 100%;
padding: 10px 0px 10px 0px;
text-align: center;
font-weight: bold;
font-size: 100%;
color: #000000;
background-color: #CCFF66;
z-index: 105;
}
")),
  
  conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                   tags$div("Loading...",id="loadmessage")),
  
  ########## Added up untill here ##########
  
  
  

                
  
  
  
  # Application title
  #titlePanel("Old Faithful Geyser Data"),
  
  # Sidebar with a slider input for number of bins
  navbarPage(
    "High Blood Pressure can affect CKD?",
    collapsible = TRUE,
    tabPanel("00 Start", icon = icon("play"),
             fixedRow(
               column(
                 width = 6,
                 includeMarkdown("./txt/start.md"),
                 div(
                   style = "display: inline-block; width: 150px;",
                   actionButton(
                     "code",
                     "Source Code",
                     onclick = "window.open('https://github.com/alinemati45/r_shinny_app_CKD/', '_blank')",
                     icon = icon("github")
                   )
                 ),
                 div(
                   style = "display: inline-block; width: 150px;",
                   actionButton(
                     "download",
                     "Download",
                     onclick = "window.open('https://raw.githubusercontent.com/alinemati45/r_shinny_app_CKD_potassium/main/report.pdf')",
                     icon = icon("file")
                   )
                 )
               ),
               column(
                 width = 6,
                 tabsetPanel(
                   type = "tabs",
                   tabPanel(
                     "Class",
                     h4("Class of the Chronic Kidney Disease :"),
                     plotOutput("classplot")
                   ),
                   tabPanel(
                     "Pus Cell",
                     h4("Chronic Kidney Disease Class by Pus Cell:"),
                     plotOutput("Pus_Cellplot1")
                   ),
                   tabPanel(
                     "Blood Pressure",
                     h4("Blood Pressure by the Chronic Kidney Disease:"),
                     plotOutput("blood_pressure")
                   ),
                   tabPanel(
                     "Age ",
                     h4("Chronic Kidney Disease by Age:"),
                     plotOutput("ageplot")
                   )
                   
                 )
               ) , 
             )) ,
    
    tabPanel("01. Test of Independence (Tabulated data)",
             
             h2("Test of Independence (Tabulated data)"),
             
            # h5("H0: There is no association of one unit increase in blood pressure with chronic kidney disease risk. "),
            # h5("H1: There is no association of one unit increase in blood pressure with chronic kidney disease risk. "),
             p(HTML("<b><div style='background-color:#FADDF2;border:1px solid black;'>H0: There is no association of one unit increase in blood pressure with chronic kidney disease risk.</div></b>")),
             p(HTML("<b><div style='background-color:#FADDF2;border:1px solid black;'>H1: There is association of one unit increase in blood pressure with chronic kidney disease risk.</div></b>")),
             
             h4("Two or more than two nominal variables"),
             
             p('Note: Input values must be separated by tabs. Copy and paste from Excel/Numbers.\nYour data needs to have the header (variable names) in the first row. Missing values should be indicated by a period'),
             
             
             aceEditor("text4", value="\tLow\tMid\tHigh\nCKD\t98\t52\t81\nNotCKD\t91\t66\t12", mode="r", theme="cobalt"),
             #aceEditor("text4", value="\tNo\tYes\nM\t20\t18\nW\t8\t24", mode="r", theme="cobalt"),
             
             br(),
             
             h3("Contingency table"),
             verbatimTextOutput("data4.out"),
             
             br(),
             
             h3("Test result"),
             verbatimTextOutput("test4.out"),
             
             br(),
             
             h3("Plot"),
             
             plotOutput("pPlot4"),
             
             br(),
             
             #plotOutput("mPlot4", height = "550px"),
             #verbatimTextOutput("Because the P-value is clearly less than α = 0.05, we reject H0 and conclude that high blood pressure and Chronic Kidney disease are associated in the population."),
             br(),
             br(),
             
             strong('Our Result is : '),
             strong(verbatimTextOutput("info4.out"))
    ), 
    tabPanel("02 Idea", icon = icon("lightbulb"),
             fixedRow(
               column(
                 width = 6,
                 includeMarkdown("./txt/idea.md"),
                 h4("Insert the logit in the scatterplot:"),
                 checkboxInput("boolmethod", "Logit!",
                               value = FALSE)
               ),
               column(width = 6,
                      tabsetPanel(
                        type = "tabs",
                        tabPanel("Scatterplot", plotOutput("scatter_log")),
                        tabPanel("Function", plotOutput("funcplot"))
                      ))
             ) ),
    tabPanel("03 Variables", icon = icon("chart-pie"),
             fixedRow(
               column(width = 6,
                      includeMarkdown("./txt/variables.md")),
               column(
                 width = 6,
                 HTML(paste(h4("Add a variable:"))),
                 div(style = "display: inline-block; width: 150px;",
                     checkboxInput("booladults", "Age", value = FALSE)),
                 div(style = "display: inline-block; width: 150px;",
                     checkboxInput("boolclass", "Class", value = FALSE)),
                 plotOutput("alluvialplot")
               )
               # ,
               # br(),
               # br(),
               # 
               # strong('R session info'),
               # verbatimTextOutput("info4.out")
               # 
               )),
    tabPanel("04 Model", icon = icon("robot"),
             fixedRow(
               column(width = 5,
                      includeMarkdown("./txt/model.md")),
               column(
                 width = 7,
                 h4("Logistic regression results:"),
                 p("Pick the independent variables:"),
                 div(style = "display: inline-block; width: 100px;",
                     checkboxInput("bool1", "Pus Cell", value = FALSE)),
                 div(style = "display: inline-block; width: 100px;",
                     checkboxInput("bool2", "Blood Pressure", value = FALSE)),
                 div(style = "display: inline-block; width: 100px;",
                     checkboxInput("bool3", "Age", value = FALSE)),
                 verbatimTextOutput("model")
               )
             )),
    tabPanel("05 Odds Ratio", icon = icon("otter"),
             fixedRow(
               column(width = 6,
                      includeMarkdown("./txt/odds.md"),),
               column(
                 width = 6,
                 tabsetPanel(
                   type = "tabs",
                   tabPanel("Barplot", plotOutput("Pus_Cellplot2")),
                   tabPanel(
                     "Calculator",
                     verbatimTextOutput("odds"),
                     verbatimTextOutput("orperHand")
                     
                   )
                 ),
                 HTML(paste(
                   h4("All the OR from the model you picked in the last pane:")
                 )),
                 plotOutput("modelor")
               )
             )),
    tabPanel(
      "06 Prediction",
      icon = icon("magic"),
      fixedRow(
        includeMarkdown("./txt/prediction.md"),
        column(
          width = 5,
          radioButtons(
            "psex",
            h4("Pus_Cell"),
            choices = list("Normal" = "normal", "Abnormal" = "abnormal"),
            selected = "normal"
          ),
          sliderInput(
            "Age",
            h4("Age"),
            min = 1,
            max = 100,
            value = 50
          ),
          sliderInput(
            "pbp",
            h4("blood_pressure"),
            min = 1,
            max = 3,
            value = 2
          ),
          div(style = "display: inline-block; width: 300px;")
        ),
        column(
          width = 7,
          h4("The prediction result:"),
          plotOutput("predictionplot")
        )
      )
    ),
    tabPanel(
      "07 Performance",
      icon = icon("hat-wizard"),
      fixedRow(
        column(width = 6,
               includeMarkdown("./txt/performance.md"),),
        column(
          width = 6,
          h4("Classification:"),
          plotOutput("performanceplot"),
          h4("ROC Plot:"),
          plotOutput("ROC")
        )
      )
    ),
    tabPanel(
      "07 GGPAIRS Plot ",
      icon = icon("fa-regular fa-broom"),
      fixedRow( column(width = 12, 
                       
                       h4("GGPAIRS Plot:"),
                       plotOutput("gg_p")),
                column(width = 1,
                       includeMarkdown(""),)
                
      ) 
    ),
    
    # 
    # tabPanel("PDF file", 
    #          sidebarPanel(
    #            actionButton("generate", "Generate PDF")
    #          ),
    #          
    #          mainPanel(
    #            uiOutput("pdfview")
    #          ))
    #         ,
    
    tabPanel(
      "08 Reference ",
      icon = icon("fa-regular fa-dragon"),
      fixedRow( column(width = 1,),
        column(width = 12,
               includeMarkdown("./txt/performance2.md"),)
       
      ) 
    ),
    
  )
))
