datos <- readRDS("ALLTEXMAYPRESENT.Rds")
datos_train <- datos[datos$FECHA <= "2022-05-24", ]
datos_test <- datos[datos$FECHA > "2022-05-24", ]
qcc(datos_train$KGS., type = "xbar.one", newdata = datos_test$KGS.)
