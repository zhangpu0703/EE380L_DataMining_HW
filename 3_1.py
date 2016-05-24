import csv
import numpy as np
from sklearn import linear_model
import matplotlib.pyplot as plt
from math import *
clf = linear_model.Lasso(alpha=0.1)
	

data=np.genfromtxt("autos.csv",dtype=None,delimiter=',',names=True)
print data
fold=np.genfromtxt("auto.folds.csv",dtype=None,delimiter=',')

train=np.zeros([262,7])
test=np.zeros([130,7])
false=data[0][7]
print false
temp_1=0
temp_2=0
for i in range(392):
	y=data[i]
	if y[7]==false:
		for j in range(7):
			test[temp_1][j]=y[j]
		temp_1=temp_1+1
	else:
		for j in range(7):
			train[temp_2][j]=y[j]
		temp_2=temp_2+1


I_1=[]
I_2=[]
I_3=[]
I_4=[]
I_5=[]

for i in range(np.shape(train)[0]):
	if fold[i]==0:
		I_1.append(i)
	elif fold[i]==1:
		I_2.append(i)
	elif fold[i]==2:
		I_3.append(i)
	elif fold[i]==3:
		I_4.append(i)
	else:
		I_5.append(i)

group_1=train[I_1,]
group_2=train[I_2,]
group_3=train[I_3,]
group_4=train[I_4,]
group_5=train[I_5,]


group_train_1=train[np.concatenate((I_2,I_3,I_4,I_5)),]
group_train_2=train[np.concatenate((I_1,I_3,I_4,I_5)),]
group_train_3=train[np.concatenate((I_1,I_2,I_4,I_5)),]
group_train_4=train[np.concatenate((I_1,I_2,I_3,I_5)),]
group_train_5=train[np.concatenate((I_1,I_2,I_3,I_4)),]

Group=[group_1,group_2,group_3,group_4,group_5]
Group_train=[group_train_1,group_train_2,group_train_3,group_train_4,group_train_5]


def get_best_Lasso(Group,Group_train,rate):
	r_best=0
	coef=[]
	R2=[]
	for i in range(5):
		group_valid=Group[i]
		group_train=Group_train[i]
		clf = linear_model.Lasso(alpha=rate,normalize=True)
		clf.fit(group_train[:,1:7], group_train[:,0])
		#linear_model.Lasso(alpha=0.1, copy_X=True, fit_intercept=True, max_iter=1000,
		#normalize=False, positive=False, precompute='auto', tol=0.0001,
		#warm_start=False)
		rsquare=clf.score(group_valid[:,1:7],group_valid[:,0])
		R2.append(rsquare)
		coef.append(clf.coef_)
		#if rsquare>=r_best:
			#r_best=rsquare
			#best_coef=clf.coef_
			#best_intercept=clf.intercept_
			#clf_best=clf
	final_coef=np.average(coef,axis=0,weights=R2/sum(R2))
	clf.coef_=final_coef

	return clf
	    
c_lasso=[0.0001,0.0005,0.001,0.005,0.01,0.05,0.1]
log_lasso=[]
R=[]
coef_1=[];
coef_2=[];
coef_3=[];
coef_4=[];
coef_5=[];
coef_6=[];
for rate in c_lasso: 
	clf_best=get_best_Lasso(Group,Group_train,rate)
	rsquare=clf_best.score(test[:,1:7],test[:,0])
	R.append(rsquare)
	#print rsquare
	coef_1.append(clf_best.coef_[0])
	coef_2.append(clf_best.coef_[1])
	coef_3.append(clf_best.coef_[2])
	coef_4.append(clf_best.coef_[3])
	coef_5.append(clf_best.coef_[4])
	coef_6.append(clf_best.coef_[5])
	log_lasso.append(log(rate))
best_index=R.index(max(R))
best_para=c_lasso[best_index]

print 'The best Lambda for Lasso is', best_para
plt.figure(1)
plt.plot(c_lasso,coef_1,'ro-',c_lasso,coef_2,'bo-',c_lasso,coef_3,'yo-',c_lasso,coef_4,'go-',c_lasso,coef_5,'mo-',c_lasso,coef_6,'ko-')
plt.legend('ABCDEF')

plt.show()

def get_best_Ridge(Group,Group_train,rate):
	r_best=0
	R2=[]
	coef=[]
	for i in range(5):
		group_valid=Group[i]
		group_train=Group_train[i]
		clf = linear_model.Ridge(alpha=rate,normalize=True)
		clf.fit(group_train[:,1:7], group_train[:,0])
		#linear_model.Ridge(alpha=0.1, copy_X=True, fit_intercept=True, max_iter=1000,
		#normalize=False, solver='auto',tol=0.001)
		rsquare=clf.score(group_valid[:,1:7],group_valid[:,0])
		R2.append(rsquare)
		coef.append(clf.coef_)
		#if rsquare>=r_best:
			#r_best=rsquare
			#best_coef=clf.coef_
			#best_intercept=clf.intercept_
			#clf_best=clf
	final_coef=np.average(coef,axis=0,weights=R2/sum(R2))
	clf.coef_=final_coef
	return clf
	    
c_ridge=[0.001,0.005,0.01,0.05,0.1,0.5,1,5,10,50,100]
log_ridge=[]
R=[]
coef_1=[];
coef_2=[];
coef_3=[];
coef_4=[];
coef_5=[];
coef_6=[];
for rate in c_ridge: 
	clf_best=get_best_Ridge(Group,Group_train,rate)
	rsquare=clf_best.score(test[:,1:7],test[:,0])
	R.append(rsquare)
	coef_1.append(clf_best.coef_[0])
	coef_2.append(clf_best.coef_[1])
	coef_3.append(clf_best.coef_[2])
	coef_4.append(clf_best.coef_[3])
	coef_5.append(clf_best.coef_[4])
	coef_6.append(clf_best.coef_[5])
	log_ridge.append(log(rate))
best_index=R.index(max(R))
best_para=c_ridge[best_index]

print 'The best Lambda for Ridge is', best_para

plt.figure(2)
plt.plot(c_ridge,coef_1,'ro-',c_ridge,coef_2,'bo-',c_ridge,coef_3,'yo-',c_ridge,coef_4,'go-',c_ridge,coef_5,'mo-',c_ridge,coef_6,'ko-')
plt.legend('ABCDEF')
plt.show()
	
clf_lr=linear_model.LinearRegression(normalize=True)
clf_lr.fit(train[:,1:7],train[:,0])
rsquare_LR=clf_lr.score(test[:,1:7],test[:,0])

clf_lasso=linear_model.Lasso(alpha=0.01,normalize=True)
clf_lasso.fit(train[:,1:7],train[:,0])
rsquare_Lasso=clf_lasso.score(test[:,1:7],test[:,0])

clf_ridge=linear_model.Ridge(alpha=0.1,normalize=True)
clf_ridge.fit(train[:,1:7],train[:,0])
rsquare_Ridge=clf_ridge.score(test[:,1:7],test[:,0])

print 'The R square for LR is', rsquare_LR, 'The R square for Lasso is' , rsquare_Lasso,'The R square for Ridge is', rsquare_Ridge
print 'The coefficient for Lasso is', clf_lasso.coef_

clf_lr_new=linear_model.LinearRegression(normalize=True)
clf_lr_new.fit(train[:,[1,3,4,6]],train[:,0])
rsquare_LR_new=clf_lr_new.score(test[:,[1,3,4,6]],test[:,0])

print 'The new LR rsquare is', rsquare_LR_new

