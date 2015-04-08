rm(list = ls(all = TRUE)); gc()

library(data.table)
library(plyr)

data <- readLines('cstheory.tsv')

split_data <- lapply(seq_along(data), function(x){
  do.call(rbind, strsplit(data[x], '\t'))
})

d <- ldply(split_data, 'rbind')




