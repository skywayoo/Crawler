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
url <- "http://www.imdb.com/search/title?genres=&title_type=feature&sort=moviemeter,asc"
res <- GET(url)
restext <- htmlParse(content(res,'text',encoding = 'utf8'))
fpage <- xpathSApply(restext,"//div[@id='left']",xmlValue) 
fpage <- str_extract(fpage[1],"[0-9]+,[0-9]+")
fpage <- gsub(",","",fpage)
fpage <- as.numeric(fpage)
allpage <- ceiling(seq(0,fpage,by=50.5))
cat("total pages:",fpage,"\n")

all_url <- sprintf("http://www.imdb.com/search/title?genres=&sort=moviemeter,asc&start=%s&title_type=feature",allpage)
title <- list()
year <- list()
data_final_2<-data.frame()
for(i in 1:length(all_url)){
        cat("正在處理第",i,"頁","\n")
        url <- all_url[i]
        res <- GET(url)
        restext <- htmlParse(content(res,'text',encoding = 'utf8'))
        title[[i]] <- xpathSApply(restext,"//td[@class='title']/a",xmlValue)
        year_value <- xpathSApply(restext,"//span[@class='year_type']",xmlValue)
        year[[i]] <- str_extract(year_value,"[0-9]+")
        #title id 
        title_id <- xpathSApply(restext,"//td[@class='title']/a",xmlAttrs)
        title_id <- str_extract(title_id,"tt[0-9]+")
        title_url <- sprintf("http://www.imdb.com/title/%s/ratings?ref_=tt_ov_rt",title_id)
        title_url_2 <- sprintf("http://www.imdb.com/title/%s",title_id)
        rank_value<- vector()
        each_rank_value <- list()
        time <- vector()
        metascore <- vector()
        dir <- vector()
        actor1 <- vector()
        actor2 <- vector()
        actor3 <- vector()
        genre <- vector()
        data <- data.frame()
        for(j in 1:length(title_url_2)){
                cat("處理第",j+50*(i-1),"個電影","\n")
                res2 <- GET(title_url[j])
                restext2 <- htmlParse(content(res2,'text',encoding = 'utf8'))
                rank <- xpathSApply(restext2,"//div[@id='tn15content']//a[2]",xmlValue)
                try(rank_value[j] <- rank,silent = TRUE)
                each_rank <- xpathSApply(restext2,"//table//td",xmlValue)
                each_rank <- str_extract(each_rank,"[0-9]+.[0-9]+%")
                each_rank <- na.omit(each_rank)
                each_rank <- as.vector(each_rank)
                #r1~r10
                each_rank <- rev(gsub("%","",each_rank))
                each_rank_value[[j]] <- each_rank
                #metadata and time
                res3 <- GET(title_url_2[j])
                restext3 <- htmlParse(content(res3,'text',encoding = 'utf8'))
                try(dir[j] <- xpathSApply(restext3,"//div[@class='credit_summary_item'][1]/span/a/span[@class='itemprop']",xmlValue),silent = TRUE)
                try(actor1[j] <- xpathSApply(restext3,"//div[@class='credit_summary_item'][3]/span[1]/a/span[@class='itemprop']",xmlValue),silent = TRUE)
                try(actor2[j] <- xpathSApply(restext3,"//div[@class='credit_summary_item'][3]/span[2]/a/span[@class='itemprop']",xmlValue),silent = TRUE)
                try(actor3[j] <- xpathSApply(restext3,"//div[@class='credit_summary_item'][3]/span[3]/a/span[@class='itemprop']",xmlValue),silent = TRUE)
                try(genre[j] <- xpathSApply(restext3,"//div[@class='see-more inline canwrap'][2]/a[1]",xmlValue),silent = TRUE)
                try(time[j] <- str_extract(xpathSApply(restext3,"//time",xmlValue)[2],"[0-9]+"),silent = TRUE)
                try(metascore[j] <-str_extract(xpathSApply(restext3,"//div[@class='titleReviewBarItem'][1]/a",xmlValue)[1],"[0-9]+"),silent = TRUE)
                rank_dat <- cbind(genre[j],dir[j],actor1[j],actor2[j],actor3[j],time[j],metascore[j],rank_value[j],r1=each_rank_value[[j]][1],r2=each_rank_value[[j]][2],r3=each_rank_value[[j]][3],r4=each_rank_value[[j]][4],r5=each_rank_value[[j]][5]
                                  ,r6=each_rank_value[[j]][6],r7=each_rank_value[[j]][7],r8=each_rank_value[[j]][8],r9=each_rank_value[[j]][9],r10=each_rank_value[[j]][10])
                data <- rbind(data,as.data.frame(rank_dat))
                }
        #make a dataframe
        data_final <- data.frame(title[[i]],year[[i]])
        data_final <- cbind(data_final,data)
        data_final_2 <-rbind(data_final_2,data_final)
        Sys.sleep(5)
}
head(data_final_2,10)

write.csv(data_final_2,"IMDB.CSV")
