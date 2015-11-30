#install.packages("httr")
#install.packages("XML")
#install.packages("stringr")
# install.packages("tmcn", repos="http://R-Forge.R-project.org",type="source")

library(httr)
library(XML)
library(stringr)
library(tmcn)

"\first page test
url <- 'http://www.mobile01.com/topicdetail.php?f=263&t=3626372'
header <- add_headers("User-Agent"="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.101 Safari/537.36")
res <-GET(url,header)
restext <- htmlParse(content(res,'text',encoding = 'utf8'))
text <- xpathSApply(restext,"//div[@class='single-post-content']",xmlValue)
userlevel <- xpathSApply(restext,"//div[@class='fn']/a",xmlAttrs)
userlevel <- userlevel["title",]
user <- xpathSApply(restext,"//div[@class='fn']",xmlValue)
time <- xpathSApply(restext,"//div[@class='date']",xmlValue)
value <- data.frame(user=user,level=toUTF8(userlevel),time=time,comment=text)
"

#1:200pages     %s 
wanturl <- sprintf('http://www.mobile01.com/topicdetail.php?f=263&t=3626372&p=%s',1:200)
length(wanturl)

userdata <- list()
userleveldata <- list()
timedata <- list()
textdata <- list()

for(i in 1:length(wanturl)){
    header <- add_headers("User-Agent"="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.101 Safari/537.36")
    res <-GET(wanturl[i],header)
    restext <- htmlParse(content(res,'text',encoding = 'utf8'))
    wanttext <- xpathSApply(restext,"//div[@class='single-post-content']",xmlValue)
    wantuserlevel <- xpathSApply(restext,"//div[@class='fn']/a",xmlAttrs)
    wantuser <- xpathSApply(restext,"//div[@class='fn']",xmlValue)
    wanttime <- xpathSApply(restext,"//div[@class='date']",xmlValue)
    wantuserlevel <- wantuserlevel["title",]
    userdata[[i]] <- wantuser
    userleveldata[[i]] <- wantuserlevel
    timedata[[i]] <- wanttime
    textdata[[i]] <- wanttext
    #if(i%%1==0) Sys.sleep(2)
    cat("正抓取爬第",i,"頁資料",'\n')
}

values <- data.frame(user=unlist(userdata),level=toUTF8(unlist(userleveldata)),time=unlist(timedata),comment=unlist(textdata))
head(values)
values$time <- str_extract(value$time,"[0-9]+-[0-9]+-[0-9]+ [0-9]+:[0-9]+")
#create .txt .csv
write.table(values,"1231.txt")
write.csv(values,"mobiledata1.csv")
