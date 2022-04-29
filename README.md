# High Blood Pressure can affect CKD?

## Email : Nemati@UWM.EDU 

This is the repository for a R shiny app that introduces the basics of the main interpretation steps of a logistic regression analysis. You can inspect the app on my [personal Project](https://alinemati.shinyapps.io/CKD-App-main/) or run the app via:


 
 The app uses the classic example: Who survived the titanic? The app shows the main differences between linear and non-linear regression analysis and user explore how passenger's sex, class, and age effects who survived the Titanic.
 <center>
<img src="man/images/kidney-problems-cause-high-blood-pressure.jpg" alt="Logistic regression app" width="75%"/>
</center>
 
 
 you can see some part of application here:
 
 
 ## Class of the Chronic Kidney Disease :
  <center>
<img src="man/images/Demo1.png" alt="Logistic regression app" width="75%"/>
</center>

## GGPAIRS Plot : 
<center>
<img src="man/images/demo2.png" alt="Logistic regression app" width="75%"/>
</center>

## Confustion Matric 
<center>
<img src="man/images/Demo3.png" alt="Logistic regression app" width="35%"/>
</center>


## Logestic Regression result

Logistic regression, but why?
There are various reasons for the invention of logistic regressions to predict binary outcomes. The most obvious cause is depicted in the figure below. Consider inserting a regression line to represent a binary outcome. Consider the appearance of a scatter plot in such a situation.


In linear regression, we attempt to fit a line that minimizes the error, but the observed error is not homoscedastic in the case of a binary outcome. Additionally, the variance of the error term is dependent on the value of X, yet we observe just zero or one.


Between zero and one, there are no data, despite the fact that we employ a regression line to represent the relationship between the two result values. The following result illustrates the distribution of a logistic and a probit function.


Both distributions are frequently employed in the social sciences to model binary outcomes. Of course, we may alter the first scatter plot and use a logit function rather than a regression line to illustrate the relationship between X and Y.


The scatter plot was generated using simulated data, which is why it appears beautiful and smooth, but I hope you get a sense of the difference between linear and logistic regression.
<center>
<img src="man/images/Demo4.png" alt="Logistic regression app" width="75%"/>
</center>


## Confusion matrix

A confusion matrix is a table that is used to define the performance of a classification algorithm. A confusion matrix visualizes and summarizes the performance of a classification algorithm.

<center>
<img src="man/images/conf.png" alt="Condition Matrix" width="75%"/>
</center>

