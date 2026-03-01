library(MASS)
library(tidyverse)
library(ISLR2)
library(ggpmisc)

setwd("/Users/rob/Projects/R/ISLR2/Examples/Boston")

attach(Boston)
lm01 = lm(medv ~ lstat)

print(summary(lm01))

print(predict(lm01, data.frame(lstat = c(5, 10, 15)), interval = "confidence"))

print(predict(lm01, data.frame(lstat = c(5, 10, 15)), interval = "prediction"))

print(ggplot(data=Boston,
  mapping = aes(x=lstat, y=medv)) +
  geom_point(mapping=aes(lstat), col="red") + 
  geom_smooth(method="lm"))

lm02 = lm(medv ~ ., data=Boston)
print(summary(lm02))

print(summary.lm(lm02)$df)

lm03 = lm(medv ~ lstat + I(lstat^2), data=Boston)
print(summary(lm03))

lm04 = lm(medv ~ poly(lstat, 5))
print(summary(lm04))

pred <- data.frame(Pred_Values = predict(lm04),
                  Obs_Values = Boston$medv)

print(ggplot(pred,                                
  aes(x = Pred_Values, y = Obs_Values)) +
  geom_point() +
  geom_abline(intercept = 0, slope = 1,
              color = "cornflowerblue"))

