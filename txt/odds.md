#### Odds Ratio?

The odds ratio (OR) is a statistical measure of the strength of the relationship between two events, A and B.

What is an odds ratio?
An odds ratio (OR) is a measure of association between an exposure and an outcome. The OR represents the odds that an outcome will occur given a particular exposure, compared to the odds of the outcome occurring in the absence of that exposure. Odds ratios are most commonly used in case-control studies, however they can also be used in cross-sectional and cohort study designs as well (with some modifications and/or assumptions).

Odds ratios and logistic regression
When a logistic regression is calculated, the regression coefficient (b1) is the estimated increase in the log odds of the outcome per unit increase in the value of the exposure. In other words, the exponential function of the regression coefficient (eb1) is the odds ratio associated with a one-unit increase in the exposure.

- Refrence : https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2938757/


What would be the chance of developing chronic kidney disease (CKD) if people with high blood pressure had the same chances (chance) as people without high blood pressure? The odds would be one, as we would expect the same proportion of people with high blood pressure and those without high blood pressure to have CKD. The odds ratio can be calculated using logistic regression. However, let us attempt to compute it manually to gain a better understanding of what an OR signifies. To do this, the following graph shows how many patients with high blood pressure or without will get CKD.

- First's Class odds: 98/91: 1.07692308 
- Second's Class odds: 52/66: 0.787878788 
- Third's Class odds: 81/12: 6.75


We don't have to work this out in our own head, just use your statistics software as a calculator, as the next console shows:



#### Remember the interpretation and When is it used:




Odds ratios are used to compare the relative odds of the occurrence of the outcome of interest (e.g. disease or disorder), given exposure to the variable of interest (e.g. health characteristic, aspect of medical history). The odds ratio can also be used to determine whether a particular exposure is a risk factor for a particular outcome, and to compare the magnitude of various risk factors for that outcome.

-  OR=1 Exposure does not affect odds of outcome : No effect

-  OR>1 Exposure associated with higher odds of outcome : Positive effect

- 0 < OR < 1 Exposure associated with lower odds of outcome : Negative effect



