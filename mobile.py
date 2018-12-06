# -*- coding: utf-8 -*-
"""
Created on Tue Oct 30 12:07:29 2018

@author: 660787
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

#Read the mobile data
mob_data = pd.read_csv(r'D:\Sriram\Pywork\Techgig\Mobile\train.csv')

#Check the datatypes of the dataset
mob_data.dtypes

#Check for null values in the dataset
mob_data.isnull().any()

mob_data.shape

##Find the correlation between variable values
mob_cor = mob_data.T.corr()

##Data Exploration
#value counts of each class in the target variable
mob_data.price_range.value_counts()

mob_data.touch_screen.value_counts()

#average values for each of the classes
avg = mob_data.groupby('price_range').mean()

fourg_avg = mob_data.groupby('four_g').mean()

touch_avg = mob_data.groupby('touch_screen').mean()

#Data Vaisualization
mob_data.hist(num_bins=10, size=(20,15))
plt.savefig('hist_mobile_allvar')
plt.show()

#No dummy variables need to be created as all class var are binary


x = mob_data.iloc[:,:20]
y= mob_data.iloc[:,20]

mob_data.price_range.unique()

##Feature Selection
#Recursive Feature Elimination
from sklearn.feature_selection import RFE
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier

model = RandomForestClassifier()
rfe = RFE(estimator=model, n_features_to_select=15)
rfe = rfe.fit(x,y)
rfe.estimator_

type(rfe.ranking_)
len(rfe.ranking_)
print(rfe.ranking_)
len(x.columns)

train_x = pd.DataFrame()
cols = x.columns
colst = list()
for index,r in enumerate(rfe.ranking_):
    if r == 1:
        colst.append(cols[index])

train_x = x[colst]
train_y = y


##Split the training and testing data
from sklearn.cross_validation import train_test_split
x_train, x_test, y_train, y_test = train_test_split(train_x, train_y, random_state=0, test_size=0.3)


#Build Random Forest model and train it
rf = RandomForestClassifier()
rf.fit(x_train, y_train)

y_pred = rf.predict(x_test)

#Measure the accuracy of random forest
from sklearn.metrics import accuracy_score
score = accuracy_score(y_pred, y_test)
print('Random Forest Accuracy: {:.3f}'.format(score))

##Building SVM and measuring accuracy
from sklearn.svm import SVC
svc = SVC()
svc.fit(x_train, y_train)
svc_score = accuracy_score(y_test, svc.predict(x_test))
print('Support Vector Machine score: {:.3f}'.format(svc_score))

##cross validation with Random Forest
from sklearn.model_selection import KFold
from sklearn. model_selection import cross_val_score
rf_cv = RandomForestClassifier()
kfold = KFold(n_splits=10, shuffle=True, random_state=7)
scoring = 'accuracy'
results = cross_val_score(rf_cv, x_train, y_train, cv=kfold, scoring=scoring)
print('Results of the Random Forest Cross Validation Score: {:.3f}'.format(results.mean()))

##print the classification report
from sklearn.metrics import classification_report
print(classification_report(y_test, y_pred))

print(rf.feature_importances_)

##visualizing the confusion matrix
import seaborn as sns
from sklearn.metrics import confusion_matrix
rf_cm = confusion_matrix(y_pred, y_test, [0,1])

sns.heatmap(rf_cm, annot=True, fmt='0.2f',
            xticklabels=['Left','Stayed'], yticklabels=['Left','Stayed'] )
plt.xlabel('Predicted Class')
plt.ylabel('True Class')
plt.show()




from sklearn.preprocessing import MinMaxScaler
minmax = MinMaxScaler()

y

from sklearn.preprocessing import OneHotEncoder 
onehot_direct=OneHotEncoder()


from sklearn.cross_validation import train_test_split
x_train, x_test, y_train, y_test = train_test_split(train_x, train_y, random_state=0, test_size=0.3)

x_train = minmax.fit_transform(x_train)

x_test = minmax.fit_transform(x_test)

y_train = onehot_direct.fit_transform(np.array(y_train).reshape(1400,1)).toarray()
y_test = onehot_direct.fit_transform(np.array(y_test).reshape(600,1)).toarray()




## Deep Learning
from keras.models import Sequential, Model
from keras.layers import Dense, Input

'''deep_inp = Input(shape=x_train.shape,name='input')
deep = Dense(100, activation='tanh')(deep_inp)
deep = Dense(100, activation='tanh')(deep)
deep_out = Dense(4, activation='softmax')(deep)

model = Model(inputs=deep_inp, outputs=deep_out)'''

model = Sequential()
model.add(Dense(units=100, activation='tanh',kernel_initializer='he_uniform'))
model.add(Dense(units=100, activation='tanh', kernel_initializer='he_uniform'))
model.add(Dense(units=4, activation='sigmoid'))


model.compile(optimizer='adam', loss='categorical_crossentropy',
              metrics=['accuracy'])
model.summary()


from sklearn.preprocessing import OneHotEncoder, 
onehot_direct=OneHotEncoder()
'''y_train_oh = np.array(y_train)
y_train_oh=y_train_oh.reshape(len(y_train_oh),1)
y_train_oh.shape
y_train_oh = onehot_direct.fit_transform(y_train_oh).values
y_train_oh
'''




sh = x_train.shape
x_train_d = np.array(x_train).reshape(1,1400,15)
x_train_d.shape
y_train_d = np.array(y_train)

model.fit(x=x_train, y=y_train, epochs=50, batch_size=32, verbose=1, validation_data = [x_test,y_test])





deep_inp = Input(shape=x_train.shape,name='input')
deep = Dense(100, activation='tanh')(deep_inp)
deep = Dense(100, activation='tanh')(deep)
deep_out = Dense(4, activation='softmax')(deep)

model = Model(inputs=deep_inp, outputs=deep_out)
help(model.fit)