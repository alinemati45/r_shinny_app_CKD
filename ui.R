library(shiny)
library(shinyAce)
library(pwr)
library(vcd)
library(tidyverse)
library(shiny)
library(ggmosaic)
library(caret)
library(purrr)
library(shinyAce)
library(shinyjs)




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
shinyUI(
  fixedPage(
    theme = bslib::bs_theme(bootswatch = "flatly"),
    
    use_waiter(),
    waiter_show_on_load(html = spin_flower()),
    
    
    
    ########## Adding loading message #########
    
    tags$head(
      tags$style(
        type = "text/css",
        "
#loadmessage {
position: fixed;
top: 0px;
left: 0px;
width: 75%;
padding: 10px 0px 10px 0px;
text-align: center;
font-weight: bold;
font-size: 100%;
color: #000000;
background-color: #CCFF66;
z-index: 105;

}
")
    ),
    
    conditionalPanel(condition = "$('html').hasClass('shiny-busy')",
                     tags$div("Loading...", id = "loadmessage")),
    
    ########## Added up untill here ##########
    
    
    
    
    
    
    
    
    # Application title
    #titlePanel("Old Faithful Geyser Data"),
    
    # Sidebar with a slider input for number of bins
    navbarPage(
      "High Blood Pressure can affect CKD?"     ,
      # ,
      collapsible = TRUE,
      tabPanel("1. Start", icon = icon("play"),
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
                     ) )
                 ) ,
               )
               ) ,
      tabPanel("2. Variables", icon = icon("chart-pie"),
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
      tabPanel(
        "3. GGPAIRS Plot ",
        icon = icon("fa-regular fa-broom"),
        
        fixedRow(
          column(width = 12,
                 
                 h4("GGPAIRS Plot:"),
                 plotOutput("gg_p")),
          column(width = 1,
                 includeMarkdown(""), )
          
        )
      ),
      
      tabPanel(
        "3. Test of Independence (Tabulated data)",
        
        h2("Test of Independence (Tabulated data)"),
        
        # h5("H0: There is no association of one unit increase in blood pressure with chronic kidney disease risk. "),
        # h5("H1: There is no association of one unit increase in blood pressure with chronic kidney disease risk. "),
        p(
          HTML(
            "<b><div style='background-color:#FADDF2;border:1px solid black;'>H0: There is no association of one unit increase in blood pressure with chronic kidney disease risk.</div></b>"
          )
        ),
        p(
          HTML(
            "<b><div style='background-color:#FADDF2;border:1px solid black;'>H1: There is association of one unit increase in blood pressure with chronic kidney disease risk.</div></b>"
          )
        ),
        
        h4("Two or more than two nominal variables"),
        
        p(
          'Note: Input values must be separated by tabs. Copy and paste from Excel/Numbers.\nYour data needs to have the header (variable names) in the first row. Missing values should be indicated by a period'
        ),
        
        
        aceEditor(
          "text4",
          value = "\tLow\tMid\tHigh\nCKD\t98\t52\t81\nNotCKD\t91\t66\t12",
          mode = "r",
          theme = "cobalt"
        ),
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
      tabPanel("5. Idea", icon = icon("lightbulb"),
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
               )),
     
      tabPanel("6. Model", icon = icon("robot"),
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
      tabPanel(
        "07 Prediction",
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
        "8. Performance",
        icon = icon("hat-wizard"),
        fixedRow(
          column(width = 6,
                 includeMarkdown("./txt/performance.md"), ),
          column(
            width = 6,
            h4("Classification:"),
            plotOutput("performanceplot"),
            h4("ROC Plot:"),
            plotOutput("ROC")
          )
        )
      ),
      tabPanel("9. Odds Ratio", icon = icon("otter"),
               fixedRow(
                 column(width = 6,
                        includeMarkdown("./txt/odds.md"), ),
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
        "10. Limitation ",
        icon = icon("fa-solid fa-database"),
        fixedRow(column(width = 1, ),
                 column(
                   width = 12,
                   includeMarkdown("./txt/limitation.md"),
                 ))
      ),

   

      tabPanel(
        "11. Reference ",
        icon = icon("fa-regular fa-dragon"),
        fixedRow(column(width = 1, ),
                 column(
                   width = 12,
                   includeMarkdown("./txt/performance2.md"),
                 ))
      ),
      
      ## REPORT
      tabPanel(
        "12. Download reports ",
        icon = icon("fa-thin fa-download"),
        "You may downlaod report here as HTML:",
        br(),
        downloadButton("report", " Generate report"),
        #downloadLink("downloadData", "Download")
        br(),
        br(),
        "Download all Source Code files from github: ",
        br(),
        actionButton(
          "code",
          " Source Code",
          onclick = "window.open('https://github.com/alinemati45/r_shinny_app_CKD/', '_blank')",
          icon = icon("github")
        )
        ,
        br(),
        br(),
        "You may downlaod report all file as pdf:",
        br(),
        div(
          style = "display: inline-block; width: 150px;",
          actionButton(
            "download",
            " Download",
            onclick = "window.open('https://raw.githubusercontent.com/alinemati45/r_shinny_app_CKD_potassium/main/report.pdf')",
            icon = icon("file")
          )
        ) ,
        br(),
        br(),
        "You may downlaod csv file of the project:",
        br(),
        div(
          style = "display: inline-block; width: 150px;",
          actionButton(
            "download",
            " Download",
            onclick = "window.open('https://github.com/alinemati45/r_shinny_app_CKD/blob/main/data/data.csv')",
            icon = icon("fa-solid fa-file-csv")
          )
        )
      ),
      ##  Principal Component Analysis For FUTURE WORK
      
      # tabPanel(
      #   "13. Principal Component Analysis For FUTURE WORK ",
      #   icon = icon("fa-regular fa-broom"),
      #   headerPanel("Principal Component Analysis"),
      #   
      #   
      #   
      #   h3("Data"),
      #   p(
      #     'Input values must be separated by tabs. Copy and paste from Excel/Numbers.'
      #   ),
      #   p(
      #     HTML(
      #       "<b><div style='background-color:#FADDF2;border:1px solid black;'>Please make sure that your data includes the header (variable names) in the first row.</div></b>"
      #     )
      #   ),
      #   
      #   strong('Option:'),
      #   checkboxInput(
      #     "rowname",
      #     label = strong("The first column contains index."),
      #     value = T
      #   ),
      #   
      #   aceEditor(
      #     "text",
      #     value = "index\tclass\tAge\tPus_Cell\n1\t1\t59\t1\n2\t1\t34\t1\n3\t1\t54\t1\n4\t1\t34\t1\n5\t1\t57\t1\n6\t1\t59\t1\n7\t1\t62\t1\n8\t1\t65\t1\n9\t1\t69\t1\n10\t1\t80\t1\n11\t1\t45\t1\n12\t1\t45\t1\n13\t1\t54\t1\n14\t1\t54\t1\n15\t1\t67\t1\n16\t1\t68\t1\n17\t1\t73\t1\n18\t1\t46\t1\n19\t1\t50\t1\n20\t1\t56\t1\n21\t1\t60\t1\n22\t1\t56\t1\n23\t1\t2\t1\n24\t1\t24\t1\n25\t1\t59\t1\n26\t1\t47\t1\n27\t1\t48\t1\n28\t1\t61\t1\n29\t1\t32\t1\n30\t1\t52\t1\n31\t1\t54\t1\n32\t1\t55\t1\n33\t1\t56\t1\n34\t1\t45\t1\n35\t1\t49\t1\n36\t1\t5\t0\n37\t1\t7\t0\n38\t1\t8\t0\n39\t1\t60\t0\n40\t1\t8\t0\n41\t1\t15\t0\n42\t1\t17\t0\n43\t0\t17\t0\n44\t0\t20\t0\n45\t0\t22\t0\n46\t0\t23\t0\n47\t0\t25\t0\n48\t0\t28\t0\n49\t0\t30\t0\n50\t0\t30\t0\n51\t0\t32\t0\n52\t0\t33\t0\n53\t0\t33\t0\n54\t1\t34\t0\n55\t0\t34\t0\n56\t0\t35\t0\n57\t0\t37\t0\n58\t0\t37\t0\n59\t0\t38\t0\n60\t0\t39\t0\n61\t0\t43\t0\n62\t0\t43\t0\n63\t0\t44\t0\n64\t0\t44\t0\n65\t1\t46\t0\n66\t0\t46\t0\n67\t0\t46\t0\n68\t0\t47\t0\n69\t0\t47\t0\n70\t0\t47\t0\n71\t0\t48\t0\n72\t0\t51\t0\n73\t0\t53\t0\n74\t0\t56\t0\n75\t0\t57\t0\n76\t0\t57\t0\n77\t0\t59\t0\n78\t0\t60\t0\n79\t0\t64\t0\n80\t1\t65\t0\n81\t0\t65\t0\n82\t0\t68\t0\n83\t1\t71\t0\n84\t0\t71\t0\n85\t0\t72\t0\n86\t0\t73\t0\n87\t0\t74\t0\n88\t1\t17\t0\n89\t1\t19\t0\n90\t0\t20\t0\n91\t0\t24\t0\n92\t0\t25\t0\n93\t1\t26\t0\n94\t0\t29\t0\n95\t1\t30\t0\n96\t0\t32\t0\n97\t1\t34\t0\n98\t0\t34\t0\n99\t0\t34\t0\n100\t1\t39\t0\n101\t0\t39\t0\n102\t0\t39\t0\n103\t1\t40\t0\n104\t0\t41\t0\n105\t0\t42\t0\n106\t0\t42\t0\n107\t1\t44\t0\n108\t0\t44\t0\n109\t0\t44\t0\n110\t1\t45\t0\n111\t0\t46\t0\n112\t1\t47\t0\n113\t1\t48\t0\n114\t1\t48\t0\n115\t1\t50\t0\n116\t1\t50\t0\n117\t1\t55\t0\n118\t0\t55\t0\n119\t1\t56\t0\n120\t0\t56\t0\n121\t0\t58\t0\n122\t0\t58\t0\n123\t0\t59\t0\n124\t1\t60\t0\n125\t1\t60\t0\n126\t0\t60\t0\n127\t0\t61\t0\n128\t0\t61\t0\n129\t0\t63\t0\n130\t0\t63\t0\n131\t1\t64\t0\n132\t0\t64\t0\n133\t1\t65\t0\n134\t1\t65\t0\n135\t1\t66\t0\n136\t0\t66\t0\n137\t0\t66\t0\n138\t1\t67\t0\n139\t1\t67\t0\n140\t1\t68\t0\n141\t1\t69\t0\n142\t0\t69\t0\n143\t0\t71\t0\n144\t1\t73\t0\n145\t1\t75\t0\n146\t0\t75\t0\n147\t1\t76\t0\n148\t1\t80\t0\n149\t0\t80\t0\n150\t1\t34\t0\n151\t1\t11\t0\n152\t0\t12\t0\n153\t0\t15\t0\n154\t0\t19\t0\n155\t0\t23\t0\n156\t0\t23\t0\n157\t0\t23\t0\n158\t0\t24\t0\n159\t0\t24\t0\n160\t0\t25\t0\n161\t0\t29\t0\n162\t0\t29\t0\n163\t0\t30\t0\n164\t0\t30\t0\n165\t0\t30\t0\n166\t0\t30\t0\n167\t0\t33\t0\n168\t0\t33\t0\n169\t0\t33\t0\n170\t0\t34\t0\n171\t1\t35\t0\n172\t0\t35\t0\n173\t1\t36\t0\n174\t0\t36\t0\n175\t0\t38\t0\n176\t0\t40\t0\n177\t0\t40\t0\n178\t1\t41\t0\n179\t0\t41\t0\n180\t0\t41\t0\n181\t0\t42\t0\n182\t0\t42\t0\n183\t0\t43\t0\n184\t0\t43\t0\n185\t0\t43\t0\n186\t0\t45\t0\n187\t0\t45\t0\n188\t0\t47\t0\n189\t0\t47\t0\n190\t1\t48\t0\n191\t1\t48\t0\n192\t0\t48\t0\n193\t0\t48\t0\n194\t0\t49\t0\n195\t0\t50\t0\n196\t0\t50\t0\n197\t1\t51\t0\n198\t0\t51\t0\n199\t0\t52\t0\n200\t0\t52\t0\n201\t0\t52\t0\n202\t1\t55\t0\n203\t0\t55\t0\n204\t0\t55\t0\n205\t0\t55\t0\n206\t0\t55\t0\n207\t0\t55\t0\n208\t1\t56\t0\n209\t0\t56\t0\n210\t1\t57\t0\n211\t0\t57\t0\n212\t0\t57\t0\n213\t0\t58\t0\n214\t0\t58\t0\n215\t1\t59\t0\n216\t1\t60\t0\n217\t0\t60\t0\n218\t0\t60\t0\n219\t1\t61\t0\n220\t1\t61\t0\n221\t0\t62\t0\n222\t0\t62\t0\n223\t1\t65\t0\n224\t1\t65\t0\n225\t1\t65\t0\n226\t0\t67\t0\n227\t1\t69\t0\n228\t0\t70\t0\n229\t0\t73\t0\n230\t1\t74\t0\n231\t1\t75\t0\n232\t0\t79\t0\n233\t0\t80\t0\n234\t1\t33\t0\n235\t1\t34\t0\n236\t1\t44\t0\n237\t1\t46\t0\n238\t1\t60\t0\n239\t1\t61\t0\n240\t1\t62\t0\n241\t0\t63\t0\n242\t0\t68\t0\n243\t0\t70\t0\n244\t1\t71\t0\n245\t1\t72\t0\n246\t1\t76\t0\n247\t1\t90\t0\n248\t1\t37\t0\n249\t1\t53\t0\n250\t1\t59\t0\n251\t1\t60\t0\n252\t1\t63\t0\n253\t1\t65\t0\n254\t1\t70\t0\n255\t1\t46\t0\n256\t1\t58\t0\n257\t1\t54\t0\n258\t1\t3\t0\n259\t1\t4\t0\n260\t0\t50\t0\n261\t1\t61\t0\n262\t1\t21\t0\n263\t1\t45\t0\n264\t1\t46\t0\n265\t1\t67\t0\n266\t1\t83\t0\n267\t1\t54\t0\n268\t1\t40\t0\n269\t1\t46\t0\n270\t1\t62\t0\n271\t1\t53\t0\n272\t1\t61\t0\n273\t1\t62\t0\n274\t1\t65\t0\n275\t1\t65\t0\n276\t1\t47\t0\n277\t1\t59\t0\n278\t1\t5\t0\n279\t0\t75\t0\n280\t0\t51\t1\n281\t1\t54\t1\n282\t1\t69\t1\n283\t0\t70\t1\n284\t1\t74\t1\n285\t1\t81\t1\n286\t0\t35\t1\n287\t1\t38\t1\n288\t0\t44\t1\n289\t1\t45\t1\n290\t1\t54\t1\n291\t1\t54\t1\n292\t1\t59\t1\n293\t1\t60\t1\n294\t1\t60\t1\n295\t1\t61\t1\n296\t0\t65\t1\n297\t1\t66\t1\n298\t1\t68\t1\n299\t1\t70\t1\n300\t0\t71\t1\n301\t1\t75\t1\n302\t1\t35\t1\n303\t1\t47\t1\n304\t0\t47\t1\n305\t1\t56\t1\n306\t1\t60\t1\n307\t1\t62\t1\n308\t1\t62\t1\n309\t1\t63\t1\n310\t1\t65\t1\n311\t1\t70\t1\n312\t1\t82\t1\n313\t0\t19\t1\n314\t1\t45\t1\n315\t0\t55\t1\n316\t1\t60\t1\n317\t1\t60\t1\n318\t1\t60\t1\n319\t0\t72\t1\n320\t1\t72\t1\n321\t0\t47\t1\n322\t1\t48\t1\n323\t1\t55\t1\n324\t0\t8\t1\n325\t0\t14\t1\n326\t0\t62\t1\n327\t0\t73\t1\n328\t1\t27\t1\n329\t1\t53\t1\n330\t1\t78\t1\n331\t1\t34\t1\n332\t1\t64\t1\n333\t1\t57\t1\n334\t1\t67\t1\n335\t1\t72\t1\n336\t1\t50\t1\n337\t1\t76\t1\n338\t1\t32\t1\n339\t1\t59\t1\n340\t0\t72\t1\n341\t0\t50\t1\n342\t1\t50\t1\n343\t1\t12\t1\n344\t0\t45\t1\n345\t0\t62\t1\n346\t0\t65\t1\n347\t0\t45\t1\n348\t0\t63\t1\n349\t0\t68\t1\n350\t0\t76\t1\n351\t1\t64\t1\n352\t1\t67\t1\n353\t1\t72\t1\n354\t1\t73\t1\n355\t1\t73\t1\n356\t1\t70\t1\n357\t1\t73\t1\n358\t1\t50\t1\n359\t1\t60\t1\n360\t1\t48\t1\n361\t1\t60\t1\n362\t1\t76\t1\n363\t1\t42\t1\n364\t1\t53\t1\n365\t1\t56\t1\n366\t1\t64\t1\n367\t1\t52\t1\n368\t1\t71\t0\n369\t1\t65\t0\n370\t1\t65\t0\n371\t1\t68\t0\n372\t1\t65\t0\n373\t1\t54\t0\n374\t1\t48\t0\n375\t1\t6\t1\n376\t1\t64\t1\n377\t1\t48\t1\n378\t1\t70\t1\n379\t1\t42\t1\n380\t1\t64\t1\n381\t1\t41\t1\n382\t1\t57\t1\n383\t1\t60\t0\n384\t1\t66\t0\n385\t1\t51\t0\n386\t1\t63\t0\n387\t1\t71\t1\n388\t1\t43\t1\n389\t1\t55\t1\n390\t1\t68\t1\n391\t1\t71\t1\n392\t1\t69\t1\n393\t1\t21\t1\n394\t1\t50\t1\n395\t1\t50\t0\n396\t1\t70\t1\n397\t0\t45\t0\n398\t0\t28\t0\n399\t0\t35\t0\n400\t0\t54\t1\n",
      #     mode = "r",
      #     theme = "ambiance",
      #   ),
      #   
      #   br(),
      #   
      #   h3("Basic statistics"),
      #   verbatimTextOutput("textarea.out"),
      #   
      #   br(),
      #   
      #   h3("Correlation"),
      #   verbatimTextOutput("correl.out"),
      #   
      #   br(),
      #   
      #   strong("Scatter plot matrices"),
      #   
      #   br(),
      #   
      #   
      #   plotOutput("corPlot"),
      #   
      #   br(),
      #   
      #   h3("Scree plot"),
      #   
      #   
      #   plotOutput("sPlot", width = "80%"),
      #   
      #   br(),
      #   br(),
      #   br(),
      #   br(),
      #   
      #   h3("Plot"),
      #   
      #   plotOutput("pcPlot1", height = "600px"),
      #   
      #   br(),
      #   
      #   
      #   plotOutput("pcPlot2", height = "500px"),
      #   
      #   br(),
      #   
      #   
      #   plotOutput("pcPlot3", height = "500px"),
      #   
      #   br(),
      #   
      #   h4("Biplot"),
      #   
      #   plotOutput("pcPlot4", height = "700px"),
      #   
      #   br(),
      #   
      #   h4("Cluster analysis using the principal component scores"),
      #   p("(Ward method with the squared Euclidean distance technique)"),
      #   
      #   plotOutput("pcPlot5" , height = "700px"),
      #   
      #   br(),
      #   br(),
      #   h3("Results of principal component analysis"),
      #   verbatimTextOutput("pcaresult.out"),
      #   
      #   
      #   
      #   strong('R session info'),
      #   verbatimTextOutput("info.out")
      #   
      #   
      # ),
      tabPanel(
        "14. Contact ",
        icon = icon("fa-thin fa-file-signature"),
        
        fixedRow(column(width = 1, ),
                 column(
                   width = 12,
                   includeMarkdown("./txt/Contact.md"),
                 ))
      )
    )
  )
)
