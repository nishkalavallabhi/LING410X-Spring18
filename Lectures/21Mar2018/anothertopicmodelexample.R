library(mallet)
setwd("~/Dropbox/ClassroomSlides-BothCourses/LING410X/21Mar2018/data/reviews")

get_text_string <- function(file_path)
{
  fulltext <- scan(file_path, what = "character", sep = "\n")
  fulltext_as_string <- tolower(paste(fulltext, collapse = " "))
  return (fulltext_as_string)
}

files.v <- dir(path=getwd(), pattern=".*txt")
documents = c()
for(i in 1:length(files.v)){
  documents = c(documents, get_text_string(files.v[i]))
}

docids = seq(1:length(documents))

fortopicmodels <- cbind(docids,documents)
finaldocuments <- as.data.frame(fortopicmodels, stringsAsFactors=F)

stoplistfile = "/Users/sowmya/Dropbox/ClassroomSlides-BothCourses/LING410X/21Mar2018/stoplist.csv"
mallet.instances <- mallet.import(finaldocuments$docids,finaldocuments$documents,stoplistfile,FALSE,token.regexp="[\\p{L}']+")

#Rest of this is same as previous week's code/textbook code.

#Building a topic model
topic.model <- MalletLDA(num.topics=5)
topic.model$loadDocuments(mallet.instances)
vocabulary <- topic.model$getVocabulary()
length(vocabulary)
head(vocabulary)
vocabulary[1:50]
word.freqs <- mallet.word.freqs(topic.model)
topic.model$setAlphaOptimization(40, 80)
topic.model$train(100)

#Inspecting a topic model
topic.words.m <- mallet.topic.words(topic.model,smoothed=TRUE,normalized=TRUE)
dim(topic.words.m)

rowSums(topic.words.m)
topic.words.m[1:3, 1:3]

vocabulary <- topic.model$getVocabulary()
colnames(topic.words.m) <- vocabulary
topic.words.m[1:3, 1:3]

keywords <- c("california", "ireland")
topic.words.m[, keywords]

imp.row <- which(rowSums(topic.words.m[, keywords]) ==max(rowSums(topic.words.m[, keywords])))

mallet.top.words(topic.model, topic.words.m[imp.row,], 10)