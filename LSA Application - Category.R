##install.packages("openxlsx")
##Works for handling large datasets in xlsx format
library(openxlsx)
setwd("D:/Sriram/Rwork/Category")
data.hck<-read.xlsx("eCom_Coded_Data_Vitamins.xlsx", sheet=1,colNames = TRUE)
head(data.hck)

##Data division = 10% of 30000 records taken
data.train<-data.hck[1:200,]
##data.test<-data.hck[2001:2050,]
##View(data.train)
##levels(as.factor(data.train$`#US.LOC.BRAND`))
levels(as.factor(data.train$`#US.LOC.FORM`))
##Choosing US.LOC.FORM as the dependent variable
colnames(data.train)
trainset<-cbind(as.data.frame(data.train[,5]),as.data.frame(data.train[,9]))
colnames(trainset)<-c('DESC','FORM')
head(trainset)
apply(is.na(trainset),2,sum)

##testset<-cbind(as.data.frame(data.test[,5]),as.data.frame(data.test[,9]))
##colnames(testset)<-c('DESC','FORM')
##apply(is.na(testset),2,sum)

##Checking the Bias
library(ggplot2)
proportion<-prop.table(table(trainset$FORM))
class(proportion)
dim(proportion)
plot(proportion)
##View(proportion)
prop.df<-as.data.frame(proportion)
prop.df
##Removing entris having proportion of <0.003
valid.forms<-prop.df[which(prop.df$Freq>0.0003),]
valid.forms
valid.forms$Var1
valid.ind<-which(trainset$FORM %in% valid.forms$Var1)
train.data<-trainset[valid.ind,]
dim(train.data)

##Remove NAs
##View(train.data)
colSums(is.na(train.data))
apply(is.na(train.data),2,sum)
sapply(train.data, function(x) sum(is.na(x)))
length(which(!complete.cases(train.data)))
train.data<-na.omit(train.data)

##Checking the stats on the Text_Len
head(train.data)
levels(train.data$FORM)
train.data$TextLen<-nchar(as.character(train.data$DESC))
head(train.data$TextLen)
summary(train.data$TextLen)
plot(density(train.data$TextLen))


##Qunatitative analysis of Textual Data
library(quanteda)
train.tokens.char<-tokens(as.character(train.data$DESC), what="word", remove_numbers=FALSE,
                          remove_hyphens=TRUE, remove_punct=TRUE, remove_symbols=TRUE)
head(train.tokens.char)
##Not removing stopwords by removing stemming
train.tokens.char<-tokens_wordstem(train.tokens.char, language = 'english')

##Applying ngrams with n<=3
train.tokens.char<-tokens_ngrams(train.tokens.char, n=1:3)

##creating document frequency matrix
train.tokens.dfm<-dfm(train.tokens.char, tolower=FALSE)
class(train.tokens.dfm)
##View(train.tokens.dfm)
train.tokens.matrix<-as.matrix(train.tokens.dfm)
train.tokens.df<-cbind(train.data$FORM,as.data.frame(train.tokens.dfm))
names(train.tokens.df)<-make.names(names(train.tokens.df), unique = TRUE)

##calculating TF and IDF
term.freq<-function(row){
  row/sum(row)
}

inverse.doc.freq<-function(col){
  corpus.size<-length(col)
  doc.size<-length(which(col>0))
  log10(corpus.size/doc.size)
}

tf.idf<-function(tf,idf){
  tf*idf
}


##Normalize all the values with TF
train.df.norm.tf<-apply(train.tokens.matrix,1,term.freq)
dim(train.df.norm.tf)
##View(train.df.norm.tf)
##caluculate IDF values
train.df.norm.idf<-apply(train.tokens.matrix,2,inverse.doc.freq)
str(train.df.norm.idf)
##View(train.df.norm.idf)
##calculate tf-idf
train.df.tf.idf<-apply(train.df.norm.tf,2,tf.idf,train.df.norm.idf)
##View(train.df.tf.idf)
dim(train.df.tf.idf)
##transpose the matric to regain the original dimension
train.df.tf.idf<-t(train.df.tf.idf)
dim(train.df.tf.idf)

##Check for complete cases
incomplete.cases<-which(!complete.cases(train.df.tf.idf))
incomplete.cases
train.desc<-as.data.frame(train.data$DESC)
dim(train.desc)
train.desc[incomplete.cases]

##install.packages("irlba")
library(irlba)
##Latest Semantic Analysis - Singular Vector Decomposition
library(doSNOW)
gc()
start.time<-Sys.time()
cl<-makeCluster(3,type='SOCK')
registerDoSNOW(cl)
train.irlba<-irlba(t(train.df.tf.idf), nv=80, maxit = 150)
##maxit = maximum iterations to find the nv number of higher level concepts
stopCluster(cl)
Sys.time()-start.time


##calculate document.hat=sigma.invers * u.transpose * document for the 1st term
sigma.inverse<-1/train.irlba$d
##class(sigma.inverse)
u.transpose<-t(train.irlba$u)
##class(u.transpose)
document<-train.df.tf.idf[1,]
document.hat<-sigma.inverse * u.transpose %*% document
##document.hat and irlba$v are almost similar so we can use irlba$v directly

##creating the new data frame after SVD
##create the data frame
train.tfidf.final<-cbind(FORM=train.data$FORM,data.frame(train.irlba$v))
dim(as.data.frame(train.data$FORM))
dim(train.irlba$v)
##View(train.tfidf.final)
##train.tfidf.final[is.na(train.tfidf.final)]<-0

##Control paramters
library(caret)
set.seed(18)
cv.folds<-createMultiFolds(train.tfidf.final$FORM,k=4,times=2)
cv.control<-trainControl(method='repeatedcv', number = 4, repeats = 2, 
                         index = cv.folds, allowParallel = TRUE)

##Removing unwanted dataframes
##rm(data.hck)
rm(train.df.norm.tf,train.df.norm.idf)
rm(train.tokens.df,train.tokens.matrix)
rm(train.data)
rm(train.tokens.char)
rm(train.tokens.dfm)
rm(data.train)

##apply(is.na(train.tfidf.final),2,sum)

dim(train.tfidf.final)
train.tfidf.final[train.tfidf.final=='']<-0
train.tfidf.final<-na.omit(train.tfidf.final)
train.tfidf.final.matrix<-as.matrix(train.tfidf.final[,-1])
train.tfidf.final.matrix[is.na(train.tfidf.final.matrix)]<-0.0
mode(train.tfidf.final.matrix)<-"numeric"
dim(train.tfidf.final.matrix)
train.form<-train.tfidf.final$FORM
train.form
train.tfidf.final.matrix[train.tfidf.final.matrix=='']<-0.0
train.final<-as.data.frame(cbind(FORM=as.character(train.form),train.tfidf.final.matrix))
dim(train.final)
head(train.final)

##Bulding the model
library(doSNOW)
start.time<-Sys.time()
cl<-makeCluster(3,type='SOCK')
registerDoSNOW(cl)
rf.v2<-train(x=train.final,y=train.final$FORM,
                method='rf',trControl = cv.control, tuneLength = 5)
stopCluster(cl)
Sys.time()-start.time

dim(train.tfidf.final)

##Model measures
rf.v2
rf.v2$finalModel$predicted
confusionMatrix(train.tfidf.final$FORM, rf.v2$finalModel$predicted)
