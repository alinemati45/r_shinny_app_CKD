#### Logistic regression, but why?

There are various reasons for the invention of logistic regressions to predict binary outcomes. 
The most obvious cause is depicted in the figure below. Consider inserting a regression line to represent a binary outcome. 
Consider the appearance of a scatter plot in such a situation.


In linear regression, we attempt to fit a line that minimizes the error, but the observed error is not homoscedastic in the case of a binary outcome.
Additionally, the variance of the error term is dependent on the value of X, yet we observe just zero or one.

Between zero and one, there are no data, despite the fact that we employ a regression line to represent the relationship between the two result values.
The following result illustrates the distribution of a logistic and a probit function.

Both distributions are frequently employed in the social sciences to model binary outcomes.
Of course, we may alter the first scatter plot and use a logit function rather than a regression line to illustrate the relationship between X and Y.

The scatter plot was generated using simulated data, which is why it appears beautiful and smooth, but I hope you get a sense of the difference between linear and logistic regression.
