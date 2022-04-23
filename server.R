library(shiny)
library(shinyAce)
library(pwr)
library(vcd)
# https://alinemati.shinyapps.io/CKD-App-main
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
library(markdown)
#install.packages("rsconnect")
library(rsconnect)


source("app.R" ,local=T)


library(tidyverse)
#Data Prep#############
#train_df<- titanic::titanic_train
train_df <- read.csv(file = './data_update.csv')
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
            ylab("Percent per population")+ theme(  panel.border = element_rect(color = c("steelblue" , "blue"), size = 2),
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
        "First's Class odds: 98/91: 1.07692308 \nSecond's Class odds: 52/66: 0.787878788 \nThird's Class odds: 81/12: 6.75"
        
    })
    
    
    output$orperHand <- renderPrint({
        Oddfirstclass <- 98/91
        Oddfirstclass
        
        Oddsecondclass <- 52/66
        Oddsecondclass
        
        Oddthierdclass <- 81/12
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
    
    # GGP#####
    output$gg_p <- renderPlot({
      thematic_off()
      gg_p
      
    })
    
    
    
    #----------------------------------------------------
    # 4. Test of Independence (Tabulated data)
    #----------------------------------------------------
    
    data4 <- reactive({
      
      dat <- read.csv(text=input$text4, sep="", na.strings=c("","NA","."))
      
      x <- as.matrix(dat)
      x <- addmargins(x)
      
      print(x)
    })
    
    output$data4.out <- renderPrint({
      data4()
    })
    
    
    
    
    
    test4 <- reactive({
      
      dat <- read.csv(text=input$text4, sep="", na.strings=c("","NA","."))
      
      x <- as.matrix(dat)
      
      
      a <- chisq.test(x, correct=F)           # Pearson's Chi-squared
      b <- chisq.test(x)                      # Yates
      c <- assocstats(x)                      # Likelihood Ratio
      
      aa <- data.frame(a[4], a[1], a[2], a[3])
      aa[1] <- c("Pearson's Chi-squared")
      row.names(aa) <- NULL
      
      bb <- data.frame(b[4], b[1], b[2], b[3])
      bb[1] <- c("Yates' Continuity Correction")
      row.names(bb) <- NULL
      
      cc <- data.frame(c[2])[1,]
      cc <- data.frame(c("Log-likelihood Ratio (G)"), cc[,1], cc[,2], cc[,3])
      names(cc) <- c("method", "statistic", "parameter", "p.value")
      
      
      # Fisher's Exact Test
      e <- try(fisher.test(x, workspace=3000000), silent = FALSE)   # try, fisher.test
      if (class(e) == "try-error") {
        dd <- data.frame(c(""), c(""), c(""), c("data too large"))  # if error
        dd[1] <- c("Fisher's Exact Test")
        names(dd) <- c("method", "statistic", "parameter", "p.value")
        row.names(dd) <- NULL
      } else {
        d <- fisher.test(x, workspace=3000000)    # no error
        if (nrow(x) * ncol(x) == 4) { # Only for the 2×2 table
          dd <- data.frame(d[6], c(""), c(""), d[1])
        } else {
          dd <- data.frame(d[3], c(""), c(""), d[1])
        }
        dd[1] <- c("Fisher's Exact Test")
        names(dd) <- c("method", "statistic", "parameter", "p.value")
        row.names(dd) <- NULL
      }
      
      
      res <- rbind(aa, bb, cc, dd)
      res[2] <- round(as.numeric(res[,2]), 4)
      res[2][4,] <- ""
      names(res) <- c("Test", "X-squared", "df", "p-value")
      cat("\n")
      print(res)
      
      
      
      
      cat("\n")
      cat("\n", "------------------------------------------------------", "\n",
          "Effect size:", "\n")
      
      # Cramer's V [95%CI]
      V <- sqrt(chisq.test(x, correct=F)$statistic[[1]]/(sum(x)*(min(nrow(x)-1,ncol(x)-1)))) #nrow(x)"-1"追加
      fisherZ <- 0.5 * log((1 + V)/(1 - V))
      fisherZ.se <- 1/sqrt(sum(x) - 3) * qnorm(1 - ((1 - 0.95)/2))
      fisherZ.ci <- fisherZ + c(-fisherZ.se, fisherZ.se)
      ci.V <- (exp(2 * fisherZ.ci) - 1)/(1 + exp(2 * fisherZ.ci))
      
      cat("\n", "Cramer's V [95%CI] =", V, "[", ci.V[1], ",",ci.V[2],"]", "\n")
      
      
      # Odds Ratio
      if (nrow(x) * ncol(x) == 4) { # Print odds ratio only for the 2×2 table
        
        oddsrt <- (x[1,1]/x[1,2]) / (x[2,1]/x[2,2])
        oddsrt.log <- log((x[1,1]/x[1,2]) / (x[2,1]/x[2,2]))
        oddsrt.log.var <- 1/x[1,1] + 1/x[1,2] + 1/x[2,1] + 1/x[2,2]
        ci.lwrupr <- exp(oddsrt.log + qnorm(c(0.025,0.975)) * sqrt(oddsrt.log.var))
        cat("\n", "Odds Ratio [95%CI] =", oddsrt, "[", ci.lwrupr[1], ",",ci.lwrupr[2],"]", "\n")
        
      } else {
        NULL
      }
      
      
      
      cat("\n", "\n", "------------------------------------------------------", "\n", "Residual analysis:", "\n")
      res <- chisq.test(x)  # 検定結果を代入
      
      cat("\n", "[Expected values]", "\n")
      print(res$expected) # 期待値
      
      cat("\n", "[Standardized residuals]", "\n")
      print(res$residuals) # 標準化残差
      
      cat("\n", "[Adjusted standardized residuals]", "\n")
      print(res$residuals/sqrt(outer(1-rowSums(x)/sum(x), 1-colSums(x)/sum(x)))) # 調整済み標準化残差
      
      cat("\n", "[p-values of adjusted standardized residuals (two-tailed)]", "\n")
      print(round(2*(1-pnorm(abs(res$residuals/sqrt(outer(1-rowSums(x)/sum(x), 1-colSums(x)/sum(x)))))),3)) # 残差の調整後有意確率（両側確率）
      
      
      
      # 多重比較
      if (nrow(x) < 3) { # Not showing if the number of row is 2
        
        cat("\n")
        
      } else {
        
        cat("\n", "\n", "------------------------------------------------------", "\n", "Multiple comparisons (p-value adjusted with Bonferroni method):", "\n", "\n")
        
        levI <- nrow(x)
        levJ <- ncol(x)
        N <- sum(x)
        dosu <- as.vector(t(x))
        M <- min(c(levI, levJ))
        
        V.95CI <- function(x) {
          V <- sqrt(chisq.test(x, correct=F)$statistic[[1]]/(sum(x)*(min(nrow(x),ncol(x)-1))))
          fisherZ <- 0.5 * log((1 + V)/(1 - V))
          fisherZ.se <- 1/sqrt(sum(x) - 3) * qnorm(1 - ((1 - 0.95)/2))
          fisherZ.ci <- fisherZ + c(-fisherZ.se, fisherZ.se)
          ci.V <- (exp(2 * fisherZ.ci) - 1)/(1 + exp(2 * fisherZ.ci))
          return(ci.V)
        }
        
        # エラーメッセージが出る場合の例外処理
        e <- try(fisher.test(x, workspace=3000000), silent = FALSE)   # try でfisher.test関数を実行
        if (class(e) == "try-error") { # if error, without fisher.p
          
          a <- c()
          stat <- c()
          jiyu <- c()
          pchi <- c()
          v <- c()
          v.lower <- c()
          v.upper <- c()
          for(i in 1:(levI-1))
          {
            for(k in (i+1):levI)
            {
              ds <- c()
              for(j in 1:levJ)
              {
                ds <- c(ds, dosu[(i-1)*levJ+j])
              }
              for(j in 1:levJ)
              {
                ds <- c(ds, dosu[(k-1)*levJ+j])
              }
              
              kaik <- c()
              kaik <- chisq.test(matrix(ds, nr=2, by=1), correct=F)
              stat <- c(stat,kaik$stat)
              jiyu <- c(jiyu,kaik$para)
              pchi <- c(pchi,kaik$p.va)
              v <- c(v, sqrt(kaik$stat/(N*(M-1))))
              ci.values <- V.95CI(matrix(ds, nr=2, by=1))
              lower <- ci.values[1]
              upper <- ci.values[2]
              v.lower <- c(v.lower, lower)
              v.upper <- c(v.upper, upper)
            } }
          padj <- c()
          padj <- p.adjust(pchi, "bonferroni")
          
          kochi<-c(); aite<-c()
          for(i in 1:(levI-1))
          {
            for(j in (i+1):levI)
            {
              kochi <- c(kochi, rownames(x)[i])
              aite  <- c(aite,  rownames(x)[j])
            }
          }
          
          a <- data.frame(Comparisons=paste(kochi, aite, sep=" vs "), "X^2"=round(stat, 4),
                          df=round(jiyu, 4),
                          p=round(padj, 4),
                          Cramers.V=round(v, 4),
                          lwr.V=round(v.lower, 4),
                          upr.V=round(v.upper, 4))
          rownames(a) <- cat("\n")
          
          print(a)
          
        } else { # with fisher.p
          
          
          a <- c()
          stat <- c()
          jiyu <- c()
          pchi <- c()
          fishp <- c()
          v <- c()
          v.lower <- c()
          v.upper <- c()
          for(i in 1:(levI-1))
          {
            for(k in (i+1):levI)
            {
              ds <- c()
              for(j in 1:levJ)
              {
                ds <- c(ds, dosu[(i-1)*levJ+j])
              }
              for(j in 1:levJ)
              {
                ds <- c(ds, dosu[(k-1)*levJ+j])
              }
              
              kaik <- c()
              kaik <- chisq.test(matrix(ds, nr=2, by=1), correct=F)
              stat <- c(stat,kaik$stat)
              jiyu <- c(jiyu,kaik$para)
              pchi <- c(pchi,kaik$p.va)
              fishp <- c(fishp,fisher.test(matrix(ds, nr=2, by=1))$p.va)
              v <- c(v, sqrt(kaik$stat/(N*(M-1))))
              ci.values <- V.95CI(matrix(ds, nr=2, by=1))
              lower <- ci.values[1]
              upper <- ci.values[2]
              v.lower <- c(v.lower, lower)
              v.upper <- c(v.upper, upper)
            } }
          padj <- c()
          padj <- p.adjust(pchi, "bonferroni")
          fishpadj <- p.adjust(fishp, "bonferroni")
          
          kochi<-c(); aite<-c()
          for(i in 1:(levI-1))
          {
            for(j in (i+1):levI)
            {
              kochi <- c(kochi, rownames(x)[i])
              aite  <- c(aite,  rownames(x)[j])
            }
          }
          
          a <- data.frame(Comparisons=paste(kochi, aite, sep=" vs "), "X^2"=round(stat, 4),
                          df=round(jiyu, 4),
                          p=round(padj, 4),
                          Fisher.p=round(fishpadj, 4),
                          Cramers.V=round(v, 4),
                          lwr.V=round(v.lower, 4),
                          upr.V=round(v.upper, 4))
          rownames(a) <- cat("\n")
          
          print(a)
        }
      }
    })
    
    output$test4.out <- renderPrint({
      test4()
    })
    
    
    
    
    
    makepPlot4 <- function(){
      
      dat <- read.csv(text=input$text4, sep="", na.strings=c("","NA","."))
      
      x <- as.matrix(dat)
      
      levI <- nrow(x) # 行の水準数
      levJ <- ncol(x) # 列の水準数
      dosu <- as.vector(t(x))
      
      # 標本比率の計算
      gokei <- c()
      bunbo <- c()
      for(i in 1:levI) # 各群の度数を集計
      {
        ds <- c()
        for(j in 1:levJ)
        {
          ds <- c(ds, dosu[(i-1)*levJ+j])
        }
        gokei <- c(gokei, sum(ds))
        bunbo <- c(bunbo, rep(sum(ds), levJ))
      }
      hyohir <- dosu/bunbo # 群別の各値の比率
      
      zuhir <- c()
      for(i in levI:1) # 群ｉ→群１と逆順に並べ替える
      {
        for(j in 1:levJ)
        {
          zuhir <- c(zuhir, hyohir[(i-1)*levJ+j] )
        }
      }
      
      zubar <- matrix(c(zuhir), nc=levJ, by=1)
      rownames(zubar) <- rev(rownames(x))
      colnames(zubar) <- colnames(x)
      #zubar <- zubar[nrow(zubar):1,]
      
      # プロット
      par(mar=c(5,6,2,4))
      barplot(t(zubar), hor=1, las=1, xlab="Percentage", col=gray.colors(ncol(x)))
      legend("bottomright", legend=colnames(zubar), fill=gray.colors(ncol(x)))
      
    }
    
    output$pPlot4 <- renderPlot({
      print(makepPlot4())
    })
    
    
    
    
    
    makemPlot4 <- function(){
      
      dat <- read.csv(text=input$text4, sep="", na.strings=c("","NA","."))
      
      x <- as.matrix(dat)
      print(x)
      mosaic(x, gp = shading_max, main="Mosaic plot")
      
    }
    
    output$mPlot4 <- renderPlot({
      print(makemPlot4())
    })
    
    
    
    
    
    
    info4 <- reactive({
      info0 <-paste("Because the P-value is clearly less than α = 0.05, we reject H0 and conclude that \nhigh blood pressure and Chronic Kidney disease are associated in the population", ".", sep = "")
      #info1 <- paste("This analysis was conducted with ", strsplit(R.version$version.string, " \\(")[[1]][1], ".", sep = "")
      info2 <- paste("It was executed on ", date(), ".", sep = "")
      info3 <- paste("Any Question: Nemati@uwm.edu ", sep = "")
      cat(sprintf(info0), "\n")
     # cat(sprintf(info1), "\n")
      cat(sprintf(info2), "\n")
      cat(sprintf(info3), "\n")
    })
    
    output$info4.out <- renderPrint({
      info4()
    })
    

})
