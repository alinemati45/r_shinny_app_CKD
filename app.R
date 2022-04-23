


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

library(markdown)


#https://alinemati.shinyapps.io/CKD-App-main
#Data Prep#############

train_df <- read.csv(file = './data/data.csv')


train_df$class <- factor(train_df$class, 
                            levels = c(0, 1),
                            labels = c("Notckd", "Ckd")) 



train_df$blood_pressure <- factor(train_df$blood_pressure, 
                                  levels = c(1, 2 , 3 ),
                                  labels = c("Low", "Mid" , "High")) 
train_df$Age <- as.double(train_df$Age) 
typeof(train_df$Age)




glm_fit <- glm(class ~ Pus_Cell + Age + blood_pressure , family = binomial(link = 'logit'), data = train_df)




#Titanic data prep for alluvial#######
tita<- read.csv(file = './data/data.csv')


tita<- tita %>% 
  select(Age, Pus_Cell, class, blood_pressure)%>% 
  mutate(
    Adults = case_when(
      Age >= 0 & Age < 14    ~ "Kids",
      Age >= 14 & Age < 100   ~ "Adult",
      TRUE                   ~ "NA")
  ) %>%
  mutate(Adults = na_if(Adults, "NA"))


tita<- tita %>% 
  group_by(Pus_Cell, class, blood_pressure, Adults) %>% 
  drop_na() %>% 
  count(Pus_Cell) 


tita$class <- factor(tita$class, 
                        levels = c(0, 1),
                        labels = c("Notckd", "Ckd")) 

tita$blood_pressure <- factor(tita$blood_pressure, 
                      levels = c(1, 2 , 3 ),
                      labels = c("Low", "Mid", "High" ))


#plots
all_adults <- ggplot(data = tita,
       aes(axis1 = Pus_Cell, axis2 = Adults,
           y = n)) +
  scale_x_discrete(limits = c("Pus_Cell", "Adults", "Class"), expand = c(.2, .05)) +
  xlab("Group") +
  geom_alluvium(aes(fill = class), alpha = 0.75) +
  geom_stratum() +
  geom_text(stat = "stratum", aes(label = after_stat(stratum)), size = rel(5)) +
  theme_minimal(base_size = 16)+
  scale_fill_manual(values = c("#009E73","#E69F00"))+
  theme(legend.position="bottom")

all_class <- ggplot(data = tita,
       aes(axis1 = Pus_Cell, axis2 = blood_pressure,
           y = n)) +
  scale_x_discrete(limits = c("Pus_Cell", "Adults", "Class"), expand = c(.2, .05)) +
  xlab("Group") +
  geom_alluvium(aes(fill = class),  alpha = 0.75) +
  geom_stratum() +
  geom_text(stat = "stratum", aes(label = after_stat(stratum)), size = rel(5)) +
  theme_minimal(base_size = 16)+
  scale_fill_manual(values = c("#009E73","#E69F00"))+
  theme(legend.position="bottom")

all_overall <- ggplot(data = tita,
       aes(axis1 = Pus_Cell, axis2 = Adults, axis3 = blood_pressure,
           y = n)) +
  scale_x_discrete(limits = c("Pus_Cell", "Adults", "Class"), expand = c(.2, .05)) +
  xlab("Group") +
  geom_alluvium(aes(fill = class),  alpha = 0.75) +
  geom_stratum() +
  geom_text(stat = "stratum", aes(label = after_stat(stratum)), size = rel(5)) +
  theme_minimal(base_size = 16)+
  scale_fill_manual(values = c("#009E73","#E69F00"))+
  theme(legend.position="bottom")


all_sex <- ggplot(data = tita,
       aes(axis1 = Pus_Cell,
           y = n)) +
  scale_x_discrete(limits = c("Pus_Cell", "Adults", "Class"), expand = c(.2, .05)) +
  xlab("Group") +
  geom_alluvium(aes(fill = class),  alpha = .75) +
  geom_stratum() +
  geom_text(stat = "stratum", aes(label = after_stat(stratum)), size = rel(5)) +
  theme_minimal(base_size = 16)+
  scale_fill_manual(values = c("#009E73","#E69F00"))+
  theme(legend.position="bottom")



require(stats)
centre <- function(x, type) {
  switch(type,
         mean = mean(x),
         median = median(x),
         trimmed = mean(x, trim = .1))
}
x <- rcauchy(10)
centre(x, "mean")
centre(x, "median")
centre(x, "trimmed")

