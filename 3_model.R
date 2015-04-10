source("2_preproc.R")

library(glmnet)

# Define a seed to split in training and testing sets
set.seed(123)
inx <- sample(nrow(d), round(nrow(d) * 0.8))

# Class vector
y = class$tag
y_train = y[inx]
y_test = y[-inx]

# Training and testing datasets
X_train <- X_all[inx, ]
X_test <- X_all[-inx, ]


### L1 regularized Logistic regression (lasso)
# http://statweb.stanford.edu/~tibs/lasso/lasso.pdf

fit <- cv.glmnet(x=X_train, y=y_train, family='multinomial', alpha=1, nfolds=3)
plot(fit)

save(fit, file='../tags/model/lasso.rdt')

### predictions on test data
predictions <- predict(fit, X_test, s=0.074600, type='class')

head(predictions)
