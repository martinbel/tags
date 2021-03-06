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

### to use RWeka
# library('RWeka')
# options(mc.cores=1)

### Make bag of words of title and body

### Remove sparse terms. Here a lot of irrelevant variables get removed
X_title_unigram = bag_words(d$title)
X_title_unigram = removeSparseTerms(X_title_unigram, 0.999)

X_title_bigram = bag_words_bigram(d$title)
X_title_bigram = removeSparseTerms(X_title_bigram, 0.999)

X_body_unigram = bag_words(d$body)
X_body_unigram = removeSparseTerms(X_body_unigram, 0.9999)

X_body_bigram = bag_words_bigram(d$body)
X_body_bigram = removeSparseTerms(X_body_bigram, 0.9999)

### Make a sparse matrix with all the data
X_all <- cbind(X_title_unigram, X_body_unigram, X_title_bigram, X_body_bigram)
X_all <- as_sparseMatrix(X_all)