#Test

model_call <- function(type) {
  switch(type,
         m1 = glm(class ~ Pus_Cell , family = binomial(link = 'logit'), data = train_df),
         m2 = glm(class ~ blood_pressure , family = binomial(link = 'logit'), data = train_df),
         m3 = glm(class ~ Age , family = binomial(link = 'logit'), data = train_df),
         m4 = glm(class ~ Pus_Cell + blood_pressure , family = binomial(link = 'logit'), data = train_df),
         m5 = glm(class ~ Pus_Cell + blood_pressure + Age, family = binomial(link = 'logit'), data = train_df),
         m6 = glm(class ~ Pus_Cell + Age , family = binomial(link = 'logit'), data = train_df),
         m7 = glm(class ~ blood_pressure + Age , family = binomial(link = 'logit'), data = train_df)
         )
}


#OR Barplots

or1 <- tidy(model_call("m1"))%>% 
  mutate(oddsRatio = exp(estimate))%>%
  select(term, estimate, oddsRatio)%>%
  mutate(term=replace(term, term=="(Intercept)", NA)) %>% 
  drop_na()%>% 
  ggplot(aes(x = term, y= oddsRatio)) + 
  geom_bar(stat="identity")+
  geom_text(aes(label=round(oddsRatio, 3)), vjust=-1, size = 6)+
  ylab("Odds Ratio")+
  xlab("Coefficient")+
  theme_bw(base_size = 16)+
  expand_limits(y=c(0,2))+
  scale_color_manual(values = c("#2C3E50"))

or2 <- tidy(model_call("m2"))%>% 
  mutate(oddsRatio = exp(estimate))%>%
  select(term, estimate, oddsRatio)%>%
  mutate(term=replace(term, term=="(Intercept)", NA)) %>% 
  drop_na()%>% 
  ggplot(aes(x = term, y= oddsRatio)) + 
  geom_bar(stat="identity")+
  geom_text(aes(label=round(oddsRatio, 3)), vjust=-1, size = 6)+
  ylab("Odds Ratio")+
  xlab("Coefficient")+
  theme_bw(base_size = 16)+
  expand_limits(y=c(0,2))+
  scale_color_manual(values = c("#2C3E50"))

or3 <- tidy(model_call("m3"))%>% 
  mutate(oddsRatio = exp(estimate))%>%
  select(term, estimate, oddsRatio)%>%
  mutate(term=replace(term, term=="(Intercept)", NA)) %>% 
  drop_na()%>% 
  ggplot(aes(x = term, y= oddsRatio)) + 
  geom_bar(stat="identity")+
  geom_text(aes(label=round(oddsRatio, 3)), vjust=-1, size = 6)+
  ylab("Odds Ratio")+
  xlab("Coefficient")+
  theme_bw(base_size = 16)+
  expand_limits(y=c(0,2))+
  scale_color_manual(values = c("#2C3E50"))

or4 <- tidy(model_call("m4"))%>% 
  mutate(oddsRatio = exp(estimate))%>%
  select(term, estimate, oddsRatio)%>%
  mutate(term=replace(term, term=="(Intercept)", NA)) %>% 
  drop_na()%>% 
  ggplot(aes(x = term, y= oddsRatio)) + 
  geom_bar(stat="identity")+
  geom_text(aes(label=round(oddsRatio, 3)), vjust=-1, size = 6)+
  ylab("Odds Ratio")+
  xlab("Coefficient")+
  theme_bw(base_size = 16)+
  expand_limits(y=c(0,2))+
  scale_color_manual(values = c("#2C3E50"))

or5 <- tidy(model_call("m5"))%>% 
  mutate(oddsRatio = exp(estimate))%>%
  select(term, estimate, oddsRatio)%>%
  mutate(term=replace(term, term=="(Intercept)", NA)) %>% 
  drop_na()%>% 
  ggplot(aes(x = term, y= oddsRatio)) + 
  geom_bar(stat="identity")+
  geom_text(aes(label=round(oddsRatio, 3)), vjust=-1, size = 6)+
  ylab("Odds Ratio")+
  xlab("Coefficient")+
  theme_bw(base_size = 16)+
  expand_limits(y=c(0,2))+
  scale_color_manual(values = c("#2C3E50"))

