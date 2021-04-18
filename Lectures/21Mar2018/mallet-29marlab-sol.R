topic.labels <- mallet.topic.labels(topic.model, topic.words.m, 0.5)
plot(mallet.topic.hclust(doc.topics.m, topic.words.m, 0.3), labels=topic.labels)
