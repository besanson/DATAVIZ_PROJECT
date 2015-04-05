## __Project__

### Idea
Twitter is a social network that produces content instantly, limited to 140 characters. *The idea of this project is to obtain the tweets related to this tragedy and display the reaction it generated among the Twitter users*.

### Approach: R

Use the [`twitteR`](http://cran.r-project.org/web/packages/twitteR/twitteR.pdf) package to download tweets (using the function `searchTwitter` and a [`Twitter API`](https://dev.twitter.com/)) from March 24th to 31th, the first week after the crash. The downloaded tweets come with 16 features each:  

    [1] "text"          "favorited"     "favoriteCount" "replyToSN"     "created"       "truncated"     "replyToSID"   
    [8] "id"            "replyToUID"    "statusSource"  "screenName"    "retweetCount"  "isRetweet"     "retweeted"    
    [15] "longitude"     "latitude"

+ The **First Task** was to map the different tweets, but given that not many tweets had their information about longitude and latitude, then a second approach was taken. Use the function `getUser` to obtain the location name (e.g city or Country) of each user. It must be said that not all twitter's account have that information properly, many people use the location option as another text line to put other kind of information (like sarcastic comments, for example). After that, I used the `geocode` function from the `dismo` package to interpret the text location (for example, B. Aires as Buenos Aires) and find its latitude and longitude. These last two steps were the most time consuming and tested the limits of the `Twitter API` (it had to be done using a loop that waited 10 seconds between each query). For that reason some compromises had to be made, please see the section `Twitter Limitations`.

+ The **Second Task** was to create a *sentiment analysis* on tweets that were made in English, as can be seen from the 16 features above, none is language, then a new query was made using the function `searchTweets` forcing that the returned tweets where in English. The tweets obtained were from March 26, 29 and 30th (100k from the 26th and 100k from the 29 and 30th together). The sentiment analysis divided the tweets into: *positive, negative and neutral*. I used the Hu and Liu’s [“opinion lexicon” dictionary](http://www.cs.uic.edu/~liub/FBS/sentiment-analysis.html) to obtain the positive and negatives words. It categorizes nearly 6,800 words as positive or negative. After running a public known function the output was used to create a *Word cloud* with the 50 most repeated words and three Histograms:
- The sentiment of the whole dataset.
- Compare the sentiment of the tweets from the 26th against the others days.

### Conclusion

Given the characteristics of this Tragedy, twitter users were very active regarding the aftermath of the crash. **The sentiment analysis output was what one can expect from these events: sadness represented as negative mood**. It must be considered that it was not possible to detect sarcasm in the tweets, thus many tweets that maybe catalogued as positive may actually be negative.  
On March 26th, the news became public that the plane crash was deliberately caused by the copilot Andreas Lubitz; my first hypothesis was that the negative sentiment would be greater that date than any following day. *But after comparing it with a later date (March 29 and 30th, accounting also for 100k tweets together), the distribution of sentiment is practically the same*.  
Furthermore, the word cloud for the data set mentions in its core the word *copilot*, among others related to him. On the contrary, the multi-language word cloud for the day of the crash (March 24th) does not mention the *copilot* at all, as expected.

### Links

+ Github Project Repository: LINK
+ Data set Sample: LINK
