library(httr)
library(XML)
library(stringr)
getwd()
setwd("Crawler/IMDB/")
#get the Genre
genre_url <- "http://www.imdb.com/chart/boxoffice?ref_=nv_ch_cht_1"
genre_res <-GET(genre_url) 
genre_restext <- htmlParse(content(genre_res,'text','utf8'))
genre <- xpathSApply(genre_restext,"//li[@class='subnav_item_main']",xmlValue)
genre <- str_extract(genre,"[A-Za-z]+")
genre[1]
genre <- tolower(genre)
genre[1]
#without documentary
genre <- genre[7]
#Parse the title,year,time,dir,actor1:3,r1:r10
#count total pages
url <- paste0("http://www.imdb.com/search/title?genres=",genre,"&title_type=feature&sort=moviemeter,asc")
res <- GET(url)
restext <- htmlParse(content(res,'text',encoding = 'utf8'))
fpage <- xpathSApply(restext,"//div[@id='left']",xmlValue) 
fpage <- str_extract(fpage[1],"[0-9]+,[0-9]+")
fpage <- gsub(",","",fpage)
fpage <- as.numeric(fpage)
allpage <- ceiling(seq(0,fpage,by=50.5))
cat("total pages:",fpage,"\n")

data <- list()
for(i in 1:n){
    }
url <- sprintf("http://www.imdb.com/search/title?genres=&sort=moviemeter,asc&start=%s&title_type=feature&tok=2f66",allpage)
res <- GET(url)
restext <- htmlParse(content(res,'text',encoding = 'utf8'))
fpage <- xpathSApply(restext,"//div[@id='left']",xmlValue) 
fpage <- str_extract(fpage[1],"[0-9]+,[0-9]+")
fpage <- gsub(",","",fpage)
fpage <- as.numeric(fpage)
fpage

title <- xpathSApply(restext,"//td[@class='title']/a",xmlValue)
title
year <- xpathSApply(restext,"//span[@class='year_type']",xmlValue)
year <- str_extract(year,"[0-9]+")
year
rank <- xpathSApply(restext,"//span[@class='value']",xmlValue)
rank
dir <- xpathSApply(restext,"//td[@class='title']/span[@class='credit']/a[1]",xmlValue)
dir
actor1 <- xpathSApply(restext,"//td[@class='title']/span[@class='credit']/a[2]",xmlValue)
actor2 <- xpathSApply(restext,"//td[@class='title']/span[@class='credit']/a[3]",xmlValue)
actor3 <- xpathSApply(restext,"//td[@class='title']/span[@class='credit']/a[4]",xmlValue)
actor1
time <- xpathSApply(restext,"//td[@class='title']/span[@class='runtime']",xmlValue)
time <- str_extract(time,"[0-9]+")
time
genre <- xpathSApply(restext,"//span[@class='genre']/a[1]",xmlValue)
genre

title_id <- xpathSApply(restext,"//td[@class='title']/a",xmlAttrs)
title_id
title_id <- str_extract(title_id,"tt[0-9]+")
title_url <- sprintf("http://www.imdb.com/title/%s/ratings?ref_=tt_ov_rt",title_id)
title_url[1]
res2 <- GET(title_url[1])
restext2 <- htmlParse(content(res2,'text',encoding = 'utf8'))
each_rank <- xpathSApply(restext2,"//table//td",xmlValue)
each_rank <- str_extract(each_rank,"[0-9]+.[0-9]+%")
each_rank <- na.omit(each_rank)
each_rank <- as.vector(each_rank)
#r1~r10
each_rank <- rev(gsub("%","",each_rank))
each_rank
