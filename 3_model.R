source("2_preproc.R")

library(glmnet)

y_train = y[inx]
y_test = y[-inx]

fit <- cv.glmnet(x=X_train, y=y_train, family='multinomial', alpha=1, nfolds=3)
plot(fit)

### predictions on test data
predictions <- predict(fit, X_test, s=0.074600, type='class')

head(predictions)
