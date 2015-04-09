rm(list = ls(all = TRUE)); gc()

pkg = c("data.table", "plyr", "tm", "e1071", "Matrix")
sapply(pkg, require, c=T)

source('funs.R')

### First run cut_script.sh
# system("sh cut_script.sh")

tags <- readLines('../tags/data/tags.csv')
q_char_tags <- nchar(tags)
keep_tags <- which(q_char_tags > 0)
tags <- tags[keep_tags]
write.table(data.frame(tags=tags, keep_tags=keep_tags), file='../tags/data/keep_tags.csv', 
            row.names=FALSE, sep='|')

### read tags and tags index
tags <- fread('../tags/data/keep_tags.csv', sep='|')
tags[, tag:=as.numeric(tags)]
tags <- tags[is.na(tag)]

### Keep first tag
tags[, first_tag:=gsub(">.*", ">", tags)]
q_tags <- tags[, .N, by='first_tag']

### Select 20 most common tags
top_tags <- q_tags[order(-N)][1:20]$first_tag
tags[, keep_top:=ifelse(first_tag %in% top_tags, 1, 0)]

### Tags result
tags <- tags[, list(tag=first_tag, keep_top, keep_tags)]
tags <- tags[keep_top == 1]
top_tags_index <- tags[, list(keep_tags)]$keep_tags

gc()

### Read body in two chunks (faster)
top_body <- readLines('../tags/data/body.csv', n=(max_n-1e7) )
top_body <- data.table(top_body)

top_tags_index_1 <- top_tags_index[top_tags_index <= (max_n-1e7)]
top_body <- top_body[top_tags_index_1, names(top_body), with=F]

gc()


tail_body <- readLines('../tags/data/tail_body.csv')
tail_body <- data.table(tail_body)

top_tags_index_2 <- top_tags_index[top_tags_index > (max_n-1e7)]
top_tags_index_2 <- top_tags_index_2 - 1e7
tail_body <- tail_body[top_tags_index_1, names(tail_body), with=F]


q_char_body <- nchar(body)
keep_body <- which(q_char_body > 100)
top_body[, q_char_body:=nchar(top_body)]
top_body[, keep_body:=q_char_body > 100]
top_body <- body[keep_body == TRUE]



### Read title 
title <- readLines('../tags/data/title.csv')
title <- data.table(title)
title[, q_char_title:=nchar(title)]
title[, keep_title:=q_char_title > 10]
title <- title[top_tags_index, names(title), with=FALSE]



