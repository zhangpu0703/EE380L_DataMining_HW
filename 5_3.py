from sklearn import svm
from sklearn.linear_model import LinearRegression 
import csv
import numpy as np
from sklearn.metrics import roc_curve, auc
import pylab as pl
train=np.genfromtxt("data.train.csv",dtype=None,delimiter=',')
test=np.genfromtxt("data.test.csv",dtype=None,delimiter=',')
train=train[1:-1,:]
test=test[1:-1,:]
train=train.astype(np.float)
test=test.astype(np.float)

clf=svm.SVR()
clf=clf.fit(train[:,1:5],train[:,0])
predict=clf.predict(test[:,1:5])
predict_train=clf.predict(train[:,1:5])
test_sse=0
train_sse=0
for i in range(len(predict)):
	test_sse=test_sse+(predict[i]-test[i,0])**2
test_rmse=(test_sse/len(predict))**0.5


for i in range(len(predict_train)):
	train_sse=train_sse+(predict_train[i]-train[i,0])**2
train_rmse=(train_sse/len(predict_train))**0.5

print "The RMSE for training data by SVR is:", train_rmse
print "The RMSE for testing data by SVR is:", test_rmse

clf_lr=LinearRegression()



clf_lr.fit(train[:,1:5],train[:,0])

lr_test=clf_lr.predict(test[:,1:5])
lr_train=clf_lr.predict(train[:,1:5])
test_sse=0
train_sse=0
for i in range(len(lr_test)):
	test_sse=test_sse+(lr_test[i]-test[i,0])**2
test_rmse=(test_sse/len(lr_test))**0.5

for i in range(len(lr_train)):
	train_sse=train_sse+(lr_train[i]-train[i,0])**2
train_rmse=(train_sse/len(lr_train))**0.5

print "The RMSE for training data by LR is:", train_rmse
print "The RMSE for testing data by LR is:", test_rmse

