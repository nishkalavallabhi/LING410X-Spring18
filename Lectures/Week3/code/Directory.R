#setwd("my path to the required folder with text files")
file.names <- dir(getwd(), pattern ="\\.txt")
toremove <- c("a","an","the","in","of", "i", "to")
for (f in file.names) {
  cat("in this file:",f, "\n")
  tempData <- scan(f, what="character", sep="\n")
  tempDataString <- tolower(paste(tempData, collapse = " "))
  words <- strsplit(tempDataString, "\\W+")
  sorted_freqs <- sort(table(words), decreasing = TRUE)
  print(sorted_freqs[1:10])
}
