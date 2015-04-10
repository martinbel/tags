rm(list = ls(all = TRUE)); gc()

# Load packages
pkg = c("data.table", "plyr", "tm", "e1071", "Matrix")
sapply(pkg, require, c=T)

# Call functions
source('funs.R')

### Read data to fit the model
d <- fread('../tags/data/model.csv', sep='|')

### Class (tag)
class <- data.table(tag=d[['tag']])
q_class <- class[, .N, by=tag]
q_class <- q_class[order(-N)]

### Make bag of words of title and body
X_title = bag_words(d$title)
X_body = bag_words(d$body)

### Remove sparse terms. Here a lot of irrelevant variables get removed
X_title = removeSparseTerms(X_title, 0.999)
X_body = removeSparseTerms(X_body, 0.999)

### Make a sparse matrix with all the data
X_all <- cbind(X_title, X_body)
X_all <- as_sparseMatrix(X_all)