library(shiny)
library(xtable)

shinyServer(function(input, output){
  output$top10 = renderTable({
    
    table10<-data.frame(User=c("PsichiatriaITA","la_patilla","ElNacionalWeb","EdWardMDBlog",
                             "JohnDiNardo","ReshetnikovM","spintweeter","piketebow","twitte_labnol","24timestv"),
                      Number_of_Tweets=c("268","257","218","200","186","185","182","169","169","168"),
                      Place=c("Genoa, Italy","Venezuela",
                              "Caracas, Venezuela",NA,NA,"Minsk, Belarus","Dortmund, Germany",NA,NA,NA))
    colnames(table10)<-c("User", "Number of Tweets","Place")
    table10
    }, sanitize.text.function = function(x) x)
  
  output$Ret = renderTable({
    
    tableRet<-data.frame(Text=c("RT @LiveBreakinNews: Voici le msg qu'on peut retenir de la part des medias #AndreasLubitz #CrashA320 #Germanwings #BoycottBFM_iTele_TF1 htt",
                                "RT @_ju1_: Algo estamos haciendo mal. Y MUY MAL. #Germanwings http://t.co/yecmaFK8JC",
                                "RT @iansomerhalder: I am so sorry to all those affected and killed by the Germanwings flight crashing.This is tragic. I'm so so sorry...",
                                "RT @BBCBreaking: It was co-pilot's 'intention to destroy this plane' French officials say http://t.co/Cd2D1Vuluy #Germanwings",
                                "RT @BBCBreaking: Germanwings Airbus A320 crashes in French Alps near Digne http://t.co/yNlWbNJmYI"),
                         Number_of_Tweets=c("10257","4876","4828","4795","4379"))
    colnames(tableRet)<-c("Text", "Number of ReTweets")
    tableRet
  }, sanitize.text.function = function(x) x) 
})

