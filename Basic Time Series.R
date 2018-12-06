data("AirPassengers")
class(AirPassengers)
head(AirPassengers)

##Start/End of the Time-Series
start(AirPassengers)
end(AirPassengers)

##Frequency of the dataset is 12 months in a year
frequency(AirPassengers)
summary(AirPassengers)

?lm
?time
cycle(AirPassengers)
deltat(AirPassengers)

##Plotting the series
plot(AirPassengers)
?abline
abline(reg=lm(AirPassengers~time(AirPassengers)))
?aggregate
plot(aggregate(AirPassengers,FUN=mean))
plot(aggregate(AirPassengers,FUN=var))
aggregate(AirPassengers)

plot(AirPassengers~cycle(AirPassengers))
boxplot(AirPassengers~cycle(AirPassengers))

##Testing stationarity
?diff
head(AirPassengers)
head(diff(AirPassengers))
head(log(AirPassengers))
??adf.test

##install.packages("tseries")
library(tseries)
?adf.test
adf.test(diff(log(AirPassengers)),alternative = "s", k=0)
##since p<0.05, null rejected, series is staionary
##which means d=1, differencing is done once

acf(log(AirPassengers))
acf(diff(log(AirPassengers)))
##ACF Diff plot cuts off after the 1st lag. Hence p can be taken as 0
pacf(diff(log(AirPassengers)))

##Building ARIMA model
?arima
model<-arima(log(AirPassengers),c(0,1,1),seasonal = list(order=c(0,1,1),period=12))
summary(model)
AIC(model)
BIC(model)
predicted<-predict(model,n.ahead = 10*12)
summary(predicted)
?predict
?ts.plot
ts.plot(AirPassengers,2.718^predicted$pred,log="y",lty=c(1,3))
