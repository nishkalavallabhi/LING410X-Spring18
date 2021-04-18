library(tm)
library(e1071)
library(SnowballC) #for stemming.
setwd("~/Dropbox/ClassroomSlides-BothCourses/LING410X/Week8Mats/code")

#This function does some basic pre-processing for all files in a folder!
cleanCorpus <- function(folderpath)
{
  corpus <- VCorpus(DirSource(folderpath))
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus, removeWords, stopwords("english"))
  #corpus <- tm_map(corpus,stemDocument)
  return(corpus)
  #Note: getTransformations() gives full list of possible transformations.
  #stopwords("English") will give you all stopwords.
}

#Create training corpus
corpus_train_pos <- cleanCorpus("largerdataset/train/pos") #has 234 examples of positive reviews
corpus_train_neg <- cleanCorpus("largerdataset/train/neg") #has 234 examples of negative reviews
corpus_train <- c(corpus_train_pos,corpus_train_neg) #has 468 examples in total
training_size <- length(corpus_train_pos) + length(corpus_train_neg)

#Create testing corpus
corpus_test_pos <- cleanCorpus("largerdataset/test/pos") #82 positive docs for testing
corpus_test_neg <- cleanCorpus("largerdataset/test/neg") #67 negative docs for testing
corpus_test <- c(corpus_test_pos,corpus_test_neg) #has 149 examples in total

#Combine them, to create a document term matrix for the whole data first
fullcorpus <- c(corpus_train,corpus_test) #has 617 texts. 
#training: 234 positive, 234 negative, followed by testing:82 positive, 67 negative

#Create a document-term matrix (using various settings - any of the below 3 lines work fine.)
dtm_together <- DocumentTermMatrix(fullcorpus)

#dtm_together <- removeSparseTerms(DocumentTermMatrix(fullcorpus), sparse=0.7) #what is this? what happens if I change this??
#sparsity refers to a threshold set for the relative document frequency for a term. Terms sparser than that will be removed.
#dtm_together <- removeSparseTerms(DocumentTermMatrix(fullcorpus, control=list(weighting=weightTfIdf)),sparse=0.8) #What is this??

#Convert this to a dataframe - why? because the svm() function wants it like that. 
dtm_together_df <- as.data.frame.matrix(dtm_together)

#This gives you the final collection of words chosen for analysis.
names(dtm_together_df)

#Add a column for class labels
labels <-  c(rep("positive",length(corpus_train_pos)), 
             rep("negative",length(corpus_train_neg)),
             rep("positive",length(corpus_test_pos)),
             rep("negative",length(corpus_test_neg)))
dtm_together_df <- cbind(dtm_together_df,labels)


#Split the dtm back into train and test 

max_col <- ncol(dtm_together_df)
train <- dtm_together_df[1:training_size,1:max_col-1] #last column is the category
class_train <- dtm_together_df[1:training_size,max_col]

test <- dtm_together_df[training_size:length(fullcorpus),1:max_col-1]
class_test <- dtm_together_df[training_size:length(fullcorpus),max_col]

#e1071 library has a classification algorithm called svm
#Note: There are several other classification algorithms you can use. 
model.svm <- svm(train, class_train)
final.result <- predict(model.svm, test)
predictions <- cbind(as.data.frame(final.result), class_test)
table(final.result, class_test)


#Some useful links:
#R Tm documentation: https://cran.r-project.org/web/packages/tm/tm.pdf
#Vignettes file: ftp://cran.r-project.org/pub/R/web/packages/tm/vignettes/tm.pdf
#Tutorial: http://web.letras.up.pt/bhsmaia/EDV/apresentacoes/Bradzil_Classif_withTM.pdf
#A larger tutorial: http://onepager.togaware.com/TextMiningO.pdf
#Note on what removeSparseTerms does: refer this discussion 
#-http://stackoverflow.com/questions/28763389/how-does-the-removesparseterms-in-r-work
