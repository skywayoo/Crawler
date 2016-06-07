
## M03A - M08A
MA <- c("03","04","05","06","07","08")
MxxA <- sprintf("M%sA",MA)
for(n in 1:length(MA)){
cat("loading the data...")
dir.create(MxxA[n])
setwd(MxxA[n])
#parse the data
url <- paste("http://tisvcloud.freeway.gov.tw/history/TDCS/",MxxA[n],sep = "")
res <- GET(url)
restext <- content(res,type="text",encoding = 'utf-8')
#get folder
folder <- unlist(str_extract_all(restext,"2016[0-9]+/")) 
folder <- folder[seq(1,length(folder),by=3)]
hr <- c("00","01","02","03","04","05","06","07","08","09","10",11:23)
  for(fo in 1:length(folder)){
  f_url <- paste("http://tisvcloud.freeway.gov.tw/history/TDCS/",MxxA[n],"/",folder[fo],hr,"/",sep="")
    for(h in 1:length(hr)){
    f_res <- GET(f_url[h])
    f_res <- str_extract_all(f_res,"TDCS[\\w]+.csv")
    f_res <- unlist(f_res)
    f_res <- f_res[seq(1,length(f_res),by=3)]
      for(f in 1:length(f_res)){
        dir.create(paste(str_extract(folder,"[0-9]+")[fo],sep=""))
        setwd(paste(str_extract(folder,"[0-9]+")[fo],sep=""))
        dir.create(paste(hr[h],sep=""))
        setwd(paste(hr[h],sep=""))
        download.file(paste(f_url[h],f_res[f],sep=""),destfile=f_res[f])
        setwd(paste("~/kaokon/",MxxA[n],sep=""))
        Sys.sleep(5)
        }
  }
}

#get all of the "*.tar.gz"     
setwd("~/kaokon/")
gz <- str_extract_all(restext,"M[0-9]+A_[0-9]+.tar.gz")
gz <- unlist(gz)
gz <- gz[seq(1,length(gz),by=3)]
  for(i in 1:length(gz)){
    gz_url <- paste("http://tisvcloud.freeway.gov.tw/history/TDCS/",MxxA[i],"/",gz[i],sep="")
    download.file(gz_url,destfile=gz[i])
    untar(gz[i])  ## unzip
    Sys.sleep(5)
  }
}
