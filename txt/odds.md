#### What is the Odds Ratio?

The odds ratio (OR) is a statistic that indicates the strength of the association between two occurrences, A and B.

What does the term "odds ratio" mean?
The odds ratio (OR) is a statistic that indicates the relationship between an exposure and an outcome. The OR indicates the probability of an event occurring in the presence of a certain exposure, as opposed to the probability of the result occurring in the absence of that exposure. Although odds ratios are most frequently employed in case-control studies, they may also be utilized in cross-sectional and cohort studies (with appropriate adjustments and/or assumptions).

Ratios of probabilities and logistic regression
When doing a logistic regression, the regression coefficient (b1) represents the predicted increase in the log odds of the result for each unit increase in the exposure value. In other words, the exponential function of the regression coefficient (eb1) represents the odds ratio associated with an increase in exposure of one unit.

- http://www.ncbi.nlm.nih.gov/pmc/articles/PMC2938757/


What would the probability of acquiring chronic kidney disease (CKD) be if persons with high blood pressure had the same probability (chance) as people without high blood pressure? The chances are one, as we would anticipate the same number of patients with and without hypertension to get CKD. Logistic regression may be used to compute the odds ratio. Nevertheless, let us attempt to compute it manually in order to obtain a better grasp of what an OR indicates. To illustrate this, the following graph depicts the likelihood of developing CKD in individuals with or without hypertension.

- First's Class odds: 98/91: 1.07692308 
- Second's Class odds: 52/66: 0.787878788 
- Third's Class odds: 81/12: 6.75

We do not have to calculate this in our heads; instead, we may utilize our statistics program as a calculator, as seen in the following console:



#### Bear in mind the meaning and the context in which it is used:




The odds ratio is used to compare the relative probabilities of an event occurring (e.g., sickness or condition) based on exposure to the variable of interest (e.g. health characteristic, aspect of medical history). Additionally, the odds ratio may be used to establish if a given exposure is a risk factor for a certain result and to compare the magnitudes of distinct risk factors for that event.

-  OR=1 Exposure does not affect odds of outcome : No effect

-  OR>1 Exposure associated with higher odds of outcome : Positive effect

- 0 < OR < 1 Exposure associated with lower odds of outcome : Negative effect




