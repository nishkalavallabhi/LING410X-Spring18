library(RTextTools)
library(tm)
data_train <- read.csv("sentiment_sentences_trainingdata.csv",header = TRUE)
data_test <- read.csv("sentiment_sentences_testdata.csv", header =TRUE)

dtMatrix <- create_matrix(data_train$text)
container <- create_container(dtMatrix, data_train$class,trainSize=1:nrow(data_train),virgin=FALSE)
model <- train_model(container, "SVM", kernel="linear", cost=1)
predictionData <-data_test$text
predSize <- length(predictionData)
predMatrix <- create_matrix(predictionData, originalMatrix=dtMatrix)

predictionContainer <- create_container(predMatrix,data_test$class, testSize=1:predSize, virgin=FALSE)
results <- classify_model(predictionContainer, model)