library(keras)


load('arrays.rdata')

all_inds = sample(c(1,2,3), size = dim(x)[1], replace = T, prob = c(0.7,0.2,0.1))

train_inds = all_inds == 1
val_inds = all_inds == 2
test_inds = all_inds == 3

X_train = x[train_inds,,]
y_train = y[train_inds,]
X_test = x[test_inds,,]
y_test = y[test_inds,]



model <- keras_model_sequential() %>% 
  model <- keras_model_sequential() %>% 
  layer_lstm(units = 256, input_shape = c(maxlen, length(chars)), recurrent_activation = "sigmoid", recurrent_dropout = 0.6) %>% 
  layer_dense(units = length(chars), activation = "softmax")


model %>% compile(
  loss = "categorical_crossentropy", 
  optimizer = optimizer_rmsprop(lr = 0.01)
)   

model %>% 
  fit(X_train, y_train, 
      batch_size = 128, 
      epochs = 20,
      validation_data = list(X_test, y_test)) 


# overfitting -- after 7 epochs, loss = 1.6, val_loss = 1.73
#
#
#
#
#



