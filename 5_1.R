km<-function(k,data,tol){
  data=scale(as.matrix(data))
  center_ini_idx<-sample(1:nrow(data),k)
  center_ini=data[center_ini_idx,]
  #non_center_ini=data[-center_ini_idx,]
  cluster_ini=sample(1:k,nrow(data),replace=T)
  S=matrix(0,nrow=k,ncol=ncol(data))
  for (i in 1:nrow(S)){
    label=which(cluster_ini==i,arr.ind=FALSE)
    S[i,]=colSums(data[label,])
  }
  Q_new=0
  Q_old=0
  center_cur=center_ini
  cluster_cur=cluster_ini
  for (i in 1:nrow(data)){
    product=center_cur%*%data[i,]
    max_prod=max(product)
    cluster_cur[i]=which(product==max_prod,arr.ind=FALSE)[1]
  }
  for (i in 1:nrow(S)){
    S[i,]=colSums(data[which(cluster_cur==i,arr.ind=FALSE),])
    Q_new=Q_new+norm(data.matrix(S[i,]),"f")
    center_cur[i,]=S[i,]/norm(data.matrix(S[i,]),"f")
  }
  iter=0
  while (Q_new-Q_old>tol){
    Q_old=Q_new
    Q_new=0
    iter=iter+1
    for (i in 1:nrow(data)){
      product=center_cur%*%data[i,]
      max_prod=max(product)
      cluster_cur[i]=which(product==max_prod,arr.ind=FALSE)[1]
    }
    for (i in 1:nrow(S)){
      S[i,]=colSums(data[which(cluster_cur==i,arr.ind=FALSE),])
      Q_new=Q_new+norm(data.matrix(S[i,]),"f")
      center_cur[i,]=S[i,]/norm(data.matrix(S[i,]),"f")
    }
    print(Q_new)
    print(Q_old)
  }
  return(cluster_cur)
}
data=iris[,-5]
cluster_ture=iris[,5]
cluster_iris=km(3,data,0.01)
confuse_matrix <- table(cluster_ture, cluster_iris)
confuse_matrix

