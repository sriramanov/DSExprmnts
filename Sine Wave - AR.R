angd<-1:360
seq(1, 9, by = 0.1)   
angd<-seq(1,360,0.4)
angv<-angd*pi/180
sinval<-sin(angv)
plot(sinval)
tssin<-ts(sinval,frequency = 4,start=c(2000,1))
tssin
acf(sinval)
pacf(sinval)

##Predict Sin wave
?ar
model<-ar(tssin,aic=TRUE,method = "ols")
predicted<-predict(model,n.ahead = 10*4)
summary(predicted)
ts.plot(tssin,predicted$pred)

##Viewing the plots side by side
par(mfrow=c(1,1))
modarima<-arima(tssin,c(2,0,0),seasonal = list(order=c(2,0,0),period=4))
predictArima<-predict(modarima,n.ahead = 10*4)
ts.plot(tssin,predictArima$pred)
