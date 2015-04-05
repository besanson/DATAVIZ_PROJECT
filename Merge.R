##################################################
#This script is for creating one single data set for each task
##################################################

##Task 1

#Importing csv files for each day

dayOne<-read.csv(file = "C:/Users/gaston/Dropbox/DATAVIZ-PROJECT/Data/FirstDayNoGeoPos.csv",header = TRUE,sep = ",")
dayTwo<-read.csv(file = "C:/Users/gaston/Dropbox/DATAVIZ-PROJECT/Data/SecondDayNoGeoPos.csv",header = TRUE,sep = ",")
dayThree<-read.csv(file = "C:/Users/gaston/Dropbox/DATAVIZ-PROJECT/Data/ThirdDayNoGeoPos.csv",header = TRUE,sep = ",")
dayFour<-read.csv(file = "C:/Users/gaston/Dropbox/DATAVIZ-PROJECT/Data/FourthDayNoGeoPos.csv",header = TRUE,sep = ",")
dayFive<-read.csv(file = "C:/Users/gaston/Dropbox/DATAVIZ-PROJECT/Data/FifthDayNoGeoPos.csv",header = TRUE,sep = ",")
daySix<-read.csv(file = "C:/Users/gaston/Dropbox/DATAVIZ-PROJECT/Data/SixthDayNoGeoPos.csv",header = TRUE,sep = ",")
daySeven<-read.csv(file = "C:/Users/gaston/Dropbox/DATAVIZ-PROJECT/Data/SeventhDayNoGeoPos.csv",header = TRUE,sep = ",")

#Not taking column one because it is a counter

dataset1<-rbind(dayOne[,-1],dayTwo[,-1],dayThree[,-1],dayFour[,-1],dayFive[,-1],daySix[,-1],daySeven[,-1])

#I checked with the function unique() that there were not duplicated rows
# This are the column names
#colnames(dataset1)
#[1] "text"          "favorited"     "favoriteCount" "replyToSN"     "created"       "truncated"     "replyToSID"   
#[8] "id"            "replyToUID"    "statusSource"  "screenName"    "retweetCount"  "isRetweet"     "retweeted"    
#[15] "longitude"     "latitude"

#Create a unique dataset csv file for task 1
write.csv(dataset1, file = "dataset1.csv")

################################################

##Task 2
SentOne<-read.csv(file = "C:/Users/gaston/Dropbox/DATAVIZ-PROJECT/Data/FirstSent.csv",header = TRUE,sep = ",")
SentTwo<-read.csv(file = "C:/Users/gaston/Dropbox/DATAVIZ-PROJECT/Data/ScondSent.csv",header = TRUE,sep = ",")

dataset2<-rbind(SentOne[,-1],SentTwo[,-1])

#I checked with the function unique() that there were not duplicated rows

#Create a unique dataset csv file for task 2
write.csv(dataset2, file = "dataset2.csv")

