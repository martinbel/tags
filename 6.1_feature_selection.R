### Run Unigram preprocessing script
source("2_preproc.R")
library(glmnet)
library(data.table)

# Define a seed to split in training and testing sets
set.seed(123)

# Take a small sample. It's for feature selection only
# But it will run faster and 10% is enought
inx <- sample(nrow(d), round(nrow(d) * 0.1)) 

# Class vector
y = as.factor(class$tag)
y_train = y[inx]
y_test = y[-inx]

# Training and testing datasets
X_train <- X_all[inx, ]
X_test <- X_all[-inx, ]

# remove unnecesary objects from the global environment
# rm(X_all); gc()

X_train <- as.matrix(X_train)
X_train <- as.data.table(X_train)

rm(X_all)
rm(X_test)
rm(d)
gc()

col_zero <- apply(X_train, 2, function(x) sum(x == 0))
row_zero <- apply(X_train, 1, function(x) sum(x == 0))

#################################
### Feature selection - CARET ###
#################################
library(caret)

### Variable Selection ###
filter <- sbf(X_train, y_train,  
  sbfControl = sbfControl(functions = rfSBF, 
    method = "cv", number=3, repeats=1,
    verbose = TRUE, 
    allowParallel=FALSE  #  set this to true if you have RAM
    # You would need at least 16GB for it to run on parallel
    ))

save(filter, file='sbf_filter_cv.RData')