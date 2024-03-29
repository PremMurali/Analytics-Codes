airline=read.csv(file.choose(),stringsAsFactors = FALSE)
library(tm)
library(SnowballC)
library(wordcloud)
negativesubset=subset(airline,airline_sentiment="negative")
negativecorpus=Corpus(VectorSource(negativesubset$text))
wordcloud(negativecorpus,colors=rainbow(7),max.words=50)
positivesubset=subset(airline,airline_sentiment="positive")
positivecorpus=Corpus(VectorSource(positivesubset$text))
wordcloud(positivecorpus,colors=rainbow(7),max.words=50)
corpus=Corpus(VectorSource(airline$text))
corpus=tm_map(corpus,tolower)
corpus=tm_map(corpus,removePunctuation)
corpus=tm_map(corpus,removeWords,c(stopwords("english")))
corpus=tm_map(corpus,stemDocument)
wordcloud(corpus,colors = rainbow(7),max.words=50)
frequencies=DocumentTermMatrix(corpus)
sparse=removeSparseTerms(frequencies,0.995)
tweetsSparse=as.data.frame(as.matrix(sparse))
colnames(tweetsSparse)=make.names(colnames(tweetsSparse))
tweetsSparse$senti=airline$airline_sentiment
library(rpart)
library(rpart.plot)
tweetCART=rpart(senti~.,data=tweetsSparse,method="class",cp=0.005)
tweetCART
prp(tweetCART,extra=2)
