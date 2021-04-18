library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")

build_corpus_1file <- function(filename)
{
  text <- readLines(filename)
  docs <- Corpus(VectorSource(text))
}

build_corpus_morefiles <- function(dirname)
{
  file.names <- dir(dirname, pattern ="\\.txt")
  cat(file.names)
  data <- vector()
  for (f in file.names) {
    tempData <- scan(f, what="character", sep="\n")
    tempDataString <- paste(tempData, collapse = " ")
    data <- c(data,tempDataString)
  } 
  docs <- Corpus(VectorSource(data))
}

build_dtm <- function(docs)
{
  toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
  docs <- tm_map(docs, toSpace, "/")
  docs <- tm_map(docs, toSpace, "@")
  docs <- tm_map(docs, toSpace, "\\|")
  docs <- tm_map(docs, content_transformer(tolower))
  # Remove numbers
  docs <- tm_map(docs, removeNumbers)
  # Remove english common stopwords
  docs <- tm_map(docs, removeWords, stopwords("english"))
  # Remove your own stop word
  # specify your stopwords as a character vector
  docs <- tm_map(docs, removeWords, c("blabla1", "blabla2"))
  # Remove punctuations
  docs <- tm_map(docs, removePunctuation)
  # Eliminate extra white spaces
  docs <- tm_map(docs, stripWhitespace)
  # Text stemming
  docs <- tm_map(docs, stemDocument)
  dtm <- TermDocumentMatrix(docs)
  m <- as.matrix(dtm)
}

#function to build a word cloud. 
build_wc <- function(dtm_wordfreq)
{
  head(dtm_wordfreq, 10)
  set.seed(1234)
  wordcloud(words = dtm_wordfreq$word, freq = dtm_wordfreq$freq, min.freq = 1,
            max.words=100, random.order=FALSE, rot.per=0.35,
            colors=brewer.pal(8, "Dark2"))
}

dtm_Ibsen <- build_dtm(build_dtm_1file("DollsHouse-Eng.txt"))  
v_ibsen <- sort(rowSums(dtm_Ibsen),decreasing=TRUE)
d_ibsen <- data.frame(word = names(v_ibsen),freq=v_ibsen)

dtm_Strindberg <- build_dtm(build_dtm_1file("Strindberg.txt"))  
v_strindberg <- sort(rowSums(dtm_Strindberg),decreasing=TRUE)
d_strindberg <- data.frame(word = names(v_stringberg),freq=v_stringberg)

dtm_Ibsen_Strindberg <- build_dtm(build_corpus_morefiles("/Users/sowmya/Dropbox/ClassroomSlides-BothCourses/LING410X/Assignments/A6-Corpus"))
colnames(dtm_Ibsen_Strindberg) <- c("Ibsen","Strindberg")

par(mfcol= c(2,2))
build_wc(d_ibsen)
build_wc(d_strindberg)
comparison.cloud(dtm_Ibsen_Strindberg, random.order=FALSE, colors = c("#00B2FF", "red", "#FF0099", "#6600CC"), title.size=1.5, max.words=50)
commonality.cloud(dtm_Ibsen_Strindberg, random.order=FALSE, colors = brewer.pal(8, "Dark2"), title.size=1.5,max.words=50)
