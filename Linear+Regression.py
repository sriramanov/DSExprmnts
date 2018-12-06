
# coding: utf-8

# In[21]:

import statsmodels.api as sm
from sklearn import datasets
data = datasets.load_boston()
print(data.DESCR)
print(data.feature_names)
print(data.target)

get_ipython().magic('config IPCompleter.greedy=True')


# In[25]:

import numpy as np
import pandas as pd
print(data.feature_names)
print(data.target)
df = pd.DataFrame(data.data, columns=data.feature_names)
target = pd.DataFrame(data.target, columns=["MEDV"])


# In[38]:

import statsmodels.api as sm
x = df["RM"]
y = target["MEDV"]

model = sm.OLS(y,x).fit()
predicted = model.predict(x)
model.summary()


# In[39]:

x = df["RM"]
y = target["MEDV"]
x = sm.add_constant(x)
model = sm.OLS(y,x).fit()
predicted = model.predict(x)
model.summary()


# In[41]:

x = df[["RM","LSTAT"]]
y = target["MEDV"]
x = sm.add_constant(x)
model = sm.OLS(y,x).fit()
predicted = model.predict(x)
model.summary()


# In[42]:



