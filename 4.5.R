iris=data.frame(iris)
km_a <- kmeans(iris[,1:4], 4)
plot(iris[,1], iris[,2], col=km_a$cluster)
points(km_a$centers[,c(1,2)], col=1:3, pch=8, cex=2)
t1<-table(km_a$cluster, iris$Species)
total<-nrow(iris)
c1<-km_a$size
mc1<-apply(t1,1,max)
tp_a<-sum((c1/total)*(mc1/c1))
tp_a

new_iris=iris
for (j in 1:ncol(iris[,1:4])){
  for (i in 1:nrow(iris)){
    new_iris[i,j]=(iris[i,j]-min(iris[j]))/(max(iris[j])-min(iris[j]))
  }
}
km <- kmeans(new_iris[,1:4], 4)
plot(new_iris[,1], new_iris[,2], col=km$cluster)
points(km$centers[,c(1,2)], col=1:3, pch=8, cex=2)
t2<-table(km$cluster, new_iris$Species)
c2<-km$size
mc2<-apply(t2,1,max)
tp_b<-sum((c2/total)*(mc2/c2))
tp_b

nor_iris=iris
nor_iris[,1:4]<-scale(iris[,1:4])
km <- kmeans(nor_iris[,1:4], 4)
plot(nor_iris[,1], nor_iris[,2], col=km$cluster)
points(km$centers[,c(1,2)], col=1:3, pch=8, cex=2)
t3<-table(km$cluster, new_iris$Species)
c3<-km$size
mc3<-apply(t3,1,max)
tp_c<-sum((c3/total)*(mc3/c3))
tp_c

distance <- dist(iris[,-5], method="euclidean")
cluster <- hclust(distance, method="complete")
plot(cluster, hang=-1, label=iris$Species)