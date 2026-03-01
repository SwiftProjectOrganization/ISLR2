modnn = keras_model_sequential() %>%
    layer_dense(units=50, activation="relu",
    input_shape=ncol(x)) %>%
    layer_dropout(rate=0.4) %>%
    layer_dense(units=1)

x <- model.matrix (Salary ~ . - 1, data = Gitters) %>% scale ()

modnn %>% compile(loss = "mse",
    optimizer = optimizer_rmsprop (),
    metrics = list("mean_absolute_error"))

history <- modnn %>% fit(
    x[-testid,], y[-testid], epochs = 1500, batch_size = 32,
    validation_data = list(x[testid,], y[testid]))

plot(history)
