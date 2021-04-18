library(XML) #This is used here because the author uses xml files
library(e1071) #This is the library that has the text classification algorithm

setwd("~/Dropbox/ClassroomSlides-BothCourses/LING410X/Resources/TextAnalysisWithR-Textbook/Suppl.Materials/")
input.dir <- "data/XMLAuthorCorpus"
files.v <- dir(input.dir, ".*xml")

#Small function that removes blank strings in a vector.
removeBlanks <- function(x){
  x[which(x!="")]
}

#This function splits each file into 10 parts.
getTEIWordSegmentTableList <- function(doc.object, chunk.size=10){
  paras <- getNodeSet(doc.object, "/d:TEI/d:text/d:body//d:p", c(d = "http://www.tei-c.org/ns/1.0"))
  words <- paste(sapply(paras,xmlValue), collapse=" ") #What does this sapply do? 
  words.lower <- tolower(words)
  words.list <- strsplit(words.lower, "\\W")
  word.v <- unlist(words.list)
  max.length <- length(word.v)/chunk.size
  x <- seq_along(word.v) #What is seq_along?
  chunks.l <- split(word.v, ceiling(x/max.length)) #what is this line doing?
  chunks.l <- lapply(chunks.l, removeBlanks)
  freq.chunks.l <- lapply(chunks.l, table)
  rel.freq.chunk.l <- lapply(freq.chunks.l, prop.table) #What is prop.table??
  return(rel.freq.chunk.l)
}

#This function does the splitting into 10 parts thing for each text in the folder
#and stores entire stuff into one big list.
getData <- function(files.v) 
{
 book.freqs.l <- list()
 for(i in 1:length(files.v)){
  doc.object <- xmlTreeParse(file.path(input.dir, files.v[i]), useInternalNodes=TRUE)
  chunk.data.l <- getTEIWordSegmentTableList(doc.object, 10)
  book.freqs.l[[files.v[i]]] <- chunk.data.l
 }
 return(book.freqs.l)
}

#Third function: This takes word vector we generated for all books (chunked)
#and converts it into another list where each element is a data frame.
my.mapply <- function(x){
   my.list <- mapply(data.frame, ID=seq_along(x), x, SIMPLIFY=FALSE,MoreArgs=list(stringsAsFactors=FALSE))
   my.df  <-  do.call(rbind, my.list)
   return(my.df)
 }
 
#How should I use all these functions?

book.freqs.l <- getData(files.v)
#This should now have 43 items, where each item has 10 list items, each of these 10 show a word-rel.freq table for that chunk of text

#freqs.l will now have a big list, where each element is a data frame.
freqs.l <- lapply(book.freqs.l,my.mapply)
#freqs.l now has a list, where each item is a data frame for a given book. 
#Within the data frame is an ID field, which indicates the book's ID (so its range is 1 to 43).

#putting that large list into one big data frame
freqs.df <- do.call(rbind, freqs.l)
#use head(freqs.df) to see how this will look like!

#cleaning up - removing 1.xml, .2.xml etc in filenames and just taking the names of books (why?: for use in next step.)
bookids.v <- gsub("\\..*", "", rownames(freqs.df))

#adding a sep _ so that file names look like anonymous_1, carleton_1, carleton_2 etc
book.chunk.ids <- paste(bookids.v, freqs.df$ID, sep="_")

#my data frame's ID column now gets new values, which has these book.chunk.ids
#instead of having 1, 2 ...43, I now have carelton1_1, carleton10_10 etc. 
freqs.df$ID <- book.chunk.ids


result.t  <-  xtabs(Freq ~ ID+Var1, data=freqs.df)
#what xtabs does is to convert this long 3 column data frame into a wide table where each row is a book chunk and each column is a word feature.
#converting it into data frame below since it is easy to work with.
final.df <- as.data.frame.matrix(result.t)

metacols.m <- do.call(rbind, strsplit(rownames(final.df), "_"))
colnames(metacols.m) <- c("sampletext", "samplechunk")
author.v <- gsub("\\d+$", "", metacols.m[,"sampletext"])
authorship.df <- cbind(author.v, metacols.m, final.df)

#Reducing the feature set
freq.means.v <- colMeans(authorship.df[,4:ncol(authorship.df)])
keepers.v <- which(freq.means.v >= 0.005) #What is this??
smaller.df <- authorship.df[,names(keepers.v)]
smaller.df <- cbind(author.v, metacols.m, smaller.df)

#creating datasets
anon.v <- which(smaller.df$author.v == "anonymous")
train <- smaller.df[-anon.v, 4:ncol(smaller.df)]

#task for you: create a third dataset by taking carleton10_10 out of the training data.

#training
class.f <- smaller.df[-anon.v, "author.v"]
model.svm <- svm(train, class.f)

#testing
testdata <- smaller.df[anon.v,4:ncol(smaller.df)]
final.result <- predict(model.svm, testdata)
as.data.frame(final.result)

#task for you: repeat the training and testing part by using the trainingdata-carleton10_10 as training, and carleton10_10 as test data.
