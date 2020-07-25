
library(keras)


load('arrays.rdata')


model_name = 'simple_fit'
model_dir = file.path(getwd(),model_name)
if(!dir.exists(model_dir)){
  dir.create(model_dir)
}



model <- keras_model_sequential() %>% 
  layer_lstm(units = 128, input_shape = c(maxlen, length(chars)), recurrent_activation = "sigmoid") %>% 
  layer_dense(units = length(chars), activation = "softmax")


model %>% compile(
  loss = "categorical_crossentropy", 
  optimizer = optimizer_rmsprop(lr = 0.01)
)   



sample_next_char <- function(preds, temperature = 1.0) {
  #preds <- as.numeric(preds)
  #preds <- log(preds) / temperature
  #exp_preds <- exp(preds)
  #preds <- exp_preds / sum(exp_preds)
  
  preds = exp(log(as.numeric(preds))/temperature)
  
  which.max(rmultinom(1, 1, preds)[,1])
}





for (epoch in 1:50) {
  
  cat("epoch", epoch, "\n")
  
  # Fit the model for 1 epoch on the available training data
  model %>% fit(x, y, batch_size = 128, epochs = 1) 
  
  model_loc = file.path(model_dir, paste0(epoch,'.h5'))
  save_model_hdf5(model, model_loc, overwrite = TRUE, include_optimizer = TRUE)
  
  
  # Select a text seed at random
  start_index <- sample(1:(nchar(text) - maxlen - 1), 1)  
  seed_text <- str_sub(text, start_index, start_index + maxlen - 1)
  
  cat("--- Generating with seed:", seed_text, "\n\n")
  
  for (temperature in c(0.2, 0.5, 1.0)) {
    
    cat("------ temperature:", temperature, "\n")
    cat(seed_text, "\n")
    
    generated_text <- seed_text
    generated_chars <- strsplit(generated_text, "")[[1]]
    
    sampled <- array(0, dim = c(1, maxlen+1, length(chars)))
    
    for (t in 1:length(generated_chars)) {
      char <- generated_chars[[t]]
      sampled[1, t, char_indices[[char]]] <- 1
    }
    
    # generate characters
    for (i in 1:200) {
      
      preds <- model %>% predict(sampled[,1:maxlen,, drop = F], verbose = 0)
      next_index <- sample_next_char(preds[1,], temperature)
      next_char <- chars[[next_index]]
      sampled[1, maxlen+1, char_indices[[next_char]]] <- 1
      sampled[1,1:maxlen,] = sampled[1,2:(maxlen+1),]
      sampled[1,maxlen+1,] = sampled[1,maxlen+1,]*0
      
      
      generated_text <- paste0(generated_text, next_char)
      generated_text <- substring(generated_text, 2)
      
      cat(next_char)
    }
    cat("\n\n")
  }
}












