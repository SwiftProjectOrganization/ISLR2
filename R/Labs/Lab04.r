setwd("~/Projects/R/ISLR2")

source("InstallAndLoadScripts/loadlibraries.R")

loadISLR2Libraries()

names(Smarket)

dim(Smarket)

options(repr.plot.width = 15, repr.plot.height = 12)
pairs(Smarket[c("Direction", "Lag1", "Lag2", "Lag3", "Lag4", "Lag5")])

cor(Smarket[, -9])

attach(Smarket)

plot(Volume)

glm01 = glm(Direction ~ Lag1 + Lag2 + Lag3 + Lag4 + Lag5 + Volume, data=Smarket, family = binomial)

summary(glm01)

glm.probs = predict(glm01, type="response")

print(glm.probs[1:10])

contrasts(Direction)

glm.pred = rep("Down", 1250)

glm.pred[glm.probs > .5] = "Up"

table(glm.pred, Direction)

mean(glm.pred == Direction)

train = (Year < 2005)

Smarket.2005 = Smarket[!train,]

dim(Smarket.2005)

Direction.2005 = Direction[!train]

glm02 = glm(Direction ~ Lag1 + Lag2 + Lag3 + Lag4 + Lag5 + Volume, 
            data = Smarket, family = binomial, subset = train)

summary(glm02)

glm02.probs = predict(glm02, Smarket.2005, type="response")

glm02.pred = rep("Down", 252)

glm02.pred[glm02.probs > .5] = "Up"

table(glm02.pred, Direction.2005)

mean(glm02.pred == Direction.2005)

glm03 = glm(Direction ~ Lag1 + Lag2, data=Smarket, family=binomial,subset=train)

summary(glm03)

glm03.probs = predict(glm03, Smarket.2005, type="response")

glm03.pred = rep("Down", 252)

glm03.pred[glm03.probs > .5] = "Up"

table(glm03.pred, Direction.2005)

mean(glm03.pred == Direction.2005)

lda01.fit = lda(Direction ~ Lag1 + Lag2, data=Smarket, subset=train)

lda01.fit

plot(lda01.fit)

library(class)

train.X = cbind(Lag1, Lag2)[train,]

test.X = cbind(Lag1, Lag2)[!train,]

train.Direction = Direction[train]

set.seed(1)

knn01.pred = knn(train.X, test.X, train.Direction, k=1)

table(knn01.pred, Direction.2005)

knn03.pred = knn(train.X, test.X, train.Direction, k=3)
table(knn03.pred, Direction.2005)


