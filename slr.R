head(cars)

##1.ScatterPlot to find the linear relationship between values
gscar = ggplot(cars, aes(x=dist, y=speed))+geom_point()
print(gscar)
scatter.smooth(x=cars$dist, y=cars$speed, main="Speed vs Distance", xlab="Distance", ylab="Speed")
?scatter.smooth
##2.Box_Plot to find any outliers if present
par(mfrow=c(1,2)) ##Divide the graph area into 2
boxplot(cars$speed)
boxplot(cars$dist)
##boxplot.stats gives necessary data point within a boxplot construct
boxplot.stats(cars$speed)$out
boxplot.stats(cars$dist)$out
boxplot(cars$speed, main="Speed", sub=paste("Outlier Rows: ",boxplot.stats(cars$speed)$out))
boxplot(cars$dist, main="Distance", sub=paste("Outlier Rows: ", boxplot.stats(cars$dist)$out))
##3.draw Density graph to check on normal distribution
##install.packages("e1071")
library(e1071)
par(mfrow=c(1,2))
plot(density(cars$speed), main="Speed", sub=paste("Skewness: ",round(e1071::skewness(cars$speed),2)))
polygon(density(cars$speed), col = "red")
plot(density(cars$dist), main="Distance", sub=paste("Skewness: ",round(e1071::skewness(cars$dist),2)))
polygon(density(cars$dist), col="blue")
##4.find correlation
cor(cars$speed, cars$dist)
##5.build the linear regression
lmreg<-lm(dist~speed,data=cars)
lmreg
##6.diagnostics of this linear regression
summary(lmreg)

AIC(lmreg)
BIC(lmreg)

##Create Training and test data set
set.seed(18)
?set.seed
trainRowIndex<-sample(nrow(cars),size = 0.8*nrow(cars))
trainRowIndex
class(trainRowIndex)
trainSet<-cars[trainRowIndex,]
testSet<-cars[-trainRowIndex,]
?sample
0.8*nrow(cars)

lmTrainMod<-lm(dist~speed,data=trainSet)
class(lmTrainMod)
prdTest<-predict(lmTrainMod,testSet)
prdTest ##Predict the distance of all the test speeds
summary(lmTrainMod)
AIC(lmTrainMod)

actualPred <- data.frame(cbind(actuals=testSet$dist, predicteds=prdTest))
actualPred
cor(actualPred)
?cor
?apply
apply(actualPred,2,min)
apply(actualPred,1,max)
##min_max_accuracy=Mean((min(actuals,predicts)/ma(actual,predicts)))
minMaxAcc<-mean(apply(actualPred,1,min)/apply(actualPred,1,max))
minMaxAcc
##MAPE=mean((abs(atucals-predicts)/actuals))
mape<-mean(abs(actualPred$actuals-actualPred$predicteds)/actualPred$actuals)
mape

##install.packages("DAAG")
library(DAAG)
?CVlm
?suppressWarnings
cvRes<-CVlm(data=cars,form.lm=dist~speed, seed=18, m=5,dots=TRUE)
attr(cvRes,"ms")