or6 <- tidy(model_call("m6"))%>% 
  mutate(oddsRatio = exp(estimate))%>%
  select(term, estimate, oddsRatio)%>%
  mutate(term=replace(term, term=="(Intercept)", NA)) %>% 
  drop_na()%>% 
  ggplot(aes(x = term, y= oddsRatio)) + 
  geom_bar(stat="identity")+
  geom_text(aes(label=round(oddsRatio, 3)), vjust=-1, size = 6)+
  ylab("Odds Ratio")+
  xlab("Coefficient")+
  theme_bw(base_size = 16)+
  expand_limits(y=c(0,2))+
  scale_color_manual(values = c("#2C3E50"))

or7 <- tidy(model_call("m7"))%>% 
  mutate(oddsRatio = exp(estimate))%>%
  select(term, estimate, oddsRatio)%>%
  mutate(term=replace(term, term=="(Intercept)", NA)) %>% 
  drop_na()%>% 
  ggplot(aes(x = term, y= oddsRatio)) + 
  geom_bar(stat="identity")+
  geom_text(aes(label=round(oddsRatio, 3)), vjust=-1, size = 6)+
  ylab("Odds Ratio")+
  xlab("Coefficient")+
  theme_bw(base_size = 16)+
  expand_limits(y=c(0,2))+
  scale_color_manual(values = c("#2C3E50"))


#install.packages("e1071")








#Prediction plots: Sensitivity
glm_fit <- glm(class ~ Pus_Cell + Age + as.numeric(blood_pressure) , family = binomial(link = 'logit'), data = train_df)

pred_surv <- (predict(glm_fit, train_df, type = 'response') > 0.5) * 1

#diese Prognose speichern wir zusammen mit der index

df_pred <- data.frame('index' = train_df$index, 'True' =  train_df$class, 
                      'Predicted' = pred_surv) %>% drop_na()




df_pred$Predicted <- factor(df_pred$Predicted, 
                            levels = c(0, 1),
                            labels = c("Notckd", "Ckd")) 


levels(df_pred$True)
levels(df_pred$Predicted)

cmMatrix<- confusionMatrix(df_pred$Predicted, df_pred$True,  positive = "Ckd")


label_df <- df_pred %>% 
  group_by(True, Predicted) %>% 
  count() %>% 
  arrange(True)

fcukit <- data.frame(
  x = c(0.32, 0.32, 0.82, 0.82),
  y = c(0.9, 0.1, 0.9, 0.1),
  text = label_df$n,
  text2 = c("True negative", "False positive", "False negative", "True positive")
)



sample_size = df_pred %>% group_by(True) %>% summarize(num=n())

df_pred <- df_pred %>%
  left_join(sample_size) %>%
  mutate(True = paste0(True, "\n", "n=", num))


cmMatrix$byClass[2]
cmMatrix$byClass[1]
pred_plot <- ggplot(df_pred) + 
  geom_mosaic(aes(x = product(True), fill = Predicted))+
  scale_fill_manual(values=c("#E69F00","#009E73"))+
  geom_label(data = fcukit, 
             aes(x = x, y = y, 
                 label = paste0(text2, ":", text)),
             size = 6)+
  ylab("Predicted")+
  xlab("Observed")+
  theme_minimal(base_size = 18)+
  labs(caption = paste0("Sensitivity:", round(cmMatrix$byClass[2], 2),
                        ", Specificity:", round(cmMatrix$byClass[1], 2))  )+
  theme(plot.caption = element_text(color = "black",
                                    size = 18,
                                    hjust = 0,
                                    face = "bold"))+
  theme(legend.position = "None")

pred_plot
#ROC

pred_roc <- (predict(glm_fit, train_df, type = 'response') > 0.5) * 1
df_roc <- data.frame('class' = train_df$class, 'predict' =  pred_roc)
precrec_obj <- evalmod(scores = df_roc$predict, labels = df_roc$class)

p <-  autoplot(precrec_obj, "ROC")

roc_curve <-  p+
  theme_minimal(base_size = 18)+
  geom_line(size = 1, color="#E69F00")+
  geom_vline(xintercept = 0, size=1, color="black") + 
  geom_hline(yintercept = 1, size=1, color="black") + 
  geom_abline(size = 0.8, linetype = "dashed", color="darkgray")+
  theme(legend.position = "none")+
  ggtitle("")
library(devtools)

library(GGally)
gg_p<-ggpairs(train_df,  title="correlogram with ggpairs()"  )
