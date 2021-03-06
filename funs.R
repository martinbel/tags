
### Unigram bag_words
bag_words <- function(character_vector){
  ### Create a document term matrix from a character vector
  # removes all tags such as <p>, <code> 
  character_vector <- gsub('<.*?>|[[:digit:]]+\t|\t[[:digit:]]+|\\?', ' ', character_vector)
  corpus = VCorpus(VectorSource(character_vector))
  corpus <- tm_map(corpus, stripWhitespace) # strip white space
  corpus <- tm_map(corpus, removeWords, stopwords("english")) # remove stop Words
  corpus <- tm_map(corpus, stemDocument) # stemming
  dtm <- DocumentTermMatrix(corpus, control = list(weighting = weightTfIdf))
}

### Bigram bag_words
BigramTokenizer <- function(x) {
    RWeka::NGramTokenizer(x, RWeka::Weka_control(min = 2, max = 2))
}

bag_words_bigram <- function(character_vector){
  ### Create a document term matrix from a character vector
  character_vector <- gsub('<.*?>|[[:digit:]]+\t|\t[[:digit:]]+|\\?', ' ', character_vector)
  corpus = VCorpus(VectorSource(character_vector))
  corpus <- tm_map(corpus, stripWhitespace) # strip white space
  corpus <- tm_map(corpus, removeWords, stopwords("english")) # remove stop Words
  corpus <- tm_map(corpus, stemDocument) # stemming
  dtm <- DocumentTermMatrix(corpus, 
    control = list(weighting = weightTfIdf, tokenize=BigramTokenizer))
}

# helper function
as_sparseMatrix <- function(simple_triplet_matrix_sparse) {
  retval <-  sparseMatrix(i=as.numeric(simple_triplet_matrix_sparse$i),
                          j=as.numeric(simple_triplet_matrix_sparse$j),
                          x=as.numeric(as.character(simple_triplet_matrix_sparse$v)),
                          dims=c(simple_triplet_matrix_sparse$nrow, 
                                 simple_triplet_matrix_sparse$ncol),
                          dimnames = dimnames(simple_triplet_matrix_sparse),
                          giveCsparse = TRUE)
}


# Metrics functions
accuracy <- function(y_test, predictions){
  tbl <- table(y_test, predictions)
  accuracy <- sum(diag(tbl)) / sum(tbl)
  list(tbl=tbl, accuracy=accuracy)
}


metrics <- function(y_test, predictions){
  tbl <- table(y_test, predictions)
  precision <- NULL
  recall <- NULL
  f1_score <- NULL

  if(sum(dim(tbl)) == 40){
      precision <- sapply(1:20, function(i){
        tbl[i,i] / sum(tbl[,i])
      })

      recall <- sapply(1:20, function(i){
        tbl[i,i] / sum(tbl[i,])
      })

      f1_score <- 2 * (precision * recall) / (precision + recall)

  }
  summary = data.frame(cbind(rownames(tbl), precision, recall, f1_score))
  list(tbl=tbl, summary=summary)
}

