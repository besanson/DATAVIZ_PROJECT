##################################################
#This script is for scraping tweets
##################################################

##### Packages #####
require(twitteR)

#####Creating Dataset####

##API TWITTER### This a personal key only created for this project

consumer_key <- "4muYvjyyNunIBTDwhw47UEL6B"
consumer_secret <- "Sk8NGEWvfut6illb7MvQr827eDGzeg7eyXQj0OEm8QtTAwa79I"
access_token <- "26879352-3sAmtn4XwrNTYUXJLPt7KMVQW9QaqGunviUMYVWJi"
access_secret <- "QJCmVnSfjVFO39HfGN9mZ1fxDy0VqsdMyi5n9gC9mnE6i"
setup_twitter_oauth(consumer_key,
                    consumer_secret,
                    access_token,
                    access_secret)

##1##
#Tweets from 24th to 31th March in any languange that contained the word GermanWings.
#This is a Subset of 350.000 tweets of the total 950.000 tweets

FirstDayNoGeo <- searchTwitter("Germanwings", n = 50000, since = "2015-03-24", until ="2015-03-25")
SecondDayNoGeo <- searchTwitter("Germanwings", n = 50000, since = "2015-03-25", until ="2015-03-26")
ThirdDayNoGeo <- searchTwitter("Germanwings", n = 50000, since = "2015-03-26", until ="2015-03-27")
fourthDayNoGeo <- searchTwitter("Germanwings", n = 50000, since = "2015-03-27", until ="2015-03-28")
FifthDayNoGeo <- searchTwitter("Germanwings", n = 50000, since = "2015-03-28", until ="2015-03-29")
SixthDayNoGeo <- searchTwitter("Germanwings", n = 50000, since = "2015-03-29", until ="2015-03-30")
SeventhDayNoGeo <- searchTwitter("Germanwings", n = 50000, since = "2015-03-30", until ="2015-03-31")

###Save to a Data-Frame so it can be manipulated

tweetFrameNoGeo <- twListToDF(FirstDayNoGeo)
tweetFrameNoGeo2 <- twListToDF(SecondDayNoGeo)
tweetFrameNoGeo3 <- twListToDF(ThirdDayNoGeo)
tweetFrameNoGeo4 <- twListToDF(fourthDayNoGeo)
tweetFrameNoGeo5 <- twListToDF(FifthDayNoGeo)
tweetFrameNoGeo6 <- twListToDF(SixthDayNoGeo)
tweetFrameNoGeo7 <- twListToDF(SeventhDayNoGeo)

###Download as CSV Files

write.csv(tweetFrameNoGeo, file = "FirstDayNoGeoPos.csv")
write.csv(tweetFrameNoGeo2, file = "SecondDayNoGeoPos.csv")
write.csv(tweetFrameNoGeo3, file = "ThirdDayNoGeoPos.csv")
write.csv(tweetFrameNoGeo4, file = "FourthDayNoGeoPos.csv")
write.csv(tweetFrameNoGeo5, file = "FifthDayNoGeoPos.csv")
write.csv(tweetFrameNoGeo6, file = "SixthDayNoGeoPos.csv")
write.csv(tweetFrameNoGeo7, file = "SeventhDayNoGeoPos.csv")

##2##
#Sentiment analysis from same time period. only download tweets that are in English
#This is a subset of 200.000 tweets

FirstSent<- searchTwitter("Germanwings", n=100000, lang = "en",since = "2015-03-24",until ="2015-03-27")
SecondSent<- searchTwitter("Germanwings", n=100000, lang = "en",since = "2015-03-27",until ="2015-03-31")

###Save to a Data-Frame so it can be manipulated

tweetFrameSent <- twListToDF(FirstSent)
tweetFrameSent2 <- twListToDF(SecondSent)

###Download as CSV Files

write.csv(tweetFrameSent, file = "FirstSent.csv")
write.csv(tweetFrameSent2, file = "ScondSent.csv")