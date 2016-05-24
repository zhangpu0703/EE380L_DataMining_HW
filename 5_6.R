data=load("C:/Users/Zhang/Desktop/2014Fall/Data Mining/HW5/imbalanced.RData")
library('ROCR')
library('glmnet')
library("caret")
library('plyr')
set.seed(10)
for (i in 1:15){
  trdat[,i]=as.numeric(trdat[,i])
}
for (i in 1:15){
  tedat[,i]=as.numeric(tedat[,i])
}
trdat=as.matrix(trdat)
tedat=as.matrix(tedat)
fit<-cv.glmnet(trdat[,1:14],trdat[,15],family="binomial")
test_pred<-predict(fit,tedat[,1:14],type="response", s="lambda.min")
roc.pred <- prediction(test_pred[,1], tedat[,15])
roc.perf <- performance(roc.pred,"tpr","fpr")
roc.df <- data.frame(x=attr(roc.perf , "x.values")[[1]], 
                     y=attr(roc.perf , "y.values")[[1]])

# Get area under ROC curve
auroc_ori <- attr(performance(roc.pred, "auc"), "y.values")[[1]]
auroc_ori
y=as.factor(trdat[,15])
train_up=upSample(trdat[,1:14],y)
train_down=downSample(trdat[,1:14],y)
fit_up<-cv.glmnet(as.matrix(train_up[,1:14]),as.matrix(train_up[,15]),family="binomial")
test_pred<-predict(fit_up,tedat[,1:14],type="response", s="lambda.min")
roc.pred <- prediction(test_pred[,1], tedat[,15])
roc.perf <- performance(roc.pred,"tpr","fpr")
roc.df <- data.frame(x=attr(roc.perf , "x.values")[[1]], 
                     y=attr(roc.perf , "y.values")[[1]])

# Get area under ROC curve
auroc_up <- attr(performance(roc.pred, "auc"), "y.values")[[1]]
auroc_up

fit_down<-cv.glmnet(as.matrix(train_down[,1:14]),as.matrix(train_down[,15]),family="binomial")
test_pred<-predict(fit_down,tedat[,1:14],type="response", s="lambda.min")
roc.pred <- prediction(test_pred[,1], tedat[,15])
roc.perf <- performance(roc.pred,"tpr","fpr")
roc.df <- data.frame(x=attr(roc.perf , "x.values")[[1]], 
                     y=attr(roc.perf , "y.values")[[1]])
tpr<-unlist(roc.perf@x.values)
fpr<-unlist(roc.perf@y.values)
roc<-cbind(tpr,fpr)
ggplot(data=data.frame(roc),aes(x=tpr,y=fpr))+theme_bw()+
  geom_line(aes(x=tpr,y=fpr),color="red")+
  geom_abline(slope=1,intercept=0,color='blue')+
  labs(title="ROC Curve",
       x="False Positive Rate",
       y="True Positive Rate")

# Get area under ROC curve
auroc_down <- attr(performance(roc.pred, "auc"), "y.values")[[1]]
auroc_down

library("kernlab")
svm_1<-ksvm(trdat[,1:14],as.factor(trdat[,15]),kernel='vanilladot')
test_class<- predict(svm_1,tedat[,1:14],type="r")
test_class<- as.numeric(test_class)
test_class<-as.matrix(test_class)-matrix(1,nrow(as.matrix(test_class)),ncol(as.matrix(test_class)))
roc.pred <- prediction(test_class, tedat[,15])
roc.perf <- performance(roc.pred,"tpr","fpr")
roc.df <- data.frame(x=attr(roc.perf , "x.values")[[1]], 
                     y=attr(roc.perf , "y.values")[[1]])
tpr<-unlist(roc.perf@x.values)
fpr<-unlist(roc.perf@y.values)
roc<-cbind(tpr,fpr)
ggplot(data=data.frame(roc),aes(x=tpr,y=fpr))+theme_bw()+
  geom_line(aes(x=tpr,y=fpr),color="red")+
  geom_abline(slope=1,intercept=0,color='blue')+
  labs(title="ROC Curve",
       x="False Positive Rate",
       y="True Positive Rate")

# Get area under ROC curve
auroc_svm1 <- attr(performance(roc.pred, "auc"), "y.values")[[1]]

svm_2<-ksvm(trdat[,1:14],as.factor(trdat[,15]),kernel='vanilladot',class.weights=c('1'=1, '2'=2))
test_class_2<- predict(svm_2,tedat[,1:14],type="r")
test_class_2<- as.numeric(test_class_2)
test_class_2<-as.matrix(test_class_2)-matrix(1,nrow(as.matrix(test_class_2)),ncol(as.matrix(test_class_2)))
roc.pred <- prediction(test_class_2, tedat[,15])
roc.perf <- performance(roc.pred,"tpr","fpr")
roc.df <- data.frame(x=attr(roc.perf , "x.values")[[1]], 
                     y=attr(roc.perf , "y.values")[[1]])
tpr<-unlist(roc.perf@x.values)
fpr<-unlist(roc.perf@y.values)
roc<-cbind(tpr,fpr)
ggplot(data=data.frame(roc),aes(x=tpr,y=fpr))+theme_bw()+
  geom_line(aes(x=tpr,y=fpr),color="red")+
  geom_abline(slope=1,intercept=0,color='blue')+
  labs(title="ROC Curve",
       x="False Positive Rate",
       y="True Positive Rate")

# Get area under ROC curve
auroc_svm2 <- attr(performance(roc.pred, "auc"), "y.values")[[1]]
auroc_svm2
