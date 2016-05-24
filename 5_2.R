library('rpart')
#install.packages("monmlp", repos = "http://cran.us.r-project.org")
library('monmlp')
library('caret')
train=read.csv("C:/Users/Zhang/Desktop/2014Fall/Data Mining/HW5/pendigits.tra.csv")
test=read.csv("C:/Users/Zhang/Desktop/2014Fall/Data Mining/HW5/pendigits.tes.csv")
trainx<-as.matrix(train[,-17])
trainy<-as.matrix(train[,17])
testx<-as.matrix(test[,-17])
testy<-as.matrix(test[,17])
mlp<-function(x,y,hidden_nodes,max_epochs){
  mod<-monmlp.fit(x=x,y=y,hidden_nodes,0,iter.max=max_epochs,Th=logistic,To=linear)
  #pre<-monmlp.predict(testx,mlp)
  return (mod)
}
set.seed(19910505)
accuracy=matrix(0,nrow=1,ncol=9)
para=matrix(c(5,500,5,1000,5,2000,10,100,10,1000,10,2000,15,100,15,1000,15,2000))
for (idx in 1:9){
  mod=mlp(trainx,trainy,para[2*idx-1],para[2*idx])
  pre<-monmlp.predict(testx,mod)
  pre<-round(pre)
  correct=0
  for (i in 1:nrow(pre)){
    if (pre[i]==testy[i]){
      correct=correct+1
    }
  }
  accuracy[idx]=correct/nrow(pre)
} 
accuracy
confuse_matrix <- table(pre, testy)
confuse_matrix

