?ts
set.seed(18)
on<-runif(15,100,500)
on
?sample
tsd<-ts(on,frequency=4,start=c(2000,3))
require(stats)
?RNGkind

data()
head(EuStockMarkets)
tsdata<-EuStockMarkets[,1]
tsdata

##decompose the time series into trend, seasonal and error
?decompose
decompRes<-decompose(tsdata,type = "additive")
decompRes


?stl
stlRes<-stl(tsdata,s.window = "periodic")
stlRes
plot(stlRes)

##create lag in the time series
?lag
ladts<-lag(tsdata,3)
ladts

##create lag and lead in the time series
install.packages("DataCombine")
library(DataCombine)
?slide

tsd
tsdf<-as.data.frame(tsd)
tsdf<-slide(tsdf,"x",NewVar = "Xlag1",slideBy = -1)
tsdf<-slide(tsdf,"x",NewVar = "Xlead1",slideBy = 1)
head(tsdf)
