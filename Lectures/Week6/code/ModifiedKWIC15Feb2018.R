#This is a function to do some file preprocessing and convert it into a words vector.
processfile <- function(file_name)
{
  text <- scan(file_name, what = "character", sep = "\n") 
  text_as_string <- tolower(paste(text, collapse = " "))
  text_as_string <- gsub("([[:punct:]])", "\\1 ", text_as_string)
  text_as_string <-  gsub(" +", " ", text_as_string)
  return(unlist(strsplit(text_as_string, " ")))
}


#A function to get the context in which a given word appears in a word vector
#Takes three arguments: a vector of words, a word to search for, a context window
getKwic <- function(wordsvector, word, context)
{
  word_index <- which(wordsvector == word)
  result_vector = vector()
  for(i in 1:length(word_index)) 
  {
    start <- word_index[i] - context
    if(start < 1)
    {
      start <- 1
    }
    end <- word_index[i] + context
    if(end >= length(wordsvector))
    {
      end <- length(wordsvector)
    }
    #What is the difference between sep and collapse???
    result_vector[i] <- paste(wordsvector[start:end], collapse = " ")
  }
    return(result_vector)
  }

file <- readline("Enter the name of the file you want to search in: ")
word <- readline("Enter the word for which you want the context: ")
context <- strtoi(readline("Enter the number of words before and after you want to print: "))   
# What is strtoi() function?? Why am I doing this??

words <- processfile(file)
results <- getKwic(words,word,context)
cat("Number of matches: ", length(results),"\n")
print(results)
