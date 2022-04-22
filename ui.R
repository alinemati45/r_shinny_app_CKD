
#
#    http://shiny.rstudio.com/
#


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
    
    
    


    
    # Application title
    #titlePanel("Old Faithful Geyser Data"),
    
    # Sidebar with a slider input for number of bins 
    navbarPage("High Blood Pressure can affect CKD?", collapsible = TRUE,
               tabPanel("00 Start", icon = icon("play"),
                        fixedRow(
                            column(width = 6,
                                   includeMarkdown("./txt/start.md"),
                                   div(style="display: inline-block; width: 150px;",
                                       actionButton("code", "Source Code", 
                                                    onclick ="window.open('https://github.com/alinemati45/r_shinny_app_CKD_potassium', '_blank')", 
                                                    icon = icon("github"))),
                                   div(style="display: inline-block; width: 150px;",
                                       actionButton("download", "Download", 
                                                    onclick ="window.open('https://raw.githubusercontent.com/alinemati45/r_shinny_app_CKD_potassium/main/report.pdf')", 
                                                    icon = icon("file")))
                            ),
                            column(width = 6,
                                   tabsetPanel(type = "tabs", 
                                               tabPanel("Class",
                                                        h4("Class of the Chronic Kidney Disease :"),  
                                                        plotOutput("classplot")),
                                               tabPanel("Pus Cell", 
                                                        h4("Chronic Kidney Disease Class by Pus Cell:"),
                                                        plotOutput("Pus_Cellplot1")),
                                               tabPanel("Blood Pressure",  
                                                        h4("Blood Pressure by the Chronic Kidney Disease:"),
                                                        plotOutput("blood_pressure")),
                                               tabPanel("Age ",  
                                                        h4("Chronic Kidney Disease by Age:"),
                                                        plotOutput("ageplot"))
                                               
                                   )
                            )
                        )
               ),
               tabPanel("01 Idea", icon = icon("lightbulb"),
                        fixedRow(
                            column(width = 6,
                                   includeMarkdown("./txt/idea.md"),
                                   h4("Insert the logit in the scatterplot:"),
                                   checkboxInput("boolmethod", "Logit!", 
                                                 value = FALSE)
                            ),
                            column(width = 6,
                                   tabsetPanel(type = "tabs",
                                               tabPanel("Scatterplot", plotOutput("scatter_log")),
                                               tabPanel("Function", plotOutput("funcplot"))
                                   )
                            )
                        )
               ),
               tabPanel("02 Variables", icon = icon("chart-pie"),
                        fixedRow(
                            column(width = 6,
                                   includeMarkdown("./txt/variables.md")
                            ),
                            column(width = 6,
                                   HTML(paste(h4("Add a variable:"))),
                                   div(style="display: inline-block; width: 150px;",
                                       checkboxInput("booladults", "Age", value = FALSE)),
                                   div(style="display: inline-block; width: 150px;",
                                       checkboxInput("boolclass", "Class", value = FALSE)),
                                   plotOutput("alluvialplot")
                            )
                        )
               ),
               tabPanel("03 Model", icon = icon("robot"),
                        fixedRow(
                            column(width = 5,
                                   includeMarkdown("./txt/model.md")
                            ),
                            column(width = 7,
                                   h4("Logistic regression results:"),
                                   p("Pick the independent variables:"),
                                   div(style="display: inline-block; width: 100px;",
                                       checkboxInput("bool1", "Pus Cell", value = FALSE)),
                                   div(style="display: inline-block; width: 100px;",
                                       checkboxInput("bool2", "Blood Pressure", value = FALSE)),
                                   div(style="display: inline-block; width: 100px;",
                                       checkboxInput("bool3", "Age", value = FALSE)),
                                   verbatimTextOutput("model")
                            )
                        )
               ),
               tabPanel("04 Odds Ratio", icon = icon("otter"),
                        fixedRow(
                            column(width = 6,
                                   includeMarkdown("./txt/odds.md"),
                            ),
                            column(width = 6,
                                   tabsetPanel(type = "tabs",
                                               tabPanel("Barplot", plotOutput("Pus_Cellplot2")),
                                               tabPanel("Calculator", verbatimTextOutput("odds"),
                                                        verbatimTextOutput("orperHand")
                                                        
                                                        )
                                   ),
                                   HTML(paste(h4("All the OR from the model you picked in the last pane:"))),
                                   plotOutput("modelor")
                            )
                        )
               ),
               tabPanel("05 Prediction", icon = icon("magic"),
                        fixedRow(
                            includeMarkdown("./txt/prediction.md"),
                            column(width = 5,
                                   radioButtons("psex", 
                                                h4("Pus_Cell"),
                                                choices = list("Normal" = "normal", "Abnormal" = "abnormal"), 
                                                selected = "normal"),
                                   sliderInput("Age", 
                                               h4("Age"),
                                               min = 1,
                                               max = 100,
                                               value = 50),
                                   sliderInput("pbp", 
                                               h4("blood_pressure"),
                                               min = 1,
                                               max = 4,
                                               value = 2),
                                   div(style="display: inline-block; width: 300px;")
                            ),
                            column(width = 7,
                                   h4("The prediction result:"),
                                   plotOutput("predictionplot")
                            )
                        )
               ),
               tabPanel("06 Performance", icon = icon("hat-wizard"),
                        fixedRow(
                            column(width = 6,
                                   includeMarkdown("./txt/performance.md"),
                            ),
                            column(width = 6,
                                   h4("Classification:"),
                                   plotOutput("performanceplot"),
                                   h4("ROC Plot:"),
                                   plotOutput("ROC")
                            )
                        )
               )
               ,
               tabPanel("07 Performance  2", icon = icon("hat-wizard"),
                        fixedRow(
                          column(width = 1,
                                 includeMarkdown("./txt/performance2.md"),
                          ),
                          column(width = 12,

                                 h4("GGPAIRS Plot:"),
                                 plotOutput("gg_p")
                          )
                        )
               )
    )
))
