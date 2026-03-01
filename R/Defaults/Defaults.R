#loadISLR2Libraries()

setwd("~/Projects/R/ISLR2/Examples/Defaults")

cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
scale_colour_manual(values=cbPalette)

devnum = c()
for (def in Default$default) {
  devnum = append(devnum, if (def == "No") 0 else 1)
}

Default$ndefault = devnum

summary(Default)

lm01 = lm(ndefault ~ balance, data=Default)
print(summary(lm01))

glm01 = glm(ndefault ~ balance, data=Default, family=binomial)
print(summary(glm01))

f0 = ggplot(data=Default,
  mapping = aes(x=balance, y=income, color=default, shape=factor(default))) +
  geom_point(mapping=aes(balance), size=0.3) + 
  geom_smooth(method="lm")

#print(f0)

f1 = ggplot(data=Default, aes(y=balance, x=default, fill=default)) + 
  geom_boxplot()
f2 = ggplot(data=Default, aes(y=income, x=default, fill=default)) + 
  geom_boxplot()

grid.arrange(f0, f1, f2, ncol = 3)

f3 = ggplot(Default, aes(x=balance, y=ndefault)) +
  geom_point(size=0.75, col="orange") +
  geom_smooth(method = "lm", col="blue") +
  geom_hline(yintercept=0.0, linetype=3) +
  geom_hline(yintercept=1.0, linetype=3) +
  ggtitle("Linear regression line") +
  xlim(0, 2700) +
  ylab("default (No = 0, Yes = 1)") +
  scale_fill_hue(l=40)


f4 = ggplot(Default, aes(x=balance, y=ndefault)) +
  geom_point(size=0.75, col="orange") +
  geom_smooth(method = "glm", col="blue",
    method.args = list(family = "binomial"), 
    se = FALSE) + 
  geom_hline(yintercept=0.0, linetype=3) +
  geom_hline(yintercept=1.0, linetype=3) +
  ggtitle("Logistic regression line") +
  xlim(0, 2700) +
  ylab("default (No = 0, Yes = 1)") +
  scale_fill_hue(l=80)

grid.arrange(f3, f4, ncol = 2)

logitv = coef(glm01)[1] + coef(glm01)[2] * 2000
print(str_interp("Predicted logit for balance=2000: ${logitv}, and invlogit(logitv) = p(balance) = ${invlogit(logitv)}"))

predict(glm01)

