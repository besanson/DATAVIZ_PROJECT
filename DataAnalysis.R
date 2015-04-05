##################################################
#This script is for Task 1: Descriptive information of Germanwings crash in Twitter
##################################################

##### Packages #####
require(twitteR)
require(ggplot2)
require(dismo)
require(XML)
require(plyr)
require(ggmap)
require(mapproj)
require(rworldmap)
require(dplyr)
require(geosphere)
require(animation)


##API TWITTER### This a personal key only created for this project

consumer_key <- "4muYvjyyNunIBTDwhw47UEL6B"
consumer_secret <- "Sk8NGEWvfut6illb7MvQr827eDGzeg7eyXQj0OEm8QtTAwa79I"
access_token <- "26879352-3sAmtn4XwrNTYUXJLPt7KMVQW9QaqGunviUMYVWJi"
access_secret <- "QJCmVnSfjVFO39HfGN9mZ1fxDy0VqsdMyi5n9gC9mnE6i"
setup_twitter_oauth(consumer_key,
                    consumer_secret,
                    access_token,
                    access_secret)

##Loading Data####

#Removing the fist column that is a counter
dataset1<-read.csv(file = "C:/Users/gaston/Dropbox/DATAVIZ-PROJECT/Data/dataset1.csv",header = TRUE,sep = ",")[,-1]

##Data Anaylisis##

###Users that tweeted more about the crash

top10<-as.data.frame(summary(dataset1$screenName,11))
top10<-cbind(row.names(top10),top10)
rownames(top10)<-NULL
colnames(top10)<-c("User","Number of Tweets")
top10<-top10[-c(11),]

#Average number of tweets per unique user
AverageTweets<-round(350000/length(unique(dataset1$screenName)),2)

#Where are this top 10 users from?

UserInfo10<-lookupUsers(top10$User) #look information about the users
UserFrame10<-twListToDF(UserInfo10) # transform it into a Data Frame
locatedUsers10 <- !is.na(UserFrame10$location) #Remove NA
locations10 <- geocode(UserFrame10$location[locatedUsers10],oneRecord = TRUE) #get Geo position returning first finding
top10$Place<-locations10$interpretedPlace #add to top 10 table

#Most Retweeted tweets
Retweet<-data.frame(text=dataset1$text,retweetCount=dataset1$retweetCount)

Retweet<-Retweet[order(-Retweet$retweetCount),]
RetweetSum<-unique(Retweet)
View(RetweetSum)

###Where are the 190182 unique users from? Too much consuming it must be narrow down

#Users above Average Tweets
users<-count(dataset1,"screenName")
colnames(users)<-c("User", "Tweets")
users<-users[order(-users$Tweets),]
aboveAverage<- users[users$Tweets>2,]

# Top 500 twitter users

users <- users[1:500,]
users <- sapply(users, as.character)
# make a data frame for the loop to work with 
users.df <- data.frame(users = users, 
                       Location = "", stringsAsFactors = FALSE)
colnames(users.df)<-c("Users","Tweets","Location")
#
# loop to populate users$Location with location of the user 
for (i in 1:nrow(users.df)){
  # tell the loop to skip a user if their account is protected 
  # or some other error occurs  
  result <- try(getUser(users.df$Users[i])$location, silent = TRUE);
  if(class(result) == "try-error") next;
  # get the location
  users.df$Location[i] <- getUser(users.df$Users[i])$location
  # tell the loop to pause for  10s between iterations to 
  # avoid exceeding the Twitter API request limit
  print(i)
  Sys.sleep(10); 
}

#Save the file
write.csv(users.df, file = "Top500Users.csv")

#Search the location of this users Lat-Log

userFrame<-users.df

locatedUsers <- !is.na(userFrame$Location)  # Keep only users with location info

# API to guess approximate lat/lon from textual location data. But has limits to 2500 queries a day.

