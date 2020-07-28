
library(keras)
library(stringr)

text_path = 'Texts'

file_name = 'text.txt'

path = file.path(getwd(),text_path, file_name)

text <- tolower(paste0(readr::read_lines(path),'\n', collapse = ''))


count =  nchar(text)
cat("Text length:",count, "\n")

maxlen = 60
if(count >= maxlen){
  sentence = text[(count-maxlen):count]
}else{
  how = maxlen-count
  sentence = paste0(paste0(rep('',how+1), collapse = ' '), text)
}


load('arrays.rdata')
cat('data is loaded\n')

sample_next_char <- function(preds, temperature = 1.0) {

  preds = exp(log(as.numeric(preds))/temperature)
  
  which.max(rmultinom(1, 1, preds)[,1])
}


model = load_model_hdf5('5book30epochs.h5')

for(k in 1:5){
  
  s = ''
  
  for (temperature in c(0.2, 0.4, 0.5)) {
    
    cat("------ temperature:", temperature, "\n")
    s = c(s,paste('\n\ntemperature:',temperature,'\n'))
    
    generated_chars <- strsplit(sentence, "")[[1]]
    generated_text = text
    
    sampled <- array(0, dim = c(1, maxlen+1, length(chars)))
    
    for (t in 1:length(generated_chars)) {
      char <- generated_chars[[t]]
      #print(char)
      sampled[1, t, char_indices[[char]]] <- 1
    }
    
    # generate characters
    for (i in 1:300) {
      
      preds <- model %>% predict(sampled[,1:maxlen,, drop = F], verbose = 0)
      next_index <- sample_next_char(preds[1,], temperature)
      next_char <- chars[[next_index]]
      sampled[1, maxlen+1, char_indices[[next_char]]] <- 1
      sampled[1,1:maxlen,] = sampled[1,2:(maxlen+1),]
      sampled[1,maxlen+1,] = sampled[1,maxlen+1,]*0
      
      
      generated_text <- paste0(generated_text, next_char)
      #generated_text <- substring(generated_text, 2)
      
      cat(next_char)
    }
    cat("\n\n")
    
    #writeLines(generated_text,file.path(getwd(),text_path, paste(temperature,file_name) ))
    s = c(s,generated_text)
  }
  writeLines(paste0(s,collapse = ''),file.path(getwd(),text_path, paste(k,file_name) ))
}








