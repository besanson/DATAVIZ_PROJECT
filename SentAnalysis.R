##################################################
#This script is for the Sentiment Analysis
##################################################

##Packages###
require(plyr)
require(stringr)
require(dplyr)
require(ggplot2)
require(png)
require(grid)
require(tm)
require(wordcloud)

###Loading Tweet Data##
dataset2<-read.csv(file = "C:/Users/DON/Dropbox/DATAVIZ-PROJECT/Data/dataset2.csv",header = TRUE,sep = ",")[,-1]

###Loading Dictionary Words###
positiveWords = scan("Dictionary/positive-words.txt",what="character", comment.char=";")
NegativeWords = scan("Dictionary/negative-words.txt", what="character", comment.char=";")
NegativeWords<-c(NegativeWords,"WTF")

### Function for Sentiment Analysis

score.sentiment = function(sentences, pos.words, neg.words, .progress='none'){
  # we got a vector of sentences. plyr will handle a list
  # or a vector as an "l" for us
  # we want a simple array of scores back, so we use
  # "l" + "a" + "ply" = "laply":
  scores = laply(sentences, function(sentence, pos.words, neg.words) {
    
    # clean up sentences with R's regex-driven global substitute, gsub():
    sentence = gsub('[[:punct:]]', '', sentence)
    sentence = gsub('[[:cntrl:]]', '', sentence)
    sentence = gsub('\\d+', '', sentence)
    # and convert to lower case:
    sentence = tolower(sentence)
    
    # split into words. str_split is in the stringr package
    word.list = str_split(sentence, '\\s+')
    # sometimes a list() is one level of hierarchy too much
    words = unlist(word.list)
    
    # compare our words to the dictionaries of positive & negative terms
    pos.matches = match(words, pos.words)
    neg.matches = match(words, neg.words)
    
    # match() returns the position of the matched term or NA
    # we just want a TRUE/FALSE:
    pos.matches = !is.na(pos.matches)
    neg.matches = !is.na(neg.matches)
    
    # and conveniently enough, TRUE/FALSE will be treated as 1/0 by sum():
    score = sum(pos.matches) - sum(neg.matches)
    
    return(score)
  }, pos.words, neg.words, .progress=.progress )
  
  scores.df = data.frame(score=scores, text=sentences)
  return(scores.df)
}


#Applying the formula to 200k tweets in english

resultSent<-score.sentiment(dataset2$text, positiveWords, NegativeWords)

#Adding the date from the tweet
resultSent$Date<-as.Date(dataset2$created)

#Incluiding a qualitative variable for Positive, Negative and Neutral Tweets
resultSent<-mutate(resultSent, tweet=ifelse(resultSent$score > 0, "Positive",
                                            ifelse(resultSent$score < 0, "Negative", "Neutral")))

#Saving this File as a CSV
write.csv(resultSent, file = "ScoreSentimentAnalysis.csv")

#Grouping the tweets by days
by.tweet <- group_by(resultSent, tweet, Date)
by.tweet <- summarise(by.tweet, number=n())

#Mean
mean(resultSent$score)

#Range
range(resultSent$score)

#Percentage of negative tweets
sum(resultSent$tweet=="Negative")/length(resultSent$tweet)

#Percentage of neutral tweets
sum(resultSent$tweet=="Neutral")/length(resultSent$tweet)


#Histogram
panel <- data.frame(xmin = -Inf, xmax = 0, ymin = -Inf, ymax = Inf)
cols <- colors()[384]

Histogram<-ggplot(data=dataHistogram, aes(x=Score))+
  geom_bar(binwidth=1,colour = "darkgreen", fill = "white")+ylab("Numer of Tweets")+
  ggtitle("Distribution of Sentiment")+ scale_x_continuous(breaks=-10:5)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  theme(axis.text.x= element_text(color="blue",size=14),
        axis.text.y= element_text(color="blue",size=14),
        plot.title = element_text(size = 20,
                                  colour = "blue"),
        axis.title.x = element_text(color="blue",size=20),
        axis.title.y = element_text(color="blue",size=20))+
  geom_rect(data = panel, aes(xmin = xmin, xmax = xmax, ymin = ymin, 
                              ymax = ymax), color = cols[1], fill = cols[1], alpha = 0.4, inherit.aes = FALSE)+
  annotate("text",x=-5,y=40000,label="Negative Sentiment",size=5,fontface="bold.italic",colour = "purple")+
  
  
  png(filename="histogram.png",width = 1000,height = 1000)
Histogram
dev.off()

#Plot 26th vs 29th and 3th: 100k vs 100k
# On the 26th the information about a suicide started to circulate

comparison<-data.frame(resultSent$score,resultSent$Date,resultSent$tweet)
colnames(comparison)<-c("score","Date","tweet")
comparisonAlpha<-comparison[(comparison$Date=="2015-03-26"),]
comparisonBeta<-comparison[(comparison$Date=="2015-03-30")| (comparison$Date=="2015-03-29"),]
comparisonBeta$Date<-"March 29-30th"
comparisonAlpha$Date<-"March 26th"

