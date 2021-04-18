
#Using ngram library to get most frequent n-grams in a text file
library(ngram)

#Reading in a text file, and doing general pre-processing stuff 
dollshouse_text <- scan("DollsHouse-Eng.txt", what = "character", sep = "\n")
dollshouse_string <- paste(dollshouse_text, collapse = " ")
dollshouse_string <- tolower(dollshouse_string)
dollshouse_string <- gsub("[[:punct:]]", " ", dollshouse_string)
dollshouse_string <- gsub(" +", " ", dollshouse_string)

#note: ngram() function expects a "string" not a vector of words.
unigrams <- ngram(dollshouse_string,n=1)
bigrams <- ngram(dollshouse_string,n=2)
trigrams <- ngram(dollshouse_string,n=3)

#Just get the vector of all ngrams without all additional information
unigrams_vector <- get.ngrams(unigrams)
bigrams_vector <- get.ngrams(bigrams)
trigrams_vector <- get.ngrams(trigrams)

#At each point, if you don't know what the variable contains, just see the contents of the variable
#By typing its name and pressing enter - like this:
#unigrams_vector
#bigrams_vector
#trigrams_vector

#top 10 most frequent unigrams
top10unigrams <- head(get.phrasetable(unigrams),n = 10)
#top 10 most frequent bigrams
top10bigrams <- head(get.phrasetable(bigrams),n = 10)
#top 10 most frequent trigrams
top10trigrams <- head(get.phrasetable(trigrams),n = 10)

top10unigrams
top10bigrams
top10trigrams

#typeof(top10unigrams) tells me it is a list. 
#names(top10unigrams) gives me - ngrams, freq, prop
#I want only freq. in this for plotting
#So, I can either use $freq or [[2]] to access it as it is the second item in names. 
#To know what whether each of the columns inside this list is a vector or list, use: 
#is.vector(top10bigrams$ngrams) #This shows true
#is.list(top10bigrams$ngrams) #This shows false

plot(top10unigrams$freq) #or plot(top10unigrams[[2]])
plot(top10bigrams$freq) #or plot(top10bigrams[[2]])
plot(top10trigrams$freq) #or plot(top10trigrams[[2]])

#for more details about various functions in this ngram package:
#https://cran.r-project.org/web/packages/ngram/vignettes/ngram-guide.pdf
