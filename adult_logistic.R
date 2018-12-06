setwd("D:/Sriram/Rwork/Logistic")
input.data<-read.csv("adult.csv",header=TRUE)
head(input.data)
table(input.data$ABOVE50K)

##Seprating into train and test data
inputones<-input.data[which(input.data$ABOVE50K==1),]
inputzeros<-input.data[which(input.data$ABOVE50K==0),]
which(inputzeros$ABOVE50K==0)
oneindex<-sample(nrow(inputones),0.7*nrow(inputones))
zeroindex<-sample(nrow(inputzeros),0.7*nrow(inputzeros))
nrow(inputzeros)
head(zeroindex)
class(oneindex)
trainones<-inputones[oneindex,]
trainzeros<-inputzeros[zeroindex,]
testones<-inputones[-oneindex,]
testzeros<-inputzeros[-zeroindex,]
head(testones)
trainzeros[which(trainzeros$ABOVE50K==1),]
train.data<-rbind(trainones,trainzeros)
test.data<-rbind(testones,testzeros)
nrow(train.data)+nrow(test.data)

##Separate categorical/continuous variable
install.packages("riv")
install.packages("woe")
library(riv)
library(woe)
?woe
class(colnames(input.data))
class(input.data)
?sapply
catcon<-(sapply(input.data,is.factor))
class(catcon)
onlycat<-input.data[which(sapply(input.data,is.factor))]
head(onlycat)
colcat<-colnames(onlycat)
colcat
catcon
onlycon<-input.data[which(sapply(input.data,is.numeric))]
head(onlycon)
colcon<-colnames(onlycon)
colcon
ncol(input.data)
ncol(onlycon)+ncol(onlycat)

##calculate WOE  & IV
install.packages("smbinning")
library(smbinning)
colcon<-colcon[1:length(colcon)-1]
length(colcon)-1
colcon
ivdf<-data.frame(vars=c(colcat,colcon),IV=numeric(14))
ivdf
for(cat in colcat){
  smb<-smbinning.factor(train.data,x=cat,y="ABOVE50K")
  if(class(smb!="character")){
    ivdf[ivdf$vars==cat,"IV"]<-smb$iv
  }
}

for(con in colcon){
  smb<-smbinning(train.data,y="ABOVE$50K",x=con)
  if(class(smb)!="character"){
    ivdf[ivdf$vars==con,"IV"]<-smb$iv
  }
}

##WOETAble
?WOETable
WOETable(X=train.data$OCCUPATION,Y=train.data$ABOVE50K,valueOfGood = 1)

##Building the logistic reg model
logreg<-glm(ABOVE50K~RELATIONSHIP+OCCUPATION+EDUCATIONNUM+ AGE + CAPITALGAIN,data = train.data
            ,family = binomial(link = "logit"))
predictedscores<-plogis(predict(logreg,test.data))
## plogis is used to restrict the scores within 0 and 1
##it can also be written as
?predict
predictedscores<-predict(logreg,test.data,type="response")
head(predictedscores)
##finding optimal probability cut-off
##in our example our probability cut off is 0.5 = half ones and half zeroes
install.packages("InformationValue")
library(InformationValue)
?optimalCutoff
optcutoff<-optimalCutoff(test.data$ABOVE50K,predictedScores = predictedscores,returnDiagnostics = TRUE)[1]
optcutoff
length(predictedscores)

##find the summary of the log regression
summary(logreg)

##find the correlation of the variables within the regression
install.packages("VIF")
library(VIF)
vif(logreg)
?vif

##Miclassification Error
misClassError(test.data$ABOVE50K,predictedscores,threshold = optcutoff)

##ROC= finds the true positives found out by the model
plotROC(test.data$ABOVE50K,predictedscores)

##concordance = %of pairs whose scors of actual +ves is > actual -ves
Concordance(test.data$ABOVE50K,predictedscores)

##sensitivity (True Positive Rate) = no of actual 1s correctly predicted by the model
sensitivity(test.data$ABOVE50K,predictedscores,threshold = optcutoff)

## specificity (1-False Positive Rate)=no of actual 0s correctly predicted by the model
specificity(test.data$ABOVE50K,predictedscores,threshold = optcutoff)

##confusion matrix of the prediction
confusionMatrix(test.data$ABOVE50K,predictedscores,threshold = optcutoff)
