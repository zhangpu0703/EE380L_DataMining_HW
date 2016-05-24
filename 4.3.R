library('rpart')
library('rpart.plot')
train=read.csv("C:/Users/Zhang/Desktop/2014Fall/Data Mining/HW4/data.train.csv")
test=read.csv("C:/Users/Zhang/Desktop/2014Fall/Data Mining/HW4/data.test.csv")
fit<- rpart(train$mpg ~ .,data=train,method="anova",control=rpart.control(cp=0.0001),xval = 5)
printcp(fit) # display the results 
plotcp(fit) # visualize cross-validation results 
#summary(fit) # detailed summary of splits

# plot tree 
plot(fit, uniform=TRUE, 
     main="Regression Tree for Cars")
text(fit, use.n=TRUE, all=TRUE, cex=.8)

# prune the tree

pfit<- prune(fit, cp=0.0117)
printcp(pfit)

# plot the pruned tree 
plot(pfit, uniform=TRUE, 
     main="Pruned Regression Tree for Cars")
text(pfit, use.n=TRUE, all=TRUE, cex=.8)

prp(pfit)
pred <- predict(pfit, newdata=train)
mse <- function(y,yhat) {
  return(mean((y-yhat)^2, na.rm=T))
}
mse(pred, train$mpg) 

pred_test<- predict(pfit, newdata=test)
mse(pred_test, test$mpg) 
plot(pred_test,test$mpg)

rt<-rpart(train$mpg~.,data=train,method="poisson",control=rpart.control(cp=0.0001,xval=5))
printcp(rt,digits=getOption("digits")-2)
rt1<-prune(rt,cp=0.0117)
printcp(rt1,digits=getOption("digits")-2)
prp(rt1,type=2,extra=1)
trainy.pred<-predict(rt1,train)
mse1<-mean((train$mpg-trainy.pred)^2)
testy.pred<-predict(rt1,test)
mse2<-mean((test$mpg-testy.pred)^2)
plot(testy.pred,test$mpg)