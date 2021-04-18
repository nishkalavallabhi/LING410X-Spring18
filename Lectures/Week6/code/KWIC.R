#This is a function to do some file preprocessing and convert it into a words vector.
processfile <- function(file_name)
{
  text <- scan(file_name, what = "character", sep = "\n") 
  text_as_string <- tolower(paste(text, collapse = " "))
  text_as_string <- gsub("([[:punct:]])", "\\ ", text_as_string)
  text_as_string <-  gsub(" +", " ", text_as_string)
  return(unlist(strsplit(text_as_string, " ")))
}

#A function to get the context in which a given word appears in a word vector
#Takes three arguments: a vector of words, a word to search for, a context window
#This version does not handle cases where the word we search for is the starting word or ending word of the doc.
getKwic0 <- function(wordsvector, word, context)
{
  word_index <- which(wordsvector == word)
  for(i in 1:length(word_index)) 
  {
    start <- word_index[i] - context
    end <- word_index[i] + context
    # cat(start, end) #This prints only positions, not actual words.
    cat(paste(wordsvector[start:end], sep=" ")) 
    cat("\n")
  }
}

#A function to get the context in which a given word appears in a word vector
#Takes three arguments: a vector of words, a word to search for, a context window
getKwic1 <- function(wordsvector, word, context)
{
  word_index <- which(wordsvector == word)
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
   # cat(start, end) #This prints only positions, not actual words.
    cat(paste(wordsvector[start:end]))#, sep=" ")) 
    cat("\n")
  }
}



file <- readline("Enter the name of the file you want to search in: ")
word <- readline("Enter the word for which you want the context: ")
context <- strtoi(readline("Enter the number of words before and after you want to print: "))

#If you want to do for whole folder, comment out the file line above and use a loop
#file.names <- dir(getwd(), pattern = "\\.txt")
#for (f in file.names) {
#  x <- processfile(f)
#  getKwic1 (x, word, context)
#}
# What is strtoi() function?? Why am I doing this??

#Write a for loop here so that you repeat these two steps for all files in that folder user enters.
words <- processfile(file)
getKwic1(words,word,context)

