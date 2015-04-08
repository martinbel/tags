source("2_preproc.R")

library(glmnet)
fit <- glmnet(X_train, y=class[inx], family='multinomial', alpha=0)

plot(fit)

predictions <- predict(fit, X_test, s=0.074600, type='class')


head(predictions)


medias = apply(X_train, 2, mean)
