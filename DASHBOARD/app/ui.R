#install.packages(c("shiny", "dplyr", "htmlwidgets", "digest", "bit","scales"))
#devtools::install_github("rstudio/shinydashboard")
#devtools::install_github("hadley/shinySignals")
library(shiny)
library(shinydashboard)
library(shinySignals)
library(htmlwidgets)
library(scales)
library(markdown)


dashboardPage(
  dashboardHeader(title = "#Germanwings"),
  dashboardSidebar(sidebarMenu(
    menuItem("Description", tabName = "description", icon = icon("info")),
    menuItem("Dashboard", tabName = "dashboard", icon = icon("search")),
    menuItem("Sentiment Analysis", icon = icon("users"), tabName = "Sentiment"))),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "description", 
              fluidRow(includeMarkdown("Tragedy.md"),img(src = "germanwings_twitter.png", height = 100, width = 500),
                       img(src = "germanwings_tweet.png", height = 100, width = 500)),
              fluidRow(includeMarkdown("Description.md")),
              fluidRow(includeMarkdown("Limits.md"))),
      tabItem(tabName = "dashboard",h2("Twitter information between March 24-31th"),
              fluidRow(
                tabBox(
                  title = "Twitter Facts",
                  id = "tabset1", height = "250px", width = 5,
                  tabPanel("Info Box",fluidRow(
                           valueBox(h4("Total Tweets #Germanwings",align = "center"), h1(937.885,align = "center"),
                                    icon = icon("twitter"),color="purple",width = 12),
                           valueBox(h4("Tweets in sample"), h2(paste(percent(0.37),"(350K)")),icon = icon("cloud-download"),
                                    width = 6),
                           valueBox(h4("Unique Twitter Users"), h2("190.182",align = "center"),icon = icon("user"),color="green",width = 6),
                           valueBox(h4("Average per User"), h2("1.8 Tweets"),icon = icon("comments"),color="yellow",width = 6),
                           valueBox(h4("Users w/ 2 Tweets or +"), h2(percent(0.122),align = "center"),icon = icon("refresh"),
                                    color="orange",width = 6))),
                  tabPanel("Top 10 Users",tableOutput("top10")),
                  tabPanel("Most Retweets",tableOutput("Ret"))
                ),
                tabBox(title = "Plots",id = "tabset2",width = 7,
                  side = "left", height = "500px",
                  tabPanel("Crash Location",img(src = "crash.png", height = 600, width = 600)),
                  tabPanel("Location: Top Users in World",img(src = "topusers.gif", height = 600, width = 700)),
                  tabPanel("Location:Top Users in Europe",img(src = "europemap.png", height = 600, width = 600))
                ))),
      tabItem(tabName = "Sentiment",
              h2("Sentiment Analysis: 100k tweets from March 26 plus 100k from 29 and 30th"),
              fluidRow(
                tabBox(
                  title = "Sentiment: Positive - Neutral - Negative Tweets",
                  id = "tabset3", height = "250px",width = 4,
                  tabPanel("Facts",fluidRow(
                    valueBox(h4("Mean Score: on average 'negative tweet'"), h1("-0.96",align = "center"),
                             icon = icon("twitter"),color="purple",width = 12),
                    valueBox(h4("Minimum Score"), h1(-9,align = "center"),icon = icon("arrow-circle-down"),
                             width = 6),
                    valueBox(h4("Maximum Score"), h1(4,align = "center"),icon = icon("arrow-circle-up"),color="green",width = 6),
                    valueBox(h4("Percentage of Negative Tweets"), h1("67%",align = "center"),icon = icon("meh-o"),
                             color="yellow",width = 12),
                    valueBox(h4("Percentage of Neutral (or informative) Tweets"), h1("27.5%",align = "center"),icon = icon("info-circle"),
                             color="maroon",width = 12)))),
                tabBox(title = "Plots",id = "tabset4", width = 8,
                       side = "left", height = "500px",
                       tabPanel("Histogram",img(src = "histogram.png", height = 700, width = 700)),
                       tabPanel("March 26th",img(src = "plot26.png", height = 700, width = 700)),
                       tabPanel("March 29-30th",img(src = "plot2930.png", height = 700, width = 700)),
                       tabPanel("Word Cloud: Sent. Analysis",img(src = "wordcloud.png", height = 400, width = 700)),
                       tabPanel("Word Cloud: Crash Day Multi-Lang.",img(src = "wordcloud2.png", height = 400, width = 700))
                       )
                )))))

