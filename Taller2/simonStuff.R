datos3 <- read.table("datos3.txt", header = T)
datos3$Unidades <- datos3$Rollos/4
datos3$DefectosxUnidad <- datos3$Defectos/datos3$Unidades
ubar <- sum(datos3$Defectos)/sum(datos3$Unidades)
datos3$UCL <- ubar + 3*sqrt(ubar/datos3$Unidades)
datos3$LCL <- ubar - 3*sqrt(ubar/datos3$Unidades)
datos3$Fuera <- ifelse((datos3$DefectosxUnidad > datos3$UCL) | (datos3$DefectosxUnidad < datos3$LCL), 
                       "Fuera de control", "En control")
datos3$Fuera <- as.factor(datos3$Fuera)

plotu <- ggplot(data = datos3, aes(x = Dia, y = DefectosxUnidad)) +
  geom_point() +
  geom_path() +
  geom_hline(yintercept = ubar) +
  geom_step(aes(y = UCL), linetype = "dashed") +
  geom_step(aes(y = LCL), linetype = "dashed") +
  labs(x = "Día", y = "Número de defectos promedio por unidad",
       title = "Gráfico de control U para el número de defectos promedio en los rollos") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = .5))

#Ejercicio 4
  #Cusum
datos4 <- read.table("datos4.txt", header = T)
xi_bar <- apply(datos4[,-1], 1, mean)
n <- ncol(datos4) - 1
m <- nrow(datos4)
sigma_xbar <- 4/sqrt(n)
mu_0 <- 16
K <- 0.25*sigma_xbar/2
Ciplus <- numeric(m)
Ciminus <- numeric(m)
for (i in 1:m) {
  Ciplus[i] <- max(0, xi_bar[i] - (mu_0 + K) + ifelse(i == 1, 0, Ciplus[i-1]))
  Ciminus[i] <- max(0, (mu_0 - K) - xi_bar[i]  + ifelse(i == 1, 0, Ciminus[i-1]))
}
H <- 8.01
UCL <- H*sigma_xbar
LCL <- -UCL
datoscusum <- data.frame(Muestra = rep(1:m, 2), Ci = c(Ciplus, -Ciminus), 
                         sign = factor(rep(c(1,-1), each = m), labels  = c("Minus", "Plus")))
cusumplot <- ggplot(data = datoscusum, aes(Muestra, Ci, color = sign, group = sign)) +
  geom_point() +
  geom_path() +
  geom_hline(yintercept = c(UCL, LCL, 0), linetype = "dashed") +
  labs(y = TeX(r'($C_i$)'), title = "Gráfica de sumas acumuladas para la característica de calidad",
       color = "") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = .5)) +
  scale_color_manual(labels = c(TeX(r'($C_{i}^{-}$)'), TeX(r'($C_{i}^{+}$)')), values = c("cyan", "red"))

  #EWMA
lambda <- 0.05
L <- 2.615
Z <- function(i, xbar, lambda = 0.05, muo = mu_0) {
  ac <- 0
  for (j in i:1) {
    ac <- ac + (1-lambda)^(i-j)*xbar[j]
  }
  ac <- ac*lambda + (1-lambda)^(i)*muo
  return(ac)
}
Zi <- sapply(1:m, Z, xbar = xi_bar)
sigma_zi <- sqrt(sigma_xbar^2*(lambda/(2-lambda))*(1 - (1-lambda)^(2*(1:m))))
LCLzi <- mu_0 - L*sigma_zi
UCLzi <- mu_0 + L*sigma_zi

datosewma <- data.frame(Muestra = 1:m, Zi, LCL = LCLzi, UCL = UCLzi)

plotewma <- ggplot(data = datosewma, aes(Muestra, Zi)) +
  geom_point() +
  geom_path() +
  geom_hline(yintercept = mu_0) +
  geom_step(aes(y = LCL), linetype = "dashed") +
  geom_step(aes(y = UCL), linetype = "dashed") +
  labs(y = TeX(r'($Z_i$)'), title = "Gráfico EWMA para la característica de calidad") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = .5))
