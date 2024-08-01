# Load necessary libraries
library(ggplot2)
library(dplyr)
library(cluster)
library(caret)
library(randomForest)
library(e1071)

# Load dataset
data <- read.csv('car_repair_shop_data.csv')

# Data Cleaning
data <- na.omit(data)

# Estimating Owner Presence Probability using Logistic Regression
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

# Feature Engineering for Productivity Prediction
data$Productivity <- as.numeric(data$Productivity)

# Splitting the data into training and testing sets
set.seed(123)
trainIndex <- createDataPartition(data$Productivity, p = .8, 
                                  list = FALSE, 
                                  times = 1)
dataTrain <- data[trainIndex,]
dataTest  <- data[-trainIndex,]

# Random Forest Model for Productivity Prediction
rf_model <- randomForest(Productivity ~ ., data = dataTrain, ntree = 100)
rf_predictions <- predict(rf_model, newdata = dataTest)

# Evaluating the Random Forest Model
rf_mse <- mean((rf_predictions - dataTest$Productivity)^2)
rf_r2 <- cor(rf_predictions, dataTest$Productivity)^2

cat("Random Forest Model - Mean Squared Error: ", rf_mse, "\n")
cat("Random Forest Model - R-squared: ", rf_r2, "\n")

# Support Vector Machine for Productivity Prediction
svm_model <- svm(Productivity ~ ., data = dataTrain)
svm_predictions <- predict(svm_model, newdata = dataTest)

# Evaluating the SVM Model
svm_mse <- mean((svm_predictions - dataTest$Productivity)^2)
svm_r2 <- cor(svm_predictions, dataTest$Productivity)^2

cat("SVM Model - Mean Squared Error: ", svm_mse, "\n")
cat("SVM Model - R-squared: ", svm_r2, "\n")

# Reducing Query Processing Time using the Best Model
best_predictions <- ifelse(rf_r2 > svm_r2, rf_predictions, svm_predictions)
dataTest$QueryTimeOptimized <- best_predictions
mean_query_time_reduction <- mean(dataTest$QueryTimeOptimized)

cat("Mean Query Time Reduction: ", mean_query_time_reduction, "\n")

# Visualizing Productivity Improvement
ggplot(dataTest, aes(x = OwnerPresenceProb, y = Productivity)) +
  geom_point(aes(color = as.factor(Cluster))) +
  geom_smooth(method = 'lm') +
  labs(title = 'Productivity vs. Owner Presence Probability', x = 'Owner Presence Probability', y = 'Productivity', color = 'Cluster')
