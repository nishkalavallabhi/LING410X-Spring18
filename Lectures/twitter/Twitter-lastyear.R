#Source: https://github.com/pablobarbera/social-media-workshop/blob/master/01-twitter-data-collection.r

library(ROAuth)
library(twitteR)

requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"

my_key <- "jGXXJFeTs1FSksrd3VSwBxR6D"
my_secret <- "B0tAN6pCcF8YkSLXi3nNZAJYlKKoK9bKQZBbBvJKtE7RyV4B1a"

my_oauth <- OAuthFactory$new(consumerKey=my_key, consumerSecret=my_secret, requestURL=requestURL, accessURL=accessURL, authURL=authURL)
#my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))
#This will show a message and direct us to our twitter account and gives  us a PIN once we authorize
#Type the PIN: 

save(my_oauth, file="oauth_token.Rdata")
#This will store this information on this computer so that you don't have to repeat this process later.

accessToken = '634512278-zXpfdtx7isxdAoK8YHnc78QfswLbMssnUgvLEfga'
accessSecret = 'OuW5FdB0UOUTJoixRbIwJaQwdFtZ0zZCClM15tj8Oyy0g'

setup_twitter_oauth(consumer_key=my_key, consumer_secret=my_secret, access_token=accessToken, access_secret=accessSecret)

#search by a keyword for most recent tweets.
tweets <- searchTwitter("Iowa", n=100)
## from a Windows machine:
# searchTwitter("Iowa", cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))
#windows users need to add this cainfo= string for all these functions, apparently.

tweets_frame <- twListToDF(tweets)
#converts tweets to a table like structure which is easy to work with.

names(tweets_frame)
#Gives you the titles of the columns.

tweets_frame$text 
#gives you all the text of tweets.

tweets_frame$created
#gives information about date created for each tweet
#Gives you the names of the 

#searching by HashTag
tweets_hash <- searchTwitter("#ISU")

#getting a user profile information:
user <- getUser('nytimes')

#people who follow the user
user$getFollowers(n=10)

# friends (who the user follows)
user$getFriends(n=10)



