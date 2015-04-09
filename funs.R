bag_words <- function(character_vector){
  ### Create a document term matrix from a character vector
  character_vector <- gsub('<.*?>|[[:digit:]]+\t|\t[[:digit:]]+|\\?', ' ', character_vector)
  corpus = VCorpus(VectorSource(character_vector))
  corpus <- tm_map(corpus, stripWhitespace) # strip white space
  corpus <- tm_map(corpus, removeWords, stopwords("english")) # remove stop Words
  corpus <- tm_map(corpus, stemDocument) # stemming
  dtm <- DocumentTermMatrix(corpus, control = list(weighting = weightTfIdf))
}


as_sparseMatrix <- function(simple_triplet_matrix_sparse) {
  retval <-  sparseMatrix(i=as.numeric(simple_triplet_matrix_sparse$i),
                          j=as.numeric(simple_triplet_matrix_sparse$j),
                          x=as.numeric(as.character(simple_triplet_matrix_sparse$v)),
                          dims=c(simple_triplet_matrix_sparse$nrow, 
                                 simple_triplet_matrix_sparse$ncol),
                          dimnames = dimnames(simple_triplet_matrix_sparse),
                          giveCsparse = TRUE)
}
