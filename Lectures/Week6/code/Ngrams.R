library(ngram)

#The usual stuff
dollshouse_text <- scan("DollsHouse-Eng.txt", what = "character", sep = "\n")
dollshouse_string <- paste(dollshouse_text, collapse = " ")
dollshouse_string <- tolower(dollshouse_string)
dollshouse_string <- gsub("[[:punct:]]", " ", dollshouse_string)
dollshouse_string <- gsub(" +", " ", dollshouse_string)

#ngram() function expects a "string" not a vector of words.
unigrams <- ngram(dollshouse_string,n=1)
bigrams <- ngram(dollshouse_string,n=2)
trigrams <- ngram(dollshouse_string,n=3)

#Just get the vector of all ngrams without all additional information
bigrams_vector <- get.ngrams(bigrams)
trigrams_vector <- get.ngrams(trigrams)

#top 10 most frequent unigrams
top10unigrams <- head(get.phrasetable(unigrams),n = 10)

#top 10 most frequent bigrams
top10bigrams <- head(get.phrasetable(bigrams),n = 10)

#top 10 most frequent trigrams
top10trigrams <- head(get.phrasetable(trigrams),n = 10)

top10unigrams
top10bigrams
top10trigrams

#for more details about various functions in this library:
#https://cran.r-project.org/web/packages/ngram/vignettes/ngram-guide.pdf
