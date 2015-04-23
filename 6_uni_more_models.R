### Run Unigram preprocessing script
# You can change this part according to 
# which dataset you will be working with
source("2_preproc.R")
library(glmnet)
library(caret)

# Define a seed to split in training and testing sets
set.seed(123)

# Take a small sample for the model -
# As you have less features now, you can use a larger sample
inx <- sample(nrow(d), round(nrow(d) * 0.1)) 

# Class vector
y = as.factor(gsub('[[:punct:]]', '', class$tag))
y_train = y[inx]
y_test = y[-inx]

# Training and testing datasets
X_train <- X_all[inx, ]
X_test <- X_all[-inx, ]

# remove unnecesary objects from the global environment
# rm(X_all); gc()

# You need a "normal" matrix for training the models.
# Most of them don't support sparse matrices such as glmnet
X_train <- as.data.table(as.matrix(X_train))

library(doMC)
# Use cores = 1 if you don't have RAM
registerDoMC(cores = 1) 

# Change the amount of folds
nfolds = 3
control= trainControl(method='cv', classProbs=TRUE, number=nfolds,
                      allowParallel=TRUE)

### There was an error (some names were duplicated ...)
# This just adds an X and the number of the variable
# You would need to do the same to the dataset you will use to predict
old_names <- names(X_train)
nm <- sprintf('X_%s', 1:length(X_train))
names(X_train) <- nm

### Random Forest ###
rf <- train(y_train ~ ., data=X_train, 
               method='rf', metric = "ROC",
               trControl=control, verbose=T, 
               tuneLength=4)
save(rf, file='../tags/model/rf.RData')

### GBM ###
gbm <- train(y[inx_train] ~ ., data=X_train, 
               method='gbm', metric = "ROC",
               trControl=control, verbose=T, tuneLength=4)
save(gbm, file='../tags/model/gbm.RData')

### Sparse LDA ###
sparseLDA <- train(y ~ ., data=X_train, with=FALSE], 
               method='sparseLDA', metric = "ROC",
               trControl=control, verbose=T, tuneLength=4)
save(sparseLDA, file='../tags/model/sparseLDA.RData')


### Random Forest ###
svmLinear <- train(y_train ~ ., data=X_train, 
               method='svmLinear', metric = "ROC",
               trControl=control, verbose=T, 
               tuneLength=4)
save(svmLinear, file='../tags/model/svmLinear.RData')

### PREDICTIONS - Using all the data ###

# Remove objects that aren't used
rm(list = c('X_train', 'X_test')); gc()

# Load models
load(rf, file='../tags/model/rf.RData')
load(gbm, file='../tags/model/gbm.RData')
load(sparseLDA, file='../tags/model/sparseLDA.RData')
load(svmLinear, file='../tags/model/svmLinear.RData')

# convert X_all to a data.frame
X_all <- as.data.frame(as.matrix(X_all))
names(X_all) <- nm

# Predict X_all
pred_rf <- predict(rf, X_all, type='class')
pred_gbm <- predict(gbm, X_all, type='class')
pred_sparseLDA <- predict(sparseLDA, X_all, type='class')
pred_svmLinear <- predict(svmLinear, X_all, type='class')