#Including an image in the back
img <- readPNG("march26.png")
g <- rasterGrob(img, interpolate=TRUE)

plot26<-ggplot(comparisonAlpha, aes(x=score, fill=tweet)) +
  geom_histogram(binwidth=1, alpha=.5, position="identity")+
  ylab("Numer of Tweets")+
  ggtitle("Distribution Sentiment: March 26th, Deliberate Crash Information release")+ scale_x_continuous(breaks=-10:5)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  theme(axis.text.x= element_text(color="blue",size=14),
        axis.text.y= element_text(color="blue",size=14),
        plot.title = element_text(size = 20,
                                  colour = "blue"),
        axis.title.x = element_text(color="blue",size=20),
        axis.title.y = element_text(color="blue",size=20),
        legend.position ="top")+
  annotation_custom(g, xmin=-9, xmax=-4, ymin=-Inf, ymax=Inf)

png(filename="plot26.png",width = 1000,height = 1000)
plot26
dev.off()

plot2930<-ggplot(comparisonBeta, aes(x=score, fill=tweet)) +
  geom_histogram(binwidth=1, alpha=.5, position="identity")+
  ylab("Numer of Tweets")+
  ggtitle("Distribution Sentiment: March 29 and 30th, Control Set")+ scale_x_continuous(breaks=-10:5)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  theme(axis.text.x= element_text(color="blue",size=14),
        axis.text.y= element_text(color="blue",size=14),
        plot.title = element_text(size = 20,
                                  colour = "blue"),
        axis.title.x = element_text(color="blue",size=20),
        axis.title.y = element_text(color="blue",size=20),
        legend.position ="top")+
  annotate("text", x = -6, y = 45000, color="purple",size=6,
           label = "The distribution are the same, regardless of the breaking news.")

png(filename="plot2930.png",width = 1000,height = 1000)
plot2930
dev.off()

####Word Cloud for Sentiment

tweets.text <- resultSent$text

#convert all text to lower case
tweets.text <- tolower(tweets.text)

# Replace blank space (“rt”)
tweets.text <- gsub("rt", "", tweets.text)

# Replace @UserName
tweets.text <- gsub("@\\w+", "", tweets.text)

# Remove punctuation
tweets.text <- gsub("[[:punct:]]", "", tweets.text)

# Remove links
tweets.text <- gsub("http\\w+", "", tweets.text)

# Remove tabs
tweets.text <- gsub("[ |\t]{2,}", "", tweets.text)

# Remove blank spaces at the beginning
tweets.text <- gsub("^ ", "", tweets.text)

# Remove blank spaces at the end
tweets.text <- gsub(" $", "", tweets.text)

#create corpus
tweets.text.corpus <- Corpus(VectorSource(tweets.text))

#clean up by removing stop words
tweets.text.corpus <- tm_map(tweets.text.corpus, function(x)removeWords(x,stopwords()))

#generate wordcloud
wordCloud<-wordcloud(tweets.text.corpus,min.freq = 2,
          scale=c(10,1),colors=brewer.pal(8, "Dark2"), 
          random.color= TRUE, random.order = FALSE, max.words = 50)

png(filename="wordCloud.png",width = 1000,height = 1000)
wordCloud
dev.off()

####Word Cloud for Data Analysis

dataset1<-read.csv(file = "C:/Users/DON/Dropbox/DATAVIZ-PROJECT/Data/dataset1.csv",header = TRUE,sep = ",")[,-1]
dataset1$created<-as.Date(dataset1$created)
FirstDay<-dataset1[(dataset1$created=="2015-03-24"),]

tweets.text2 <- FirstDay$text

#convert all text to lower case
tweets.text2 <- tolower(tweets.text2)

# Replace blank space (“rt”)
tweets.text2 <- gsub("rt", "", tweets.text2)

# Replace @UserName
tweets.text2 <- gsub("@\\w+", "", tweets.text2)

# Remove punctuation
tweets.text2 <- gsub("[[:punct:]]", "", tweets.text2)

# Remove links
tweets.text2 <- gsub("http\\w+", "", tweets.text2)

# Remove tabs
tweets.text2 <- gsub("[ |\t]{2,}", "", tweets.text2)

# Remove blank spaces at the beginning
tweets.text2 <- gsub("^ ", "", tweets.text2)

# Remove blank spaces at the end
tweets.text2 <- gsub(" $", "", tweets.text2)

#create corpus
tweets.text.corpus2 <- Corpus(VectorSource(tweets.text2))

#clean up by removing stop words
tweets.text.corpus2 <- tm_map(tweets.text.corpus2, removeWords, c(stopwords("spanish"),stopwords("en")))

#generate wordcloud
wordCloud2<-wordcloud(tweets.text.corpus2,min.freq = 2,
                     scale=c(10,1),colors=brewer.pal(8, "Dark2"), 
                     random.color= TRUE, random.order = FALSE, max.words = 50)

png(filename="wordCloud2.png",width = 1000,height = 1000)
wordCloud2
dev.off()
