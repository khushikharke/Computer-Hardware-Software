# Load necessary libraries
library(randomForest)
library(caret)
library(ggplot2)

# Load your dataset
# Replace 'your_dataset.csv' with the actual file name and path
data <- read.csv("C:/Users/yashc/OneDrive/Desktop/arduino project/city_day.csv")

# Check the structure of the dataset
str(data)

# Explore summary statistics of the dataset
summary(data)

# Data preprocessing: Handle missing values, if any
data <- na.omit(data)

# Data visualization: Pair plot for exploratory analysis
pairs(data[, c("PM2.5", "PM10", "NO", "NO2", "NOx", "NH3", "SO2", "O3", "Benzene", "Toluene", "Xylene")])

# Feature selection: Using correlation matrix to identify highly correlated features
cor_matrix <- cor(data[, c("PM2.5", "PM10", "NO", "NO2", "NOx", "NH3", "SO2", "O3", "Benzene", "Toluene", "Xylene")])
highly_correlated_features <- findCorrelation(cor_matrix, cutoff = 0.8)

# Remove highly correlated features
selected_features <- colnames(data[, c("PM2.5", "PM10", "NO", "NO2", "NOx", "NH3", "SO2", "O3", "Benzene", "Toluene", "Xylene")][-highly_correlated_features])
data_selected <- data[, c(selected_features, "AQI")]

# Split the dataset into training and testing sets
set.seed(123)  # for reproducibility
splitIndex <- createDataPartition(data_selected$AQI, p = 0.7, list = FALSE)
train_data <- data_selected[splitIndex, ]
test_data <- data_selected[-splitIndex, ]

# Train Random Forest model
rf_model <- randomForest(AQI ~ ., data = train_data, ntree = 100)

# Make predictions on the test set
predictions <- predict(rf_model, newdata = test_data)

# Evaluate the model
confusionMatrix(predictions, test_data$AQI)

# Feature importance plot
varImpPlot(rf_model)

# Visualize actual vs. predicted values
ggplot(data = data.frame(Actual = test_data$AQI, Predicted = predictions)) +
  geom_point(aes(x = Actual, y = Predicted)) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "red") +
  labs(title = "Actual vs. Predicted AQI Values", x = "Actual AQI", y = "Predicted AQI")



