library('ISLR')
library('rpart')
library('rpart.plot')
library('tree')
library('randomForest')
data<- Carseats
train_idx=sample(1:nrow(data),300)
train=data[train_idx,]
test=data[-train_idx,]
tree_carseat=tree(Sales~.,train)
plot(tree_carseat)
text(tree_carseat,pretty=0)
pred_tree=predict(tree_carseat,test)
mse <- function(y,yhat) {
  return(mean((y-yhat)^2))
}
mse(pred_tree, test[,1]) 
cv_carseat=cv.tree(tree_carseat)
plot(cv_carseat$size,cv_carseat$dev,type='b')
bag_carseat=randomForest(Sales~.,train,mtry=10,importance=TRUE)
pred_bag=predict(bag_carseat,test)
plot(pred_bag,test[,1])
mse(pred_bag,test[,1])
importance(bag_carseat)
rf_carseat=randomForest(Sales~.,train,mtry=3,importance=TRUE)
pred_rf=predict(rf_carseat,test)
mse(pred_rf, test[,1])
MSE=matrix(0,nrow=1,ncol=10)
for (i in 1:10){
  rf_carseat=randomForest(Sales~.,train,mtry=i,importance=T)
  pred_rf=predict(rf_carseat,test)
  MSE[i]=mse(pred_rf, test[,1])
}
MSE
plot(1:10,MSE)
rf_carseat=randomForest(Sales~.,train,mtry=8,importance=TRUE)
importance(rf_carseat)