
# coding: utf-8

# In[36]:

tweet='We have some delightful code in the system. Wow!!!'
tweet
print(tweet)


# In[59]:

good_words=['wow','great','better','awesome']
good_words
good_words.append('delightful')
good_words.append('like')
good_words
bad_words=['lame','silly','bad','poor']
bad_words
emotional_words=good_words+bad_words
emotional_words


# In[15]:

words=tweet.split(' ')
words


# In[34]:

len(words)
len(tweet)
print(tweet.lower())
tweet.lower()


# In[24]:

for wrd in words:
    print(wrd)


# In[27]:

for wrd in words:
    if wrd in good_words:
        print(wrd)


# In[46]:

tweet.lower()
tweet.replace('!','')
qn=tweet.replace('!','').lower().replace('.','')
qn
words=qn.split(' ')
print(words)


# In[47]:

for wrd in words:
    if wrd.lower() in good_words:
        print(wrd)


# In[48]:

from string import punctuation
print(punctuation)


# In[77]:

sample='I, a student, need more awesome practice.. Also with atmost delightful attention!!!!!'
print(sample)
swords=sample.split(' ')
print(swords)
for p in punctuation:
    if p in sample:
        print(p+' is present in the word')
        sample=sample.replace(p,'')
swords=sample.split(' ')
print(swords)
positive_counter=0
negative_counter=0
for wrs in swords:
    if wrs.lower() in good_words:
        print('Good Word: '+wrs+' is present in the sentence')
        positive_counter=positive_counter+1
    elif wrs.lower() in bad_words:
        print('Bad Word: '+wrs+' is present in the sentence')
        negative_counter=negative_counter+1
percent_positive=positive_counter/len(swords)
percent_negative=negative_counter/len(swords)
print ('positive %f and negative is %f' % (percent_positive, percent_negative))


# In[62]:

i=0
i=i+1
print(i)

