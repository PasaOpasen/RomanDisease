
library(keras)


load('arrays 50 5.rdata')

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
             recurrent_activation = "sigmoid") %>%
  #layer_batch_normalization() %>% 
  layer_dropout(rate = 0.5) %>% 
  layer_dense(units = length(chars), activation = "softmax")


model %>% compile(
  loss = "categorical_crossentropy", 
  optimizer = optimizer_rmsprop(lr = 0.01)
)   

model %>% 
  fit(X_train, y_train, 
      batch_size = 128, 
      epochs = 30,
      validation_data = list(X_test, y_test),
      callbacks = list(
        callback_reduce_lr_on_plateau(
          monitor = "val_loss",
          patience = 3,
          factor = 0.5
        )
      )
  ) 

save_model_hdf5(model, '50 5 30epoch.h5', overwrite = TRUE, include_optimizer = TRUE)


