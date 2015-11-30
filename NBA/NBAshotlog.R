library(httr)
library(XML)
library(stringr)
library(rjson)
#parse data
url <- 'http://stats.nba.com/stats/playerdashptshotlog?DateFrom&DateTo&GameSegment&LastNGames=0&LeagueID=00&Location&Month=0&OpponentTeamID=0&Outcome&Period=0&PlayerID=201939&Season=2015-16&SeasonSegment&SeasonType=Regular+Season&TeamID=0&VsConference&VsDivision'
res <- GET(url)
restext <- content(res,'text')

#json
jsondata = fromJSON(restext)
jsondata <- data.frame(do.call(rbind,jsondata$resultSets[[1]]$rowSet))
head(jsondata)
#colname
colnames(jsondata) <- c("GAME_ID",
                     "MATCHUP",
                     "LOCATION",
                     "WL",
                     "FINAL_MARGIN",
                     "SHOT_NUMBER",
                     "PERIOD",
                     "GAME_CLOCK",
                     "SHOT_CLOCK",
                     "DRIBBLES",
                     "TOUCH_TIME",
                     "SHOT_DIST",
                     "PTS_TYPE",
                     "SHOT_RESULT",
                     "CLOSEST_DEFENDER",
                     "CLOSEST_DEFENDER_PLAYER_ID",
                     "CLOSE_DEF_DIST",
                     "FGM",
                     "PTS")
