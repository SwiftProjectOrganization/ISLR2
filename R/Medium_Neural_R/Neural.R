library(dplyr)
library(readr)
library(ggplot2)

# Load dataset
churn_data <- read_csv('~/Projects/R/ISLR2/data/Telco-Customer-Churn.csv')

# Take a quick look at the data
print(as_tibble(churn_data))
print("\n")

# Summarize churn count
cd = churn_data %>%
  group_by(Churn) %>%
  summarize(count = n())

print(cd)

# Visualize tenure vs churn
fig1 = ggplot(churn_data, aes(x = tenure, fill = Churn)) +
  geom_histogram(position = 'dodge', bins = 30) +
  theme_minimal()

print(fig1)

# One-hot encoding categorical variables
library(recipes)
rec <- recipe(Churn ~ ., data = churn_data) %>%
  step_dummy(all_nominal(), -all_outcomes())

# Prepare and bake the recipe
churn_data_preprocessed <- prep(rec) %>%
  bake(new_data = churn_data)

# Splitting the data
set.seed(123)
train_index <- sample(1:nrow(churn_data_preprocessed), 0.8 * nrow(churn_data_preprocessed))
train_data <- churn_data_preprocessed[train_index, ]
test_data <- churn_data_preprocessed[-train_index, ]

# Further split the training data into train and validation sets
val_index <- sample(1:nrow(train_data), 0.1 * nrow(train_data))
val_data <- train_data[val_index, ]
train_data <- train_data[-val_index, ]

# Load necessary libraries
library(keras3)

# Initialize the neural network model
model <- keras_model_sequential()

# Add input layer and first hidden layer with 64 neurons and ReLU activation
model %>%
  layer_dense(units = 64, activation = 'relu', input_shape = ncol(train_data) - 1) %>%
  
  # Add dropout for regularization
  layer_dropout(rate = 0.3) %>%
  
  # Add second hidden layer with 32 neurons and ReLU activation
  layer_dense(units = 32, activation = 'relu') %>%
  
  # Add another dropout layer
  layer_dropout(rate = 0.3) %>%
  
  # Output layer with sigmoid activation for binary classification
  layer_dense(units = 1, activation = 'sigmoid')

# Compile the model
model %>% compile(
  optimizer = 'adam',
  loss = 'binary_crossentropy',
  metrics = c('accuracy')
)

# Print the summary of the model architecture
summary(model)

# Set early stopping callback to avoid overfitting
early_stop <- callback_early_stopping(monitor = "val_loss", patience = 10)

print("/nAbout to fit the model./n")

# Train the model
history <- model %>% fit(
  x = as.matrix(train_data[,-ncol(train_data)]),  # Exclude target column
  y = train_data$Churn,
  epochs = 100,  # Number of epochs
  batch_size = 32,  # Batch size
  validation_data = list(as.matrix(val_data[,-ncol(val_data)]), val_data$Churn),
  callbacks = list(early_stop)
)

# Plot training & validation accuracy over epochs
fig2 = plot(history) + 
  ggtitle('Training vs Validation Accuracy') + 
  xlab('Epoch') + 
  ylab('Accuracy') + 
  theme_minimal()
print(fig2)

# Plot training & validation loss over epochs
ggplot() +
  geom_line(aes(x = 1:length(history$metrics$loss), y = history$metrics$loss), color = 'blue') +
  geom_line(aes(x = 1:length(history$metrics$val_loss), y = history$metrics$val_loss), color = 'red') +
  labs(title = "Training vs Validation Loss", x = "Epoch", y = "Loss") +
  theme_minimal()



