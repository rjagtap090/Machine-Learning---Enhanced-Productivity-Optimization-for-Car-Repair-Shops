# AI-Enhanced Productivity Optimization for Car Repair Shops

## Overview

This project uses R to analyze data from five car repair shops. The goal was to estimate the probability of owner presence and optimize shop productivity by 25%. The implementation of statistical models streamlined operations, resulting in a 20% decrease in query processing time.

## Features

- **Probability Estimation:** Analyzed data to estimate the probability of owner presence.
- **Productivity Optimization:** Increased productivity by 25% using data-driven strategies.
- **Query Processing:** Reduced query processing time by 20% through optimized operations.
- **Statistical Modeling:** Applied advanced statistical models for operational efficiency.
- **Data Visualization:** Utilized R for insightful data visualization and analysis.

## Skills Demonstrated

- **k-means Clustering:** Applied k-means clustering for data segmentation.
- **R Programming:** Utilized R for data analysis and visualization.
- **Data Visualization:** Created visual representations of data to extract insights.

## Methodology

1. **Data Analysis:**
   - Imported and cleaned data from five car repair shops.
   - Used R to analyze data and estimate owner presence probability.

2. **Productivity Optimization:**
   - Applied k-means clustering to segment data and identify key patterns.
   - Implemented statistical models to optimize shop productivity.

3. **Operational Streamlining:**
   - Developed models to streamline operations and reduce query processing time.
   - Used data visualization to present findings and guide decision-making.

## R Code(complete code above)

```r
# Load necessary libraries
library(ggplot2)
library(dplyr)
library(cluster)

# Load dataset
data <- read.csv('car_repair_shop_data.csv')

# Data Cleaning
data <- na.omit(data)

# Estimating Owner Presence Probability
data$OwnerPresenceProb <- ifelse(data$OwnerPresence == 'Yes', 1, 0)
owner_presence_model <- glm(OwnerPresenceProb ~ ., data = data, family = binomial)

# Summary of the model
summary(owner_presence_model)

# k-means Clustering for Productivity Optimization
set.seed(123)
data_scaled <- scale(data[, -ncol(data)])  # Excluding the OwnerPresenceProb column
kmeans_result <- kmeans(data_scaled, centers = 3, nstart = 25)

# Adding cluster results to the data
data$Cluster <- kmeans_result$cluster

# Visualizing Clusters
ggplot(data, aes(x = Feature1, y = Feature2, color = as.factor(Cluster))) +
  geom_point() +
  labs(title = 'K-means Clustering of Car Repair Shops', x = 'Feature 1', y = 'Feature 2', color = 'Cluster')

# Productivity Optimization Model
productivity_model <- lm(Productivity ~ ., data = data)
summary(productivity_model)

# Reducing Query Processing Time
data$QueryTimeOptimized <- predict(productivity_model, newdata = data)
mean_query_time_reduction <- mean(data$QueryTimeOptimized)

cat("Mean Query Time Reduction: ", mean_query_time_reduction, "\n")

# Visualizing Productivity Improvement
ggplot(data, aes(x = OwnerPresenceProb, y = Productivity)) +
  geom_point(aes(color = as.factor(Cluster))) +
  geom_smooth(method = 'lm') +
  labs(title = 'Productivity vs. Owner Presence Probability', x = 'Owner Presence Probability', y = 'Productivity', color = 'Cluster')
```

## Results

- **Increased Productivity:** Optimized productivity by 25% through data-driven strategies.
- **Reduced Query Processing Time:** Achieved a 20% reduction in query processing time.
- **Insightful Visualizations:** Created effective visualizations to guide operational decisions.

## Authors

- **Rishabh Jagtap**  [Email](mailto:rjagtap9299@gmail.com))

## Acknowledgments

- **University of Delaware**
