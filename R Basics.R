num<-as.integer(runif(20,1,10))
evn<-which(num %%2 ==0)
evn

x<-1:5
y<-c(2,4,6,8,10)
x*y


mrow<-c(2,4,6)
mcol<-c(8,0,9)
?matrix
c(mrow,mcol)
mat<-matrix(c(mrow, mcol), nrow=2, ncol=3, byrow = TRUE)
mat

s<-"15081947"
?as.Date
sdat<-as.Date(s, format="%d%m%Y")
sdat

?as.POSIXct
s1<-"15 Aug 1947"
s2<-"15 Aug 2017"
d1<-as.Date(s2,format="%d %b %Y")
d2<-as.POSIXct(s1,format="%d %b %Y")
as.POSIXct(d1)-d2

v<-c(100,101,98)
cond<-v>=100
ifelse(cond,"Hot","Good")

rd<-as.integer(runif(10,80,100))
rd
cond<-rd>90
ifelse(cond,"Best in class","Needs Improvement")

factN<-function(x){
  if(x==1) {
    return(1) }
  else { return( x * factN ( x - 1)) }
}

factN(6)

runs<-c(98,102,120,145,175,169,118,177,101,200)
runs %% 2==0
runs[which(runs %% 2==00)]

emp<-list("empno"=11, "name"="Alex", "Age"=32, "dept"="sales")
str(emp)

pyth<-function(x,y){
  return(sqrt(x^2+y^2))
}
pyth(2,3)

x <- 0:4 
as.logical(x)
