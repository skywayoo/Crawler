library(tmcn)
library(httr)
library(XML)
library(stringr)

#抓取url,時間,標題
data <- list()
for( i in 1:10){  #抓取1~10頁資料-每頁30個
    url <- paste("http://www.appledaily.com.tw/realtimenews/section/hot/", i, sep='')
    html <- htmlParse(GET(url))
    value <- xpathSApply(html,"//ul[@class='rtddd slvl']/li/a",xmlAttrs)
    time <- xpathSApply(html,"//a/time",xmlValue)
    title <- xpathSApply(html,"//a/h1/font",xmlValue)
    value <- toUTF8(value)
    value <- value[seq(1,60,by=2)]
    value <- str_extract_all(value,"2015[0-9]+.[0-9]+.")
    value<- unlist(value)
    data <- rbind(data,time,title,paste('http://www.appledaily.com.tw//realtimenews/article/hot/', value, sep=''))
    # if(i%%3==0) Sys.sleep(5)
    cat(i)
}
data <- unlist(data)
time <- data[seq(1,900,by = 3)]
title <- data[seq(2,900,by=3)]
text <- data[seq(3,900,by=3)]
data <- rbind(time,title,text)
texturl <- data[seq(3,900,by=3)]

getwd()  #pwd
setwd("/Users/skywayoo/applenews123")   #cd

#抓取文章內容
for(i in 1:length(texturl)){
    url <- texturl[i]
    html <- htmlParse(GET(url), encoding='UTF-8')
    doc <- xpathSApply(html, "//p[@id='summary']", xmlValue)
    name <- c(strsplit(url, '/')[[1]][8],i)
    name <- toString(name)
    name <- gsub(", ",replacement = "- ",name)
    write.table(doc, file = name,col.names = FALSE,row.names = FALSE)
    #if(i%%3=0) Sys.sleep(5)
}
