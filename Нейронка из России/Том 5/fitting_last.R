library(keras)


load('arrays.rdata')



model <- keras_model_sequential() %>% 
  layer_lstm(units = 128, input_shape = c(maxlen, length(chars)), 
             recurrent_activation = "sigmoid") %>%
  #layer_batch_normalization() %>% 
  layer_dropout(rate = 0.5) %>% 
  layer_dense(units = length(chars), activation = "softmax")


model %>% compile(
  loss = "categorical_crossentropy", 
  optimizer = optimizer_rmsprop(lr = 0.01)
)   

model %>% 
  fit(x, y, 
      batch_size = 128, 
      epochs = 10,
      callbacks = list(
        callback_reduce_lr_on_plateau(
          monitor = "loss",
          patience = 1,
          factor = 0.5
        )
      )
  ) 


save_model_hdf5(model, '5book100epochs.h5', overwrite = TRUE, include_optimizer = TRUE)




