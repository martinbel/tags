rm(list = ls(all = TRUE)); gc()

pkg = c("data.table", "plyr", "tm", "e1071", "Matrix")
sapply(pkg, require, c=T)

source('funs.R')

### read data 
d <- fread('../tags/data/model.csv', sep='|')

### class
class <- data.table(tag=d[['tag']])
q_class <- class[, .N, by=tag]
q_class <- q_class[order(-N)]

### title - body - bag of words

X_title = bag_words(d$title)
X_title = removeSparseTerms(X_title, 0.999)

X_body = bag_words(d$body)
X_body = removeSparseTerms(X_body, 0.999)

X_all <- cbind(X_title, X_body)
X_all <- as_sparseMatrix(X_all)