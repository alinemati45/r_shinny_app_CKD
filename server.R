

#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)
library(ggplot2)
library(titanic)
library(ggbeeswarm)
library(viridis)
library(thematic)
library(broom)
library(tidyverse)
library(ggalluvial)
library(caret)
library(ggmosaic)
library(precrec)
library(waiter)
library(cowplot)





source("utils.R")


library(tidyverse)
#Data Prep#############
#train_df<- titanic::titanic_train
train_df <- read.csv(file = 'data_update.csv')
typeof(train_df)


train_df$class <- factor(train_df$class, 
                            levels = c(0, 1),
                            labels = c("notckd", "ckd")) 

train_df$blood_pressure <- factor(train_df$blood_pressure, 
                          levels = c(1, 2 , 3 ),
                          labels = c("80 or down", "90" , "100 or above")) 
train_df$Age <- as.double(train_df$Age) 
typeof(train_df$Age)
max(train_df$Age)


glm_fit <- glm(class ~ Pus_Cell + Age + blood_pressure , family = binomial(link = 'logit'), data = train_df)




df <- expand.grid(Pus_Cell = c("normal"), 
                  Age = c(44),
                  blood_pressure = 3)




shinyServer(function(input, output) {
    thematic::thematic_shiny()
    Sys.sleep(3) # do something that takes time
    waiter_hide()
    
    
    #Surivivalplots#####
    output$classplot <- renderPlot({
        ggplot(train_df, aes(x= class)) + 
            geom_bar(aes(y = (..count..)/sum(..count..)), fill=c("lightgreen") , width = 0.35)+
        theme_minimal_grid() +
            ylab("Percent")+ theme(  panel.border = element_rect(color = "steelblue", size = 2),
          plot.title = element_text(size = 18),
          axis.title.x = element_text(size = 20),
          axis.title.y = element_text(size = 20),
          axis.text.x = element_text(
            angle = 90,
            vjust = 0.1,
            hjust = 1 ,
            size = 18 , face="bold"
          )  , 
          axis.text.y = element_text(
            angle = 0,
            vjust = 1,
            hjust = 0.1 ,
            size = 18  ,  face="bold"
          ))
     
        
    })
    
    output$Pus_Cellplot1 <- renderPlot({
        ggplot(train_df, aes(x= Pus_Cell, fill = class)) + 
            geom_bar(aes(y = after_stat(count/sum(count))) , width = 0.35)+
            theme_bw()+
            ylab("Percent")+
            theme(legend.position="bottom")+
            theme(text = element_text(size=18))+
            scale_fill_manual(values=c("#009E73","#E69F00")) +
        theme(  panel.border = element_rect(color = "steelblue", size = 2),
                plot.title = element_text(size = 18),
                axis.title.x = element_text(size = 20),
                axis.title.y = element_text(size = 20),
                axis.text.x = element_text(
                  angle = 90,
                  vjust = 0.1,
                  hjust = 1 ,
                  size = 18 , face="bold"
                )  , 
                axis.text.y = element_text(
                  angle = 0,
                  vjust = 1,
                  hjust = 0.1 ,
                  size = 18  ,  face="bold"
                ))
      
        
    })
    
    output$ageplot <- renderPlot({
        ggplot(train_df, aes(x = Age, fill = class) , width = 0.35) + 
            geom_histogram()+
            theme_bw(base_size = 18)+
            ylab("")+
            theme(legend.position="bottom")+
            scale_fill_manual(values=c("#009E73","#E69F00")) +
        theme(  panel.border = element_rect(color = "steelblue", size = 2),
                plot.title = element_text(size = 18),
                axis.title.x = element_text(size = 20),
                axis.title.y = element_text(size = 20),
                axis.text.x = element_text(
                  angle = 90,
                  vjust = 0.1,
                  hjust = 1 ,
                  size = 18 , face="bold"
                )  , 
                axis.text.y = element_text(
                  angle = 0,
                  vjust = 1,
                  hjust = 0.1 ,
                  size = 18  ,  face="bold"
                ))
      
        
    })
    
    
    output$blood_pressure <- renderPlot({
        ggplot(train_df, aes(x= blood_pressure, fill = class) ) + 
            geom_bar(aes(y = (..count..)/sum(..count..)) , width = 0.35)+
            theme_bw(base_size = 18)+
            ylab("Percent")+xlab("Blood pressure")+
            theme(legend.position="bottom")+
            scale_fill_manual(values=c("#009E73","#E69F00")) +
        theme(  panel.border = element_rect(color = "steelblue", size = 2),
                plot.title = element_text(size = 18),
                axis.title.x = element_text(size = 20),
                axis.title.y = element_text(size = 20),
                axis.text.x = element_text(
                  angle = 90,
                  vjust = 0.1,
                  hjust = 1 ,
                  size = 18 , face="bold"
                )  , 
                axis.text.y = element_text(
                  angle = 0,
                  vjust = 1,
                  hjust = 0.1 ,
                  size = 18  ,  face="bold"
                ))
      
        
    })
    
    #IDEA: functional plots#####
    output$funcplot <- renderPlot({
        sigmoid <- function(x){
            return(1/(1 + exp(-x)))
        }
        
        probit <- function(x){
            return(pnorm(x))
        }
      
        ggplot(data.frame(x = c(-5, 5)), aes(x = x)) +
            stat_function(fun = sigmoid, color="#008080", size = 1)+
            stat_function(fun = probit, color="#2C3E50", size = 1)+
            annotate("text", x = 3, y = 0.85, label = c("Logit"), colour = "#008080", size = 6)+
            annotate("text", x = 0.85, y = 0.95, label = c("Probit"), colour = "#2C3E50", size = 6)+
            theme_bw(base_size = 18) +
            ggtitle("") +
          theme(  panel.border = element_rect(color = "steelblue", size = 2),
                  plot.title = element_text(size = 18),
                  axis.title.x = element_text(size = 20),
                  axis.title.y = element_text(size = 20),
                  axis.text.x = element_text(
                    angle = 90,
                    vjust = 0.1,
                    hjust = 1 ,
                    size = 18 , face="bold"
                  )  , 
                  axis.text.y = element_text(
                    angle = 0,
                    vjust = 1,
                    hjust = 0.1 ,
                    size = 18  ,  face="bold"
                  ))
        
        
    })
    
    
    
    output$distplot2 <- renderPlot({
        set.seed(2)
        y <- rep(c(0,1), 500)
        x <- 10 + rnorm(250, 3, 3)+ rnorm(250, 10, 3)*y
        
        data <- data.frame(x, y) %>%
          as_tibble
        
        ggplot(data, aes(x = x, y = y)) + 
            geom_point(color = "gray")+
            geom_smooth(method='lm', formula= y~x, colour = "#008080")+
            theme_bw(base_size = 18) +
          theme(  panel.border = element_rect(color = "steelblue", size = 2),
                  plot.title = element_text(size = 18),
                  axis.title.x = element_text(size = 20),
                  axis.title.y = element_text(size = 20),
                  axis.text.x = element_text(
                    angle = 90,
                    vjust = 0.1,
                    hjust = 1 ,
                    size = 18 , face="bold"
                  )  , 
                  axis.text.y = element_text(
                    angle = 0,
                    vjust = 1,
                    hjust = 0.1 ,
                    size = 18  ,  face="bold"
                  ))
        
        
    })
    
    
    output$scatter_log <- renderPlot({
        set.seed(2)
        y <- rep(c(0,1), 500)
        x <- 10 + rnorm(250, 3, 3)+ rnorm(250, 10, 3)*y
        
        data <- data.frame(x, y) %>%
            as.tibble
        
        if (input$boolmethod == TRUE) {
            ggplot(data, aes(x= x, y = y)) + 
                geom_point(color = "gray")+
                geom_smooth(method = "glm", 
                            method.args = list(family = "binomial"), colour = "#008080")+
                theme_bw(base_size = 18) +
            theme(  panel.border = element_rect(color = "steelblue", size = 2),
                    plot.title = element_text(size = 18),
                    axis.title.x = element_text(size = 20),
                    axis.title.y = element_text(size = 20),
                    axis.text.x = element_text(
                      angle = 90,
                      vjust = 0.1,
                      hjust = 1 ,
                      size = 18 , face="bold"
                    )  , 
                    axis.text.y = element_text(
                      angle = 0,
                      vjust = 1,
                      hjust = 0.1 ,
                      size = 18  ,  face="bold"
                    ))
          
        } else {
            ggplot(data, aes(x = x, y = y)) + 
                geom_point(color = "gray")+
                geom_smooth(method='lm', formula= y~x, colour = "#008080")+
                theme_bw(base_size = 18) +
            theme(  panel.border = element_rect(color = "steelblue", size = 2),
                    plot.title = element_text(size = 18),
                    axis.title.x = element_text(size = 20),
                    axis.title.y = element_text(size = 20),
                    axis.text.x = element_text(
                      angle = 90,
                      vjust = 0.1,
                      hjust = 1 ,
                      size = 18 , face="bold"
                    )  , 
                    axis.text.y = element_text(
                      angle = 0,
                      vjust = 1,
                      hjust = 0.1 ,
                      size = 18  ,  face="bold"
                    ))
          
            
        }
        
    })
    
    #Alluvialplot#####
    output$alluvialplot <- renderPlot({
        
        thematic_off()
        
        if (input$booladults == TRUE & input$boolclass == FALSE) {
          all_adults
        } else if (input$booladults == FALSE & input$boolclass == TRUE) {
          all_class
        } else if (input$booladults == TRUE & input$boolclass == TRUE) {
          all_overall
        } else {
          all_sex
        }
        
        
    })
    
    
    
    #Model: output########
    output$model <- renderPrint({
        if (input$bool1 == TRUE & input$bool2 == FALSE &  input$bool3 == FALSE) {
          summary(model_call("m1"))
        } else if (input$bool1 == FALSE & input$bool2 == TRUE & input$bool3 == FALSE) {
          summary(model_call("m2"))
        } else if (input$bool1 == FALSE & input$bool2 == FALSE & input$bool3 == TRUE) {
          summary(model_call("m3"))
        } else if (input$bool1 == TRUE & input$bool2 == TRUE & input$bool3 == FALSE) {
          summary(model_call("m4"))
        } else if (input$bool1 == TRUE & input$bool2 == TRUE & input$bool3 == TRUE) {
          summary(model_call("m5"))
        } else if (input$bool1 == TRUE & input$bool2 == FALSE & input$bool3 == TRUE) {
          summary(model_call("m6"))
        } else if (input$bool1 == FALSE & input$bool2 == TRUE & input$bool3 == TRUE) {
          summary(model_call("m7"))
        } else {
            print("Pick at least one independent variable, my friend .-)")
        }
    })
    
    #ODDS RATIO#####

    
    #ODDS RATIO#####
    output$Pus_Cellplot2 <- renderPlot({
      thematic_on()
      
      ggplot(train_df, aes(x= blood_pressure, fill = class) , width = 0.35) + 
        geom_bar( width = 0.35)+
        geom_text(stat='count', aes(label=..count..), vjust=-1,
                  position = position_stack(vjust = 0), size = 6)+
        theme_bw(base_size = 18)+
        ylab("Count")+
        theme(legend.position="bottom")
    })
    
    
    
    
    output$odds <- renderText({ 
        "First's Class odds: 104/84: 1.23809524 \nSecond's Class odds: 52/66: 0.787878788 \nThird's Class odds: 87/6: 14.5"
        
    })
    
    
    output$orperHand <- renderPrint({
        Oddfirstclass <- 103/86
        Oddfirstclass
        
        Oddsecondclass <- 51/68
        Oddsecondclass
        
        Oddthierdclass <- 85/6
        Oddthierdclass
        
    })
    
    
    #OR for each model#####
    output$modelor <- renderPlot({
        thematic_shiny()  
        
        if (input$bool1 == TRUE & input$bool2 == FALSE & input$bool3 == FALSE) {
          or1
        } else if (input$bool1 == FALSE & input$bool2 == TRUE & input$bool3 == FALSE) {
          or2
        } else if (input$bool1 == FALSE & input$bool2 == FALSE & input$bool3 == TRUE) {
          or3
        } else if (input$bool1 == TRUE & input$bool2 == TRUE & input$bool3 == FALSE) {
          or4
        } else if (input$bool1 == TRUE & input$bool2 == TRUE & input$bool3 == TRUE) {
          or5
        } else if (input$bool1 == TRUE & input$bool2 == FALSE & input$bool3 == TRUE) {
          or6
        } else if (input$bool1 == FALSE & input$bool2 == TRUE & input$bool3 == TRUE) {
          or7
        } else {
            print("Still, you have to pick at least one independent variable, my friend .-)")
        }
        
    })
    
    
    #Prediction#####
    #Prediction#####
    output$predictionplot <- renderPlot({
      #glm_fit <- glm(Survived ~ Sex + Age + as.numeric(Pclass) , family = binomial(link = 'logit'), data = train_df)
      glm_fit <- glm(class ~ Pus_Cell + Age + as.numeric(blood_pressure) , family = binomial(link = 'logit'), data = train_df)
      
      df$Age <- input$Age
      df$Pus_Cell <- input$psex
      df$blood_pressure <- input$pbp
      df$total <- 100
      df$prediction <- round(predict(glm_fit, df, type = 'response'),3)*100
      thematic_off()
      # df <- expand.grid(Pus_Cell = c("normal"), 
      #                   Age = c(44),
      #                   blood_pressure = 3)
      
      ggplot(df, aes(x=Age, y=prediction)) + 
        geom_col(fill = "#E69F00") +
        geom_col(aes(y = total), alpha = 0.01, colour = "gray")+
        geom_text(aes(label = paste(prediction, "%")), 
                  hjust = 0, color="#2C3E50", size = 8)+
        coord_flip()+
        theme_minimal(base_size = 18) +
        ylab("Predicted probability of survival")+
        xlab("")+
        theme(axis.title.y=element_blank(), axis.text.y=element_blank(),
              axis.ticks.y=element_blank())
    })
    
    
    #Performance#####
    output$performanceplot <- renderPlot({
        thematic_off()
        pred_plot
    })
    
    
    #ROC plot#####
    output$ROC <- renderPlot({
        thematic_off()
      roc_curve
        
    })
    
    

})
