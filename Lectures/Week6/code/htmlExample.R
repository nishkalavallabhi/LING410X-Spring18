setwd("~/Dropbox/ClassroomSlides-BothCourses/LING410X/Resources/14Feb2017")

library(XML)
url <- "http://www.iowastatedaily.com/news/student_life/article_145626dc-f15e-11e6-85cd-3f88a844c6b5.html"
doc <- htmlParse(url, useInternal = TRUE)

title1 <-xpathSApply(doc, "//head/title")
title2 <-xpathSApply(doc, "//head/title/text()")

links <-xpathSApply(doc, "//a/@href")

headings1 <- xpathSApply(doc, "//strong")
headings2 <- xpathSApply(doc, "//strong/text()")

all_text_1 <- xpathSApply(doc, "//body//text()")
all_text_2 <- xpathApply(doc, "//body//text()[not(ancestor::script)][not(ancestor::style)][not(ancestor::noscript)]")


#Another way:
#Use the R file shared at: https://github.com/tonybreyal/Blog-Reference-Functions/find/master
source("htmlToText.r")
txt <- htmlToText(url)