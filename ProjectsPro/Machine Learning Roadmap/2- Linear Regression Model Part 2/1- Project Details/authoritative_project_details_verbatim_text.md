<style>
/* Visual-only styling: no text/content changes */
.project-details {
  max-width: 900px;
  margin: 40px auto;
  padding: 32px;
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
  line-height: 1.6;
  color: #1f2937;
}

.project-details h1 {
  font-size: 2rem;
  margin-bottom: 1rem;
  border-bottom: 2px solid #e5e7eb;
  padding-bottom: 0.5rem;
}

.project-details h2 {
  font-size: 1.25rem;
  margin-top: 2rem;
  margin-bottom: 0.75rem;
  color: #111827;
}

.project-details p {
  margin: 0.5rem 0 1rem 0;
}

.project-details ul,
.project-details ol {
  margin-left: 1.5rem;
  margin-bottom: 1.5rem;
}

.project-details li {
  margin-bottom: 0.4rem;
}

.project-details section {
  margin-bottom: 2rem;
}

.project-details strong {
  font-weight: 600;
}

/* Optional subtle section separation */
.project-details section:not(:last-child) {
  padding-bottom: 1.5rem;
  border-bottom: 1px solid #f1f5f9;
}
</style>
Machine Learning Linear Regression Project for Beginners in Python to Build a Multiple Linear Regression Model on Soccer Player Dataset.

**What will you learn?**

1. What is Multiple Linear Regression?
2. General Linear Regression Model
3. Matrix Representation for General Linear Regression Model
4. Matrix Representation of Least Squares
5. Understanding types of predictive variables
6. F-test
7. Coefficient of multiple determination
8. Adjusted R-squared
9. What are scatterplots?
10. What is a correlation matrix?
11. Understanding multicollinearity.
12. Anova Partitioning
13. Diagnostic and Remedial Measures
14. What are Indicator Variables?
15. Various criteria for model selection such as R^2, mallows cp Criterion, AIC/SBC Criterion, Press Criterion
16. Building a Multiple Linear Regression model

**Project Description**

**Overview**

We have started our journey of understanding the background and basics of regression in the first project of this series. We understood the fundamentals of regression and created a simple linear regression model.

In this project, we will get familiarised with multiple linear regression. Unlike linear regression, multiple linear regression is used to estimate the relationship between two or more independent variables and one target / dependent variable.

Before starting this project, please do visit the first project of the series: Linear Regression Model Project in Python for Beginners Part 1.

**Aim**

To build a multiple linear regression model in python.

Data Description

The dataset used is the soccer player dataset. It has information about various players from different clubs, and it provides data over ten features with a number of goals as the target variable.

**Tech Stack**

Language: Python
Libraries: numpy, pandas, statsmodel, seaborn, matplotlib, sklearn, scipy

**Approach**

1. Import the required libraries and dataset
2. Check for the correlation between features
3. Plot a graph for correlations
4. Remove the weakly correlated and highly multicollinear variables
5. Perform train test split on the dataset
6. Fit the multiple linear regression model
7. Convert categorical variables into dummy/indicator variables
8. Plot the results

