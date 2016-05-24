library('gbm')
library('ISLR')
library('plyr')
library('caret')
data('Caravan')

data<-Caravan
train<-data[1:1000,]
train$Purchase <- as.factor(mapvalues(train$Purchase, c("No", "Yes"), c("0","1")))
train$Purchase <- as.character(train$Purchase)
test<-data[1001:nrow(data),]
test$Purchase <- as.factor(mapvalues(test$Purchase, c("No", "Yes"), c("0","1")))
test$Purchase <- as.character(test$Purchase)
test<-as.data.frame(test)
boost.caravan<-gbm(Purchase~.,data=train,distribution='bernoulli',n.trees=1000,shrinkage=0.01)
summary(boost.caravan)
pred<-predict(boost.caravan,newdata=test,distribution='bernoulli',n.trees=1000,type="response")
p<-list(1:4822)
for (i in 1:4822){
  if (pred[i]>0.2){
    p[i]<-c(1)}
  else {
    p[i]<-c(0)
  }
}
target<-as.integer(test$Purchase)
p<-as.integer(p)
table(target,p)