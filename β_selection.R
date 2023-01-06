library(lme4)
library(Matrix)
library(lmerTest)

data = readr::read_csv("D:/paper/advising strategy/NI/strategyswitching.csv")
EX1_MIXMODLE <- readr::read_csv("D:/paper/advising strategy/NI/strategyswitching.csv")

EX1_MIXMODLE $ Selection = factor(EX1_MIXMODLE $Selection)
# here, selection is the accept/reject behavior from the previous trial
# accept = 1; reject = -1
fit <-lmer(data = EX1_MIXMODLE, Advice_deviance ~ Selection+(1+Selection|Sub))
summary(fit)#AdviceDeviance(t)=Intercept+¦Âselection*Selection(t-1) 
