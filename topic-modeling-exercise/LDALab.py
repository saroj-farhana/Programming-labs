# -*- coding: utf-8 -*-
"""
Created on Wed Dec  5 12:30:22 2018

@author: saroj.farhana
"""

import gensim
from gensim.utils import simple_preprocess
from gensim.parsing.preprocessing import STOPWORDS
from nltk.stem import WordNetLemmatizer, SnowballStemmer
from nltk.stem.porter import *
import numpy as np
import pandas as pd
import nltk


#importing data
data=pd.read_csv("abcnews-date-text.csv",error_bad_lines=False)
data_text=data[:300000][['headline_text']];
data_text['index']=data_text.index

documents=data_text

print(len(documents))

print(documents[:5])

print(WordNetLemmatizer().lemmatize('went',pos='v'))

stemmer=SnowballStemmer("english")

original_words = ['caresses', 'flies', 'dies', 'mules', 'denied','died', 'agreed', 'owned', 
           'humbled', 'sized','meeting', 'stating', 'siezing', 'itemization','sensational', 
           'traditional', 'reference', 'colonizer','plotted']

singles=[stemmer.stem(plural) for plural in original_words]

pd.DataFrame(data={'original_word':original_words,'stemmed':singles})

print(pd)

# Write a function to perform the pre processing steps on the entire dataset

def lemmatize_stemming(text):
    return stemmer.stem(WordNetLemmatizer().lemmatize(text, pos='v'))

# Tokenize and lemmatize
def preprocess(text):
    result=[]
    for token in gensim.utils.simple_preprocess(text) :
        if token not in gensim.parsing.preprocessing.STOPWORDS and len(token) > 3:
            result.append(lemmatize_stemming(token))
            
    return result

'''
Preview a document after preprocessing
'''
document_num = 4310
doc_sample = documents[documents['index'] == document_num].values[0][0]

print("Original document: ")
words = []
for word in doc_sample.split(' '):
    words.append(word)
print(words)
print("\n\nTokenized and lemmatized document: ")
print(preprocess(doc_sample))

#processing the whole data

processed_docs=documents['headline_text'].map(preprocess)

print(processed_docs[:10])


