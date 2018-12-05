# Topic Modeling using Latent Dirchlet Allocation


Introduction:
=============
LDA is used to classify text in a document to a particular topic. It builds a topic per document model and words per topic model, modeled as Dirichlet distributions.

	.Each document is modeled as a multinomial distribution of topics and each topic is modeled as a multinomial distribution of words.

	.LDA assumes that the every chunk of text we feed into it will contain words that are somehow related. Therefore choosing the right corpus 	of data is crucial.
	.It also assumes documents are produced from a mixture of topics. Those topics then generate words based on their probability distribution.


Getting Started:
===============
1. git clone https://github.com/saroj-farhana/Programming-labs.git
2. switch to topic-modeling-exercise project folder and create conda environment(Note:you must already have anaconda installed)
3. Execute command "conda instal gensim"
4. Run the jupyter sever and open the project in jupyter notebook.