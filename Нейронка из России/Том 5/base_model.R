
library(keras)


load('arrays.rdata')


model <- keras_model_sequential() %>% 
  layer_lstm(units = 128, input_shape = c(maxlen, length(chars))) %>% 
  layer_dense(units = length(chars), activation = "softmax")


optimizer <- optimizer_rmsprop(lr = 0.01)
model %>% compile(
  loss = "categorical_crossentropy", 
  optimizer = optimizer
)   



sample_next_char <- function(preds, temperature = 1.0) {
  preds <- as.numeric(preds)
  preds <- log(preds) / temperature
  exp_preds <- exp(preds)
  preds <- exp_preds / sum(exp_preds)
  which.max(t(rmultinom(1, 1, preds)))
}





for (epoch in 1:60) {
  
  cat("epoch", epoch, "\n")
  
  # Fit the model for 1 epoch on the available training data
  model %>% fit(x, y, batch_size = 128, epochs = 1) 
  
  # Select a text seed at random
  start_index <- sample(1:(nchar(text) - maxlen - 1), 1)  
  seed_text <- str_sub(text, start_index, start_index + maxlen - 1)
  
  cat("--- Generating with seed:", seed_text, "\n\n")
  
  for (temperature in c(0.2, 0.5, 1.0, 1.2)) {
    
    cat("------ temperature:", temperature, "\n")
    cat(seed_text, "\n")
    
    generated_text <- seed_text
    
    # We generate 400 characters
    for (i in 1:400) {
      
      sampled <- array(0, dim = c(1, maxlen, length(chars)))
      generated_chars <- strsplit(generated_text, "")[[1]]
      for (t in 1:length(generated_chars)) {
        char <- generated_chars[[t]]
        sampled[1, t, char_indices[[char]]] <- 1
      }
      
      preds <- model %>% predict(sampled, verbose = 0)
      next_index <- sample_next_char(preds[1,], temperature)
      next_char <- chars[[next_index]]
      
      generated_text <- paste0(generated_text, next_char)
      generated_text <- substring(generated_text, 2)
      
      cat(next_char)
    }
    cat("\n\n")
  }
}












