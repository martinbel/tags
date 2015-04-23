rm(list = ls(all = TRUE)); gc()

library(data.table)

### read tags and tags index
tags <- fread('../tags/data/keep_tags.csv', sep='|')
tags[, tag:=as.numeric(tags)]
tags <- tags[is.na(tag)]

### Keep first tag
tags[, first_tag:=gsub(">.*", ">", tags)]
q_tags <- tags[, .N, by='first_tag']

### Select 20 most common tags
top_tags <- q_tags[order(-N)][1:20]$first_tag

out_df <- data.frame(tag="0", question="0", body='0')
out_file <- 'keep_relevant_tags.csv'
write.table(out_df, file=out_file, append=F, col.names = T, row.names=F, sep='|')

file_name <- '../tags/data/Posts.xml.csv'
con <- file(file_name, "r")

i = 1; j = 1
while (length(oneLine <- readLines(con, n = 1)) > 0) {
  row <- data.frame(do.call(rbind, strsplit(oneLine, '\t')), stringsAsFactors=FALSE)
  if(length(row) > 1 & (gsub(">.*", ">", row[,12]) %in% top_tags) & nchar(row[, 12]) > 0 & nchar(row[, 3]) > 0){
      try(write.table(row[, c(12, 3, 11, 1)], 
                      file=out_file, append=T, row.names=F,
                      col.names = F, sep='|'), silent=T)
      if( (i %% 100) == 0) {
        print(sprintf("iter: %s | row number: %s", i, j))
      }
      i = i + 1
  }
  j = j + 1
}
close(con)

library(data.table)
keep <- fread(out_file, header=F, sep='|')
keep[, V1:=gsub(">.*", ">", V1)]
keep[, V3:=paste0(V3, V4, collapse='')]
keep[, V4:=NULL]

gc()



