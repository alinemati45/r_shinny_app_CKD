#### Project limitation:


**1. Missing value.**

Missing data (or missing values) is defined as the data value that is not stored for a variable in the observation of interest.

- Deal with missing values by KNN

A frequently used technique for imputation of missing data is to employ a model to forecast the missing values. This necessitates the creation of a model for each input variable with missing values. While any of a variety of alternative models may be used to forecast missing values, the k-nearest neighbor (KNN) technique has been shown to be highly effective, and is sometimes referred to as "nearest neighbor imputation."

**2. Issues with Small Data**

The difficulties associated with limited data are various, but primarily concentrate around large variance:


1- Avoiding over-fitting becomes much more difficult.

2- Not only do you over-fit to your training data, but you also occasionally over-fit to your validation data.

3- Outliers become far more dangerous.

4- Noise becomes a significant concern in general, whether it is in your goal variable or in some of the characteristics.