locations1 <- dismo::geocode(userFrame$Location[locatedUsers][1:50],oneRecord = TRUE)
locations2 <- dismo::geocode(userFrame$Location[locatedUsers][51:100],oneRecord = TRUE)
locations3 <- dismo::geocode(userFrame$Location[locatedUsers][101:150],oneRecord = TRUE)
locations4 <- dismo::geocode(userFrame$Location[locatedUsers][151:200],oneRecord = TRUE)
locations5 <- dismo::geocode(userFrame$Location[locatedUsers][201:250],oneRecord = TRUE)
locations6 <- dismo::geocode(userFrame$Location[locatedUsers][251:300],oneRecord = TRUE)
locations7 <- dismo::geocode(userFrame$Location[locatedUsers][301:350],oneRecord = TRUE)
locations8 <- dismo::geocode(userFrame$Location[locatedUsers][351:400],oneRecord = TRUE)
locations9 <- dismo::geocode(userFrame$Location[locatedUsers][401:450],oneRecord = TRUE)
locations10 <- dismo::geocode(userFrame$Location[locatedUsers][451:500],oneRecord = TRUE)

locations<-rbind(locations1,locations2,locations3,locations4,locations5,locations6,
                 locations7,locations8,locations9,locations10)

locatedUsers2 <- !is.na(locations$longitude)


#Actually only 296 users of the top 500 had an identifying location
locationsPlot<-locations[locatedUsers2,]

#save file
write.csv(locationsPlot, file = "locationsPlot.csv")

locationsPlot<-read.csv(file = "C:/Users/DON/Dropbox/DATAVIZ-PROJECT/Data/locationsPlot.csv",header = TRUE,sep = ",")[,-1]


####Location of Users World

worldMap <- getMap()
world.points <- fortify(worldMap)
world.points$region <- world.points$id

world.df <- world.points[,c("long","lat","group", "region")]

worldmap <- ggplot() + 
  geom_polygon(data = world.df, aes(x = long, y = lat, group = group)) +
  scale_y_continuous(breaks = (-2:2) * 30) +
  scale_x_continuous(breaks = (-4:4) * 45)

worldmapUsers<-worldmap+geom_point(data = locationsPlot,
                     aes(x = longitude, y = latitude), color = "red", size = 3,alpha=0.9)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  theme(axis.text.x= element_text(color="blue",size=14),
        axis.text.y= element_text(color="blue",size=14),
        plot.title = element_text(size = 20,
                                  colour = "blue"),
        axis.title.x = element_text(color="blue",size=20),
        axis.title.y = element_text(color="blue",size=20))+ylab("Latitude")+xlab("Longitude")+
  ggtitle("Location: Top Active Users")

png(filename="worldmap.png",width = 1000,height = 1000)
worldmapUsers
dev.off()


####

rotateMap <- function(angle){
worldmap2 <- ggplot() + 
  geom_polygon(data = world.df, aes(x = long, y = lat, group = group)) +
  scale_y_continuous(breaks = (-2:2) * 30) +
  scale_x_continuous(breaks = (-4:4) * 45) +
  coord_map("ortho", orientation=c(20, angle, 0))+geom_point(data = locationsPlot,
                                                           aes(x = longitude, y = latitude), color = "red", size = 3,alpha=0.9)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  theme(axis.text.x= element_text(color="blue",size=14),
        axis.text.y= element_text(color="blue",size=14),
        plot.title = element_text(size = 20,
                                  colour = "blue"),
        axis.title.x = element_text(color="blue",size=20),
        axis.title.y = element_text(color="blue",size=20))+ylab("Latitude")+xlab("Longitude")+
  ggtitle("Location: Top Active Users")
}

path.to.convert <- paste0(shortPathName(
  "C:\\Program Files\\ImageMagick-6.9.0-Q16\\"), "convert.exe")

saveGIF({
  ani.options(nmax = 360,convert=path.to.convert)
  for(i in seq(0,360)){
    print(rotateMap(i))
  }
}, interval = 0.1 ,outdir="C:/Users/DON/Dropbox/DATAVIZ-PROJECT",
movie.name = "topusers.gif")



#### Location of Users Europe

map <- get_map(location = 'Europe', zoom = 4,maptype = "toner")
EuropeUsers<-ggmap(map)+geom_point(data = locationsPlot,
                      aes(x = longitude, y = latitude), color = "red", size = 5,alpha=0.9)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  theme(axis.text.x= element_text(color="blue",size=14),
        axis.text.y= element_text(color="blue",size=14),
        plot.title = element_text(size = 20,
                                  colour = "blue"),
        axis.title.x = element_text(color="blue",size=20),
        axis.title.y = element_text(color="blue",size=20))+ylab("Latitude")+xlab("Longitude")+
  ggtitle("Location in Europe: Top Active Users")

png(filename="europemap.png",width = 1000,height = 1000)
EuropeUsers
dev.off()




