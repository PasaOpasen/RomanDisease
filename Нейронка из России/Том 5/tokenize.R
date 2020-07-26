

library(keras)
library(stringr)


path = file.path(getwd(),'Data', 'combined.txt')


text <- tolower(readChar(path, file.info(path)$size))
cat("Corpus length:", nchar(text), "\n")



maxlen <- 50  # Length of extracted character sequences
step <- 5  # We sample a new sequence every `step` characters

text_indexes <- seq(1, nchar(text) - maxlen, by = step)
# This holds our extracted sequences
sentences <- str_sub(text, text_indexes, text_indexes + maxlen - 1)
# This holds the targets (the follow-up characters)
next_chars <- str_sub(text, text_indexes + maxlen, text_indexes + maxlen)
cat("Number of sequences: ", length(sentences), "\n")





# List of unique characters in the corpus
chars <- unique(sort(strsplit(text, "")[[1]]))
cat("Unique characters:", length(chars), "\n")



char_indices <- 1:length(chars) 
names(char_indices) <- chars
# Next, one-hot encode the characters into binary arrays.
cat("Vectorization...\n") 


x <- array(0L, dim = c(length(sentences), maxlen, length(chars)))
y <- array(0L, dim = c(length(sentences), length(chars)))
for (i in 1:length(sentences)) {
  sentence <- strsplit(sentences[[i]], "")[[1]]
  for (t in 1:length(sentence)) {
    char <- sentence[[t]]
    x[i, t, char_indices[[char]]] <- 1
  }
  next_char <- next_chars[[i]]
  y[i, char_indices[[next_char]]] <- 1
}


save(x, y, chars, char_indices, sentences, next_chars, maxlen, file = 'arrays 50 5.rdata')






















