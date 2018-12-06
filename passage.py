# -*- coding: utf-8 -*-
"""
Created on Thu Oct 25 18:47:23 2018

@author: 660787
"""

from nltk.corpus import brown

print(brown.categories)

hum=list(brown.sents(categories='humor'))
len(hum)
len([a for a in hum])

def gather(category):
    txt = list(brown.sents(categories=category))
    factor=10
    txt_list = list()
    txt_dict = dict()
    
    for i in range(0,len(txt)//factor):
        txt_list.append(txt[i*factor:i*factor+factor])
    
    for i in range(0,len(txt_list)):
        txt_list[i]=[' '.join(b for b in a) for a in txt_list[i]]
    
    for i in range(0, len(txt_list)):
        txt_dict[txt_list[i]]=category
    return txt_dict

txt_dict = gather('humor')
type(txt_dict)


txt = list(brown.sents(categories='humor'))
factor=10
txt_list = list()
txt_dict = dict()

for i in range(0,len(txt)//factor):
    txt_list.append(txt[i*factor:i*factor+factor])

for i in range(0,len(txt_list)):
    txt_list[i]=[' '.join(b for b in a) for a in txt_list[i]]

for i in range(0, len(txt_list)):
    txt_dict[txt_list[i]]='humor'