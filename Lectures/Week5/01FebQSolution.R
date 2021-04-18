#File is in my working directory
davidc <- scan("davidc.txt", what = "character", sep = "\n")
davidc.chap.positions <- grep("^CHAPTER \\d", davidc)
cat("Number of chapters in David Copperfield: ", length(davidc.chap.positions))

davidc.chap.positions <- c(davidc.chap.positions, length(davidc))
chapters.raw <- list()
for (i in 1:(length(davidc.chap.positions) -1))
{
  titleline <- davidc.chap.positions[i]
  title <- davidc[titleline]
  start <- titleline+1
  end   <- davidc.chap.positions[i+1]-1
  chapter.lines <- davidc[start:end]
  chapter.string <- tolower(paste(chapter.lines, collapse = " "))
  chapter.string <- gsub(" +", " ", gsub("[[:punct:]]", " ", chapter.string))
  chapter.words <- unlist(strsplit(chapter.string, "\\W"))
  chapter.freqs <- table(chapter.words)
  chapters.raw[[title]] <- chapter.freqs
}
#This part is more or less the same as before.

#Frequency of murdstone in all chapters.
murdstone <- lapply(chapters.raw, "[", "murdstone")
#Why not “Murdstone”??

murdstone[is.na(murdstone)] <- 0  #Replacing NAs with 0.
#Not necessary for answering this particular question, but better to do this before plotting

murdstone_counts = c()
for (i in 1:length(murdstone))
{
  murdstone_counts[i] <- murdstone[[i]]
}

#You can at this point just look at murdstone_counts and see the results, or 
which.max(murdstone_counts)
#gives you the index of chapter with maximum value.

#An even simpler way:
which.max(murdstone) 

#Why did I not use sort? Will sort(murdstone) work? 