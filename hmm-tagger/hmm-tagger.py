# -*- coding: utf-8 -*-
"""
Created on Sun Nov 18 18:59:26 2018

@author: saroj.farhana
"""

import matplotlib.pyplot as plt
import numpy as np
from IPython.core.display import HTML
from itertools import chain
from collections import Counter, defaultdict,namedtuple
from helpers import show_model, Dataset
from pomegranate import State, HiddenMarkovModel, DiscreteDistribution 
import helpers as data_helper
import operator




FakeState = namedtuple("FakeState", "name")

data=Dataset("tags-universal.txt","brown-universal.txt",train_test_split=0.8)

print("There are {} sentences in the corpus.".format(len(data)))
print("There are {} sentences in the training set.".format(len(data.training_set)))
print("There are {} sentences in the testing set.".format(len(data.testing_set)))


key = 'b100-5507'
print("Sentence: {}".format(key))
print("words:\n\t{!s}".format(data.sentences[key].words))
print("tags:\n\t{!s}".format(data.sentences[key].tags))

print("There are a total of {} samples of {} unique words in the corpus."
      .format(data.N, len(data.vocab)))
print("There are {} samples of {} unique words in the training set."
      .format(data.training_set.N, len(data.training_set.vocab)))
print("There are {} samples of {} unique words in the testing set."
      .format(data.testing_set.N, len(data.testing_set.vocab)))
print("There are {} words in the test set that are missing in the training set."
      .format(len(data.testing_set.vocab - data.training_set.vocab)))

assert data.N == data.training_set.N + data.testing_set.N, \
       "The number of training + test samples should sum to the total number of samples"
       
# accessing words with Dataset.X and tags with Dataset.Y 
for i in range(2):    
    print("Sentence {}:".format(i + 1), data.X[i])
    print()
    print("Labels {}:".format(i + 1), data.Y[i])
    print()

print("\n Stream, (word.tag) pairs:\n")

for i,pair in enumerate(data.stream()):
    print("\t",pair)
    if i>5:break

print (data.X[1244])

def pair_counts(tags,words):
    data=Dataset("tags-universal.txt","brown-universal.txt",train_test_split=0.8)
    pair_counts={'NOUN':{},'PRON':{},'VERB':{},'ADJ':{},'DET':{},'ADP':{},'NUM':{},'CONJ':{},'PRT':{},'ADV':{},'.':{},'X':{}}
    #pair_counts={}
    for i,pairs in enumerate(data.stream()):
        if pairs[1] in pair_counts:
            
            if pairs[0] in pair_counts[pairs[1]]:
                #print("data:",pair_counts[pairs[1]][pairs[0]])
                pair_counts[pairs[1]][pairs[0]]=pair_counts[pairs[1]][pairs[0]]+1
            else:
                pair_counts[pairs[1]][pairs[0]]=1

        #if i>20:break
    #print("pairs count:",pair_counts)
   
    return pair_counts
    
emission_counts=pair_counts(data.training_set.Y,data.training_set.X)
print("Returned count:",len(emission_counts))

print ("time count:",emission_counts["."][","])

assert len(emission_counts) == 12, \
       "Uh oh. There should be 12 tags in your dictionary."
assert max(emission_counts["NOUN"], key=emission_counts["NOUN"].get) == 'time', \
       "Hmmm...'time' is expected to be the most common NOUN."
       
class MFCTagger:
    # NOTE: You should not need to modify this class or any of its methods
    missing = FakeState(name="<MISSING>")
    
    def __init__(self, table):
        self.table = defaultdict(lambda: MFCTagger.missing)
        self.table.update({word: FakeState(name=tag) for word, tag in table.items()})
        
    def viterbi(self, seq):
        """This method simplifies predictions by matching the Pomegranate viterbi() interface"""
        return 0., list(enumerate(["<start>"] + [self.table[w] for w in seq] + ["<end>"]))

mfc_table={}

training_words=data.training_set.vocab
for word in training_words:
    count_dict={}
    for key in emission_counts:
       if word in emission_counts[key]:
           count_dict[key]=emission_counts[key][word]
    mfc_table[word]= max(count_dict.items(), key=operator.itemgetter(1))[0]

# DO NOT MODIFY BELOW THIS LINE
mfc_model = MFCTagger(mfc_table) # Create a Most Frequent Class tagger instance

assert len(mfc_table) == len(data.training_set.vocab), ""
assert all(k in data.training_set.vocab for k in mfc_table.keys()), ""
assert sum(int(k not in mfc_table) for k in data.testing_set.vocab) == 5521, ""
HTML('<div class="alert alert-block alert-success">Your MFC tagger has all the correct words!</div>')

print("all done")

def replace_unknown(sequence):
    """Return a copy of the input sequence where each unknown word is replaced
    by the literal string value 'nan'. Pomegranate will ignore these values
    during computation.
    """
    return [w if w in data.training_set.vocab else 'nan' for w in sequence]

def simplify_decoding(X, model):
    """X should be a 1-D sequence of observations for the model to predict"""
    _, state_path = model.viterbi(replace_unknown(X))
    return [state[1].name for state in state_path[1:-1]]  # do not show the start/end state predictions

for key in data.testing_set.keys[:3]:
    print("Sentence Key: {}\n".format(key))
    print("Predicted labels:\n-----------------")
    print(simplify_decoding(data.sentences[key].words, mfc_model))
    print()
    print("Actual labels:\n--------------")
    print(data.sentences[key].tags)
    print("\n")

def accuracy(X, Y, model):
    """Calculate the prediction accuracy by using the model to decode each sequence
    in the input X and comparing the prediction with the true labels in Y.
    
    The X should be an array whose first dimension is the number of sentences to test,
    and each element of the array should be an iterable of the words in the sequence.
    The arrays X and Y should have the exact same shape.
    
    X = [("See", "Spot", "run"), ("Run", "Spot", "run", "fast"), ...]
    Y = [(), (), ...]
    """
    correct = total_predictions = 0
    for observations, actual_tags in zip(X, Y):
        
        # The model.viterbi call in simplify_decoding will return None if the HMM
        # raises an error (for example, if a test sentence contains a word that
        # is out of vocabulary for the training set). Any exception counts the
        # full sentence as an error (which makes this a conservative estimate).
        try:
            most_likely_tags = simplify_decoding(observations, model)
            correct += sum(p == t for p, t in zip(most_likely_tags, actual_tags))
        except:
            pass
        total_predictions += len(observations)
    return correct / total_predictions

mfc_training_acc = accuracy(data.training_set.X, data.training_set.Y, mfc_model)
print("training accuracy mfc_model: {:.2f}%".format(100 * mfc_training_acc))

mfc_testing_acc = accuracy(data.testing_set.X, data.testing_set.Y, mfc_model)
print("testing accuracy mfc_model: {:.2f}%".format(100 * mfc_testing_acc))

assert mfc_training_acc >= 0.955, "Uh oh. Your MFC accuracy on the training set doesn't look right."
assert mfc_testing_acc >= 0.925, "Uh oh. Your MFC accuracy on the testing set doesn't look right."
HTML('<div class="alert alert-block alert-success">Your MFC tagger accuracy looks correct!</div>')


def unigram_counts(sequences):
    tags_unigrams={}
    """Return a dictionary keyed to each unique value in the input sequence list that
    counts the number of occurrences of the value in the sequences list. The sequences
    collection should be a 2-dimensional array.
    
    For example, if the tag NOUN appears 275558 times over all the input sequences,
    then you should return a dictionary such that your_unigram_counts[NOUN] == 275558.
    """
    for i,pairs in enumerate(sequences.stream()):
        if pairs[1] in tags_unigrams:
          tags_unigrams[pairs[1]]= tags_unigrams[pairs[1]]+1
        else:
           tags_unigrams[pairs[1]]=1
    return tags_unigrams

# TODO: call unigram_counts with a list of tag sequences from the training set
tag_unigrams = unigram_counts(data.training_set)

for tag in tag_unigrams:
    print("{}:{}".format(tag,tag_unigrams[tag]))

assert set(tag_unigrams.keys()) == data.training_set.tagset, \
       "Uh oh. It looks like your tag counts doesn't include all the tags!"
assert max(tag_unigrams, key=tag_unigrams.get) == 'NOUN', \
       "Hmmm...'NOUN' is expected to be the most common class"
assert min(tag_unigrams, key=tag_unigrams.get) == 'X', \
       "Hmmm...'X' is expected to be the least common class"
HTML('<div class="alert alert-block alert-success">Your tag unigrams look good!</div>')


def bigram_counts(sequences):
    bigram_counts={}
    tags=[]
    """Return a dictionary keyed to each unique PAIR of values in the input sequences
    list that counts the number of occurrences of pair in the sequences list. The input
    should be a 2-dimensional array.
    
    For example, if the pair of tags (NOUN, VERB) appear 61582 times, then you should
    return a dictionary such that your_bigram_counts[(NOUN, VERB)] == 61582
    """
    for i,pairs in enumerate(sequences.stream()):
        tags.append(pairs[1])
        
    length = len(tags)
    for i in range(length-1):
        bigram = (tags[i], tags[i+1])
        if bigram not in bigram_counts:
            bigram_counts[bigram] = 1
        else:
            bigram_counts[bigram] += 1
    return  bigram_counts


# TODO: call bigram_counts with a list of tag sequences from the training set
tag_bigrams = bigram_counts(data.training_set)

#print(tag_bigrams)

assert len(tag_bigrams) == 144, \
       "Uh oh. There should be 144 pairs of bigrams (12 tags x 12 tags)"
assert min(tag_bigrams, key=tag_bigrams.get) in [('X', 'NUM'), ('PRON', 'X')], \
       "Hmmm...The least common bigram should be one of ('X', 'NUM') or ('PRON', 'X')."
assert max(tag_bigrams, key=tag_bigrams.get) in [('DET', 'NOUN')], \
       "Hmmm...('DET', 'NOUN') is expected to be the most common bigram."
HTML('<div class="alert alert-block alert-success">Your tag bigrams look good!</div>')


#starting count

def starting_counts(sequences):
    """Return a dictionary keyed to each unique value in the input sequences list
    that counts the number of occurrences where that value is at the beginning of
    a sequence.
    
    For example, if 8093 sequences start with NOUN, then you should return a
    dictionary such that your_starting_counts[NOUN] == 8093
    """
    starting_counts={}
    for tag in sequences:
        if tag[0] in starting_counts:
            starting_counts[tag[0]] +=1
        else:
            starting_counts[tag[0]]=1
    return starting_counts
        
# TODO: Calculate the count of each tag starting a sequence
tag_starts = starting_counts(data.training_set.Y)

assert len(tag_starts) == 12, "Uh oh. There should be 12 tags in your dictionary."
assert min(tag_starts, key=tag_starts.get) == 'X', "Hmmm...'X' is expected to be the least common starting bigram."
assert max(tag_starts, key=tag_starts.get) == 'DET', "Hmmm...'DET' is expected to be the most common starting bigram."
HTML('<div class="alert alert-block alert-success">Your starting tag counts look good!</div>')

def ending_counts(sequences):
    """Return a dictionary keyed to each unique value in the input sequences list
    that counts the number of occurrences where that value is at the end of
    a sequence.
    
    For example, if 18 sequences end with DET, then you should return a
    dictionary such that your_starting_counts[DET] == 18
    """
    ending_counts={}
    for tag in sequences:
        if tag[len(tag)-1] in ending_counts:
            ending_counts[tag[len(tag)-1]] +=1
        else:
            ending_counts[tag[len(tag)-1]]=1
    return ending_counts

# TODO: Calculate the count of each tag ending a sequence
tag_ends = ending_counts(data.training_set.Y)

