rm(list = ls(all = TRUE)); gc()

out_df <- data.frame(text="0")
write.table(out_df, file='out.csv', append=F, col.names = T, row.names=F, sep='|')

i = 1
j = 1

# file_name <- '/Users/mbtangotan/Desktop/dm/free/tags/muestra.csv'
file_name <- '/Users/mbtangotan/Desktop/dm/free/tags/Posts.xml.csv'
con <- file(file_name, "r")
while (length(oneLine <- readLines(con, n = 1)) > 0) {
  row <- grep('<.*>', as.character(oneLine), value=TRUE)
  if(length(row) != 0){
    if(nchar(row) > 100){
      try(write.table(row, file='out.csv', append=T, row.names=F,
                      col.names = F, sep='|'), silent=T)
      if( (i %% 10000) == 0) {
        print(sprintf("iter: %s tot_row: %s", i, j))
      }
      i = i + 1
    }
  }
  j = j + 1
}
close(con)


library(data.table)
library(plyr)

data <- readLines('out.csv')

split_data <- lapply(seq_along(data), function(x){
  do.call(rbind, strsplit(data[x], '\t'))
})


q_char <- sapply(split_data, length)
d <- ldply(split_data, 'rbind')

d1 <- d[which(q_char == 21), c(12, 3, 11)]

head(d1)






