##install.packages("arules")
library(arules)
data("Groceries")
class(Groceries)
inspect(head(Groceries,3))
?inspect
size(head(Groceries))
LIST(head(Groceries))
?eclat
?inspect

##Most frequenct items through the Eclat algorithm
frequent<-eclat(Groceries, parameter = list(supp=0.05, maxlen=15))
inspect(frequent)

##Individual Frequency values and PLot
indvl_freq<-itemFrequency(Groceries)
indvl_freq

itemFrequencyPlot(Groceries, topN=10, type="absolute", main="Item Frequency")

##Product Recommendation Rules
arules<-apriori(Groceries, parameter = list(supp=0.001, conf=0.5))
arules_conf<-sort(arules, by="confidence", decreasing=TRUE)
inspect(head(arules_conf))

arules_lift<-sort(arules, by="lift", decreasing = TRUE)
inspect(head(arules_lift))

##To get strong rules increase the confidence
##To get longer rules increase the maxlen
arules_mxln<-apriori(Groceries, parameter = list(supp=0.001,conf=0.8, maxlen=3))
inspect(arules_mxln)

##Get rid of redundant rules
?is.subset
redundant<-which(colSums(is.subset(arules,arules))>1)
length(redundant)
arules<-arules[-redundant]
length(arules)

##what customers had purchased before whole_milk
arules_wmilk<-apriori(Groceries, parameter = list(supp=0.001, conf=0.8, maxlen=3),
                      appearance=list(default="lhs", rhs="whole milk"), control=list(verbose=T))
arules_wmilk_sort<-sort(arules_wmilk, by="confidence", descending=TRUE)
inspect(arules_wmilk_sort)

##Customers who bought whole milk also had bought..
arules_with_wmilk<-apriori(Groceries, parameter=list(supp=0.001, conf=0.15, minlen=2), 
                           appearance = list(default="rhs", lhs="whole milk"), control = list(verbose=T))

arules_swith_wmilk<-sort(arules_with_wmilk, by="confidence", descending=TRUE)
inspect(arules_swith_wmilk)


inspect(head(Groceries))
dim(Groceries)