assert len(tag_ends) == 12, "Uh oh. There should be 12 tags in your dictionary."
assert min(tag_ends, key=tag_ends.get) in ['X', 'CONJ'], "Hmmm...'X' or 'CONJ' should be the least common ending bigram."
assert max(tag_ends, key=tag_ends.get) == '.', "Hmmm...'.' is expected to be the most common ending bigram."
HTML('<div class="alert alert-block alert-success">Your ending tag counts look good!</div>')



basic_model = HiddenMarkovModel(name="base-hmm-tagger")

def keys_exists(element, *keys):
    '''
    Check if *keys (nested) exists in `element` (dict).
    '''
    if type(element) is not dict:
        raise AttributeError('keys_exists() expects dict as first argument.')
    if len(keys) == 0:
        raise AttributeError('keys_exists() expects at least two arguments, one given.')

    _element = element
    for key in keys:
        try:
            _element = _element[key]
        except KeyError:
            return False
    return True

emission_states=[]

for tag in data.training_set.tagset:
    #caluclating all possible emission probabilites for each unique word in training set using given tag
    tag_emission={}
    for word in data.training_set.vocab:
        #checking the tag and word key exists in pair count or not
        if keys_exists(emission_counts,tag,word):
            emission_prob=(emission_counts[tag][word])/(tag_unigrams[tag])
            #emission_prob=math.ceil(emission_prob*100)/100
            tag_emission[word]=emission_prob
    tag_emission=DiscreteDistribution(tag_emission)
    tag = State(tag_emission, name=tag)
    emission_states.append(tag)

#Adding all states to the model
    
basic_model.states=emission_states


for state in emission_states:
    #creating  start edge for each state
    tag_start_prob=tag_starts[state.name]/tag_unigrams[state.name]
    #tag_start_prob=math.ceil( tag_start_prob*100)/100
    basic_model.add_transition(basic_model.start,state,tag_start_prob)
    #creating possibke edge from this state all other states
    for state2 in emission_states:
        bigram = (state.name, state2.name)
        tag_transition_prob=tag_bigrams[bigram]/tag_unigrams[state.name]
        #tag_transition_prob=math.ceil( tag_transition_prob*100)/100
        basic_model.add_transition(state,state2,tag_transition_prob)
    #creating end edge for each state
    tag_end_prob=tag_ends[state.name]/tag_unigrams[state.name]
    #tag_end_prob=math.ceil( tag_end_prob*100)/100
    basic_model.add_transition(state,basic_model.end,tag_end_prob)


basic_model.bake()
    
print("Edges count:",basic_model.edge_count())

assert all(tag in set(s.name for s in basic_model.states) for tag in data.training_set.tagset), \
       "Every state in your network should use the name of the associated tag, which must be one of the training set tags."
assert basic_model.edge_count() == 168, \
       ("Your network should have an edge from the start node to each state, one edge between every " +
        "pair of tags (states), and an edge from each state to the end node.")
HTML('<div class="alert alert-block alert-success">Your HMM network topology looks good!</div>')

hmm_training_acc = accuracy(data.training_set.X, data.training_set.Y, basic_model)
print("training accuracy basic hmm model: {:.2f}%".format(100 * hmm_training_acc))

hmm_testing_acc = accuracy(data.testing_set.X, data.testing_set.Y, basic_model)
print("testing accuracy basic hmm model: {:.2f}%".format(100 * hmm_testing_acc))

assert hmm_training_acc > 0.97, "Uh oh. Your HMM accuracy on the training set doesn't look right."
assert hmm_testing_acc > 0.955, "Uh oh. Your HMM accuracy on the testing set doesn't look right."
HTML('<div class="alert alert-block alert-success">Your HMM tagger accuracy looks correct! Congratulations, you\'ve finished the project.</div>')

for key in data.testing_set.keys[:3]:
    print("Sentence Key: {}\n".format(key))
    print("Predicted labels:\n-----------------")
    print(simplify_decoding(data.sentences[key].words, basic_model))
    print()
    print("Actual labels:\n--------------")
    print(data.sentences[key].tags)
    print("\n")