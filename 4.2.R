install.packages("glmnet", repos = "http://cran.us.r-project.org")
install.packages("ROCR", repos = "http://cran.us.r-project.org")
#install.packages("caret", repos = "http://cran.us.r-project.org")
data<-read.table("https://archive.ics.uci.edu/ml/machine-learning-databases/ionosphere/ionosphere.data",sep=',');

library("glmnet")
library('MASS')
library('ggplot2')
library('ROCR')
#library("caret")
data$V2<-NULL
#target<-data$V35
#data$V35<- NULL
data<-scale(data)

smp_size <- floor(0.7 * nrow(data))

set.seed(123)
train_ind <- sample(seq_len(nrow(data)), size = smp_size)

train <- data[train_ind, ]
test <- data[-train_ind, ]

x<-as.matrix(train[,-34])
y<-train[,34]
test_x<-as.matrix(test[,-34])
test_y<-test[,34]

fit<-cv.glmnet(x,y,family="binomial",alpha=0,nfolds=10)
plot(fit)
print(fit)
fit$lambda.min

train_pred<-predict(fit,x,s="lambda.min")
train_error<-mean((train_pred>0.5&y==1)|(train_pred<0.5&y==2))
test_pred<-predict(fit,test_x,s="lambda.min")
test_error<-mean((test_pred>0.5&test_y==1)|(test_pred<0.5&test_y==2))
test_var<-prediction(test_pred,test_y)
model_perf<-performance(test_var,"tpr","fpr")
plot(model_perf,colorize=T)
tpr<-unlist(model_perf@x.values)
fpr<-unlist(model_perf@y.values)
roc<-cbind(tpr,fpr)
ggplot(data=data.frame(roc),aes(x=tpr,y=fpr))+theme_bw()+
  geom_line(aes(x=tpr,y=fpr),color="green")+
  geom_abline(slope=1,intercept=0,color='red')+
  labs(title="ROC Chart",
       x="Sensitivity",
       y="1-Specificity")

lift<-performance(test_var,"lift","rpp")
plot(lift)

coef(fit,s="lambda.min")