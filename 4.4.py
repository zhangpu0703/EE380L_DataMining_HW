from sklearn import svm
import csv
import numpy as np
from sklearn import preprocessing
from time import clock as now
#data=csv.reader(open('spam.csv'))
data=np.genfromtxt("spam.csv",dtype=None,delimiter=',')
train=np.zeros([3065,58])
test=np.zeros([1536,58])
false=data[1][58]
print false
temp_1=0
temp_2=0
for i in range(4601):
	y=data[i]
	if y[58]==false:
		for j in range(58):
			train[temp_1][j]=y[j]
		temp_1=temp_1+1
	else:
		for j in range(58):
			test[temp_2][j]=y[j]
		temp_2=temp_2+1
#print train

origin_train=train
origin_test=test
train[:,0:57]=(train[:,0:57] - train[:,0:57].mean(axis=0)) / train[:,0:57].std(axis=0)
test[:,0:57]=(test[:,0:57] - test[:,0:57].mean(axis=0)) / test[:,0:57].std(axis=0)
# find best parameter with linear SVM
def find_best_linear(train,test):
	best_r=0
	for pen in [0.1,1,2,5,10]:
		clf=svm.SVC(C=pen,kernel='linear')
		clf=clf.fit(train[:,0:57],train[:,57])
		predict=clf.predict(test[:,0:57])
		score=clf.score(test[:,0:57],test[:,57])
		if best_r<score:
			best_clf=clf
			best_r=score
			best_para=pen
	return best_clf,best_r,best_para
start=now()
best_clf,best_r,best_para=find_best_linear(train,test)
finish=now()
print "The best penalty term for Linear SVM is:",best_para
print "The best score for Linear SVM is:",best_r
print "Time for Computing is:", finish-start

# find best with "RBF" kernel
def find_best_rbf(train,test):
	best_r=0
	for pen in [0.1,1,2,5,10]:
		for para in [2e-12,2e-10,2e-8,2e-6,2e-5]:
			clf=svm.SVC(C=pen,kernel='rbf',gamma=para)
			clf=clf.fit(train[:,0:57],train[:,57])
			predict=clf.predict(test[:,0:57])
			score=0.0
			for i in range(np.shape(test)[0]):
				if ((predict[i]==0)&(test[i,57]==0)) or ((predict[i]==1)&(test[i,57]==1)):
					score=score+1.0

			score=score/np.shape(test)[0]
			#print score
			if best_r<score:
				best_clf=clf
				best_r=score
				best_pen=pen
				best_gamma=para
	return best_gamma,best_pen,best_r,best_clf

best_gamma,best_pen,best_r,best_clf=find_best_rbf(train,test)
print "The best penalty term for RBF SVM is:",best_pen
print "The best score for RBF SVM is:",best_r
print "The best Gamma for RBF SVM is:",best_gamma

count=0
for i in range(np.shape(origin_train)[0]):
	if origin_train[i,57]==0:
		count+=1

train_oneclass=np.zeros([count,np.shape(origin_train)[1]])
temp_3=0
for i in range(np.shape(origin_train)[0]):
	if origin_train[i,57]==0:
		train_oneclass[temp_3,]=origin_train[i,]
		temp_3+=1
		
train_oneclass[:,0:57]=(train_oneclass[:,0:57] - train_oneclass[:,0:57].min(axis=0)) / train_oneclass[:,0:57].std(axis=0)

def oneclass_best_rbf(train_oneclass,test):
	best_r=0
	best_gamma=0
	for para in [2e-12,2e-10,2e-8,2e-6,2e-5]:
		clf_oneclass=svm.OneClassSVM(kernel='rbf',gamma=para)
		clf_oneclass=clf_oneclass.fit(train_oneclass[:,0:57])
		predict=clf_oneclass.predict(test[:,0:57])
		score=0.0

		for i in range(np.shape(test)[0]):
			if ((predict[i]==1)&(test[i,57]==0)) or ((predict[i]==-1)&(test[i,57]==1)):
				score=score+1.0

		score=score/np.shape(test)[0]
		#print score

		if best_r<score:
			best_clf=clf_oneclass
			best_r=score
			best_gamma=para
	return best_gamma,best_r,best_clf

best_gamma,best_r,best_clf=oneclass_best_rbf(train_oneclass,test)
print "The best gamma for RBF oneclassSVM is:",best_gamma
print "The best score for RBF oneclassSVM is:",best_r










