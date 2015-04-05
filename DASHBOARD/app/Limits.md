## __Twitter Limitations__

This project had to work around two [`Twitter API` restrictions](https://dev.twitter.com/overview/general/things-every-developer-should-know):

1) *The query done on Twitter cannot be later than 7-9 days into the past from the date that the query is done*.

2) There are limitations on time duration of the connection to Twitter to download data. For that reason several decision had to be made:
+ Download 350k tweets instead of the +900k tweets related to this Tragedy.
+ The query for the information of the users was made only on the *top 500* of the users (that is 0.26% of the total of users); because there were limitations both on the `getUsers` and `geocode` functions. The last one mainly because `Google` limits to 2.500 geo-position queries per day, but also there are time limitation to how many queries per minute are allowed. Thus I used loops to wait 10 seconds between queries see `DataAnalysis.R` for further information.
+ Download only 200k tweets in English from three days.

*For future projects, what is recommended in different sites is to download tweets every day creating the desired dataset*.


