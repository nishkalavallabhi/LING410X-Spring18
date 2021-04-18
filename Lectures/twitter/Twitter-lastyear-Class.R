#Source: https://github.com/pablobarbera/social-media-workshop/blob/master/01-twitter-data-collection.r

library(ROAuth)
library(twitteR)

requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"

my_api_key <- "XXXXXX" 
#Enter your API KEY

my_api_secret <- "XXXXXXX"
#Enter your API secret

my_oauth <- OAuthFactory$new(consumerKey=my_api_key, consumerSecret=my_api_secret, requestURL=requestURL, 
                             accessURL=accessURL, authURL=authURL)

#I did not have to do these following lines on my laptop. Check if you have to do these.
#my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))
#This will show a message and direct us to our twitter account and gives  us a PIN once we authorize
#Type the PIN: 

save(my_oauth, file="oauth_token.Rdata")
#This will store this information on this computer so that you don't have to repeat this process later.

accessToken = 'XXXXXXXX'
#Enter your access token

accessSecret = 'XXXXXXXX'
#enter your access token secret.

setup_twitter_oauth(consumer_key=my_api_key, consumer_secret=my_api_secret, access_token=accessToken, access_secret=accessSecret)

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

#Follow other steps in the online tutorial 
#Source: https://github.com/pablobarbera/social-media-workshop/blob/master/01-twitter-data-collection.r


