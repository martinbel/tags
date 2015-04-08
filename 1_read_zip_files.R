rm(list = ls(all = TRUE)); gc()
pkg = c("data.table", "plyr", "tm", "e1071", "Matrix", 'XML')

library(XML2R)
sapply(pkg, require, c=T)
source('funs.R')

wd <- getwd()
directories <- sprintf('%s/stackexchange/%s', wd, list.files(path=paste0(wd, '/stackexchange')))
xmls <- paste0(directories, '/Posts.xml')

## read xml
obs <- XML2Obs(xmls[1], local=TRUE)
obs <- ldply(as.list(obs), 'rbind')






doc = xmlTreeParse(files[6], useInternalNodes = TRUE)

lapply(getNodeSet(doc, "//tags//row[@TagName]"), xmlValue)

tag_path <- '//*[@id="collapsible0"]/div[1]/div[2]/div[1]/span/span[2]/span[2]'
sapply(xml[tag_path], xmlValue)

xmlToDataFrame(xml)

tag_name <- xpathApply(xml, '//tags/row/TagName')

time_path <- "//start-valid-time"
temp_path <- "//temperature[@type='hourly']/value"

df <- data.frame(
  latitude=data[["number(//point/@latitude)"]],
  longitude=data[["number(//point/@longitude)"]],
  start_valid_time=sapply(data[time_path], xmlValue),
  hourly_temperature=as.integer(sapply(data[temp_path], as, "integer"))



data <- unz('7z',filename=zip_files[[1]])
data <- read.table(data)

temp <- tempfile()
data <- readLines(unz(temp, "/Users/mbtangotan/Desktop/dm/free/tags/beer.stackexchange.com.7z"))
data <- read.table(unz(temp, "a1.dat"))
unlink(temp)

split_data <- lapply(seq_along(data), function(x){
  do.call(rbind, strsplit(data[x], '\t'))
})

d <- ldply(split_data, 'rbind')




### drop null
d$q_char <- nchar(as.character(d[,2]))
d <- d[d$q_char > 0, ]
d <- d[-which(is.na(d[,2])), ]
