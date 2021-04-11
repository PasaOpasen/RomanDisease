
library(ggplot2)

df=data_frame(procent=c(2.4,4.3,6.6),years=c(1982,1990,1995))

ggplot(df,aes(years,procent))+geom_point(size=4)+
  geom_smooth(method = "lm")+
  theme_bw()

summary(lm(sqrt(procent)~years,df))
