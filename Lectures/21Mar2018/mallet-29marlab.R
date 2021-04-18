#You will need mallet and wordcloud - install them first.
library(mallet)
library(wordcloud)

#Important note: I am not setting a working directory or anything today. 
#Why? What are the advantages? or disadvantages?

#Next: all you need is a corpus of text files.

#Step 1: Load the corpus into mallet
documents <- mallet.read.dir("/home/bangaru/Dropbox/ClassroomSlides-BothCourses/LING410X/21Mar2018/data/commoncoredata/data")
#You can try this with any folder of text files.  e.g., movie review dataset training folder from Week 8/9
#Note: We did the same thing by writing our own R function in Tuesday's class. 

#Step 1(b): Have a list of stop words: Change the path here to show the right stoplist file
stoplistfile = "/home/bangaru/Dropbox/ClassroomSlides-BothCourses/LING410X/21Mar2018/stoplist.csv"

#Step 1(c): use mallet.import
#should I change anything here? Why? Why not?
mallet.instances <- mallet.import(documents$id,documents$text,stoplistfile,FALSE,token.regexp="[\\p{L}']+")

#Step 2: build a topic model
#Build a topic model with 15 topics, train for 100 iterations
topic.model <- MalletLDA(num.topics=15)
topic.model$loadDocuments(mallet.instances)
topic.model$train(100) #Try training different models changing iterations, later.
#Question: Should these happen in a specific order? What happens if I shuffle around?
#Note: I am not using any optional lines here -only putting mandatory ones.

#Step 3: Inspecting the topic model.
#Inspecting topic model: What does this line below do?
topic.words.m <- mallet.topic.words(topic.model,smoothed=TRUE,normalized=TRUE)
#This results in a large unreadable thing. How will you find out what this mallet.topic.words does?

#Inspecting the topic model: What does this line below do?
doc.topics.m <- mallet.doc.topics(topic.model)
#This results in a large unreadable thing. How will you find out what this mallet.doc.topics does?

#Inspecting the topic model: what does this line below do?
word.freqs <- mallet.word.freqs(topic.model) 
#What are the three columns it shows? How do you get 10 most frequent words, sorted by 2nd column, 3rd column?

#Inspecting the topic model: what do these lines do?
topic.top.words.1 <- mallet.top.words(topic.model,topic.words.m[1,], 5)
topic.top.words.2 <- mallet.top.words(topic.model,topic.words.m[2,], 100)
topic.top.words.3 <- mallet.top.words(topic.model,topic.words.m[3,], 100)

#Inspecting topic model: vocabulary - what is the vocabulary (all keywords across all topics)  of this model?
vocabulary <- topic.model$getVocabulary()
length(vocabulary)
vocabulary[1:50]

#Step 4: Plotting word clouds for different topics - more on wordcloud function next week
wordcloud(topic.top.words.3$words,topic.top.words.3$weights,c(4,.8), rot.per=0, random.order=F)
#what happens if you try this:
wordcloud(topic.top.words.2$words,topic.top.words.2$weights,c(4,.8), rot.per=0, random.order=F)
#What should you change to see more words?

#If you plot word clouds for a couple of topics, do you see any differences between them? Can you draw some inferences as a human?

#More questions, explore mallet to find answers!!

#What does topic.labels function do in mallet?

#What does mallet.topic.hclust do?

#Show me how to plot a clustering diagram of topics using the above two questions. 

#One question: What is the difference between mallet.topic.words and mallet.subset.topic.words?

#What other functionalities exist in mallet? 