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


lambdas <- fit$lambda

pred_list <- lapply(lambdas, function(s){
	predictions = predict(fit, X_test, s=s, type='class')
	metrics(y_test, predictions)
})

pred_list <- pred_list[20:100]
lambdas <- lambdas[20:100]

l = lapply(pred_list, function(x){ 
	x[['summary']]
})

mean_f1 = sapply(l, function(x) mean(as.numeric(as.character(x[['f1_score']]))))
mean_precision = sapply(l, function(x) mean(as.numeric(as.character(x[['precision']]))))
mean_recall = sapply(l, function(x) mean(as.numeric(as.character(x[['recall']]))))

# Metrics plot
png(file='../tags/model/model_metrics.png', width = 500, height = 700, res=100)
par(mfrow=c(3,1))
plot(mean_f1, type='l', col='blue', main='F1 Score')
plot(mean_precision, type='l', col='red', main='Precision')
plot(mean_recall, type='l', col='green', main='Recall')
par(mfrow=c(1,1))
dev.off()

best_lambda <- lambdas[which.max(mean_f1)]
predictions = predict(fit, X_test, s=best_lambda, type='class')[,1]
