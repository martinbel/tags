pkg = c("data.table", "plyr", "tm", "e1071", "Matrix")
sapply(pkg, require, c=T)

source('1_read_data.R')
source('funs.R')

### drop null
d$q_char <- nchar(as.character(d[,2]))
d <- d[d$q_char > 0, ]
d <- d[-which(is.na(d[,2])), ]

### class
class <- as.character(d[, 2])
q_class <- sort(table(class), decreasing=TRUE)
q_class = data.frame(q_class[-1])
q_class$porcentage <- (q_class[,1] / sum(q_class) ) * 100

# q_class[q_class$porcentage > 0.0001485884, ]

### title - body
title <- as.character(d[, 3])
body <- as.character(d[, 4])

X_title = bag_words(title)
X_title = removeSparseTerms(X_title, 0.99)

X_body = bag_words(body)
X_body = removeSparseTerms(X_body, 0.999)

X_all <- cbind(X_title, X_body)
X_all <- as_sparseMatrix(X_all)

# Define a seed
set.seed(123)
inx <- sample(nrow(d), round(nrow(d) * 0.7))

X_train <- X_all[inx, ]
X_test <- X_all[-inx, ]

