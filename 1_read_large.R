rm(list = ls(all = TRUE)); gc()

out_df <- data.frame(tag="0", question="0", body='0')
write.table(out_df, file='out.csv', append=F, col.names = T, row.names=F, sep='|')

#file_name <- '/Users/mbtangotan/Desktop/dm/free/prueba.csv'
file_name <- '/Users/mbtangotan/Desktop/dm/free/tags/Posts.xml.csv'
con <- file(file_name, "r")

i = 1
while (length(oneLine <- readLines(con, n = 1)) > 0) {
  row <- data.frame(do.call(rbind, strsplit(oneLine, '\t')), stringsAsFactors=FALSE)
  if(length(row) > 1 & nchar(row[, 12]) > 0 & nchar(row[, 3]) > 0){
      try(write.table(row[, c(12, 3, 11)], 
                      file='out.csv', append=T, row.names=F,
                      col.names = F, sep='|'), silent=T)
      if( (i %% 10000) == 0) {
        print(sprintf("iter: %s", i))
      }
      i = i + 1
  }
}
close(con)

# x <- fread('out.csv', header=T, sep='|')



