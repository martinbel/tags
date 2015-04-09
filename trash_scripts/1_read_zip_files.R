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

