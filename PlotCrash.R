
library(geosphere)
library(ggplot2)
library(ggmap)


crash_map <- get_map(c(lon = 6.4064132, lat = 44.232578), zoom =6,maptype = "terrain")

c<-ggmap(crash_map)

plotCrash<-data.frame(Location=c("Barcelona","Crash"),Latitude=c(41.297445,44.232578),Longitude=c(2.083294,6.4064132))

inter <- gcIntermediate(c(2.083294, 41.297445), c(6.4064132, 44.232578), n=50, addStartEnd=TRUE)
inter<-as.data.frame(inter)

crash<-c+geom_point(data=inter,aes(x=lon,y=lat),color="purple",size=3)+
  geom_point(data=plotCrash,aes(x=Longitude,y=Latitude),color="blue",size=5)+
  annotate("text",x=6.4064132 ,y=44.5,label="Crash area",size=10,fontface="italic",colour = "blue")+
  annotate("text",x=1.6 ,y=41.9,label="Barcelona",size=8,fontface="italic",colour = "blue")+
  ylab("Latitude")+xlab("Longitude")+
  ggtitle("Crash: Distance from Barcelona")+theme(axis.text.x= element_blank(),
                                                                     axis.text.y= element_blank(),
                                                                     plot.title = element_text(size = 20,
                                                                                               colour = "blue"),
                                                                     axis.title.x = element_text(color="blue",size=20),
                                                                     axis.title.y = element_text(color="blue",size=20))

png(filename="crash.png",width = 500,height = 500)
crash
dev.off()





