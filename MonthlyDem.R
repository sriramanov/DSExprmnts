setwd("D:/Sriram/Rwork/TS Problem")
data.dem<-read.csv("Monthly Demand.csv", header = TRUE)
data.dem
row.names(data.dem)<-c(1:12)
colnames(data.dem)<-c("Month","2013","2014","2015")
data.dem

##Conversion into a time series
##method1:
lst<-c(data.dem[,2],data.dem[,3],data.dem[,4])
class(lst)
length(lst)
lst
demts<-ts(lst,start=c(2013,1),end=c(2015,12),frequency = 12)
demts
##method2:
demc1<-data.dem[,2]
demc2<-data.dem[,3]
demc3<-data.dem[,4]
class(demc2)
cbind(demc1,demc2)
demc1ts<-ts(demc1,start=c(2013,1),frequency=12)
demc2ts<-ts(demc2,start=c(2014,1),frequency=12)
demc3ts<-ts(demc3,start=c(2015,1),frequency=12)
demts1=as.ts(c(demc1ts,demc2ts,demc3ts))
demts1
demts<-ts(demts,start=c(2013,1),frequency=12)
demts

##install.packages("zoo")
library(zoo)
?zoo

install.packages("forecast")
library(forecast)
?ma
##Detrending the time series
trenddem<-ma(demts,order=12,centre = T)
plot(trenddem)
plot(demts)
lines(trenddem)

detrenddem<-demts/trenddem
plot(detrenddem)
detrenddem

##Deseasonalize the time series
?colMeans
mdem<-t(matrix(data=detrenddem,nrow=12))
seasonaldem<-colMeans(mdem,na.rm = T)
seasonaldem
plot(as.ts(rep(seasonaldem,12)))
?rep
randomdem<-demts/(trenddem*seasonaldem)
randomdem
plot(as.ts(randomdem))

##Trend, Seasonal and Random noise separated
demdec<-decompose(demts,type="m")
demdec

plot(demdec$seasonal)
plot(demdec$trend)
plot(demdec$random)
plot(demdec)

##using STL method
demstl<-stl(demts,s.window = "periodic")
demstl
demstl$time.series
stlseasonaldem<-demstl$time.series[,1]
stltrenddem<-demstl$time.series[,2]
stlrandomdem<-demstl$time.series[,3]
par(mfrow=c(1,3))
plot(stlseasonaldem)
plot(stltrenddem)
plot(stlrandomdem)

##Visualize data
?aggregate
par(mfrow=c(1,1))
plot(aggregate(demts,FUN = mean))
boxplot(demts~cycle(demts))
randomdem

##Applying ACF and PACF
?acf
acf(randomdem, na.action=na.pass)
## order=1 for MA
pacf(randomdem, na.action = na.pass)
##order=0 for AR

##testing stationarity
install.packages("tseries")
library(tseries)
?adf.test
adf.test(demts,alternative="stationary",k=0)
##already the time series is staionary, d=0

##Applying acf and pacf for the main data
acf(demts) ##order = 3 for MA
pacf(demts) ##order = 1 for AR

##Building ARIMA model for the original data
arimamod1<-arima(demts,order=c(3,0,0))
arimamod1
arimamod2<-arima(demts,order=c(0,0,1))
arimamod2
arimamod3<-arima(demts,order=c(3,0,1))
arimamod3

BIC(arimamod1)
BIC(arimamod2)
BIC(arimamod3)
##model 1 has lowest value for both AIC and BIC. Hence it is selected

library(forecast)
forcastdem<-forecast(arimamod1,h=12)
forcastdem
demts

##install.packages("DMwR")
library(DMwR)
?ts.eval
