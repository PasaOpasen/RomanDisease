library(keras)


load('arrays.rdata')

#all_inds = sample(c(1,2,3), size = dim(x)[1], replace = T, prob = c(0.7,0.2,0.1))

first_inds = ifelse(1:dim(x)[1] > 0.3*dim(x)[1], 1, 2)

all_inds = sample(c(2,3), size = sum(first_inds==2), replace = T, prob = c(0.6,0.4))

first_inds[first_inds == 2] = all_inds

all_inds = first_inds

train_inds = all_inds == 1
val_inds = all_inds == 2
test_inds = all_inds == 3

X_train = x[train_inds,,]
y_train = y[train_inds,]
X_test = x[val_inds,,]
y_test = y[val_inds,]



model <- keras_model_sequential() %>% 
  layer_lstm(units = 128, input_shape = c(maxlen, length(chars)), 
             recurrent_activation = "sigmoid", recurrent_dropout = 0, dropout = 0.5, return_sequences = F) %>%
  #layer_batch_normalization() %>% 
  #layer_dense(units = 128, activation = 'relu') %>% 
  layer_dense(units = length(chars), activation = "softmax")


model %>% compile(
  loss = "categorical_crossentropy", 
  optimizer = optimizer_adam(lr = 0.01)
)   

model %>% 
  fit(X_train, y_train, 
      batch_size = 128, 
      epochs = 35,
      validation_data = list(X_test, y_test),
      callbacks = list(
        callback_reduce_lr_on_plateau(
          monitor = "val_loss",
          patience = 3,
          factor = 0.7
        )
      )
  ) 

save_model_hdf5(model, 'fit3_30epochs_1.76val_loss.h5', overwrite = TRUE, include_optimizer = TRUE)

# overfitting -- after 31 epochs, loss = 1.75, val_loss = 1.77
#
#
#
#
#



