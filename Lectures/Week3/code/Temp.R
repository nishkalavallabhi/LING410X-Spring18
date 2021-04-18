file.names <- dir(getwd(),pattern = "\\.txt")
data <- vector()
for(f in file.names)
{
  tempData <- scan(f, what="character", sep="\n")
  tempDataString <- tolower(paste(tempData, collapse = " "))
  data <- c(data,tempDataString)
}