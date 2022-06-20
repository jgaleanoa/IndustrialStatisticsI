library(tidyverse)
library(latex2exp)
library(plotly)
datos <- readRDS("ALLTEXMAYPRESENT.Rds")
table(datos$OPERARIO)
datos_train <- datos[datos$FECHA <= "2022-05-24", ]
datos_test <- datos[datos$FECHA > "2022-05-24", ]

MRifoo <- function(x) {
  n <- length(x)
  return(abs(x[-1] - x[-n]))
}

plotMR <- function(df) {
  MR.bar <- mean(df$MR)
  n <- length(df$MR)
  UCL <- 3.267*MR.bar
  df <- df %>% 
    mutate(out = if_else(MR > UCL, "Fuera de Control", "En control"))
  p <- ggplot(df, aes(x = muestra, y = MR)) +
    geom_point(aes(color = out)) +
    geom_path() + 
    geom_hline(yintercept = c(UCL, MR.bar, 0), linetype = "dashed") +
    labs(y = "Rango móvil", x = "Número de rollo",
        title = "Gráfico de control para el rango móvil", color = "Estado") +
    scale_color_manual(values = c ("black", "red")) +
    theme_minimal() +
    theme(axis.text.x = element_blank(),
          plot.title = element_text(hjust = .5))
  df <- df %>% 
    filter(out == "En control")
  return(list(graph = p, datos = df, MR = MR.bar))
}

MRi.1 <- MRifoo(datos_train$KGS.)
df.1 <- data.frame(MR = MRi.1, muestra = 1:length(MRi.1))

first.mr <- plotMR(df.1)
(p1.1 <- first.mr$graph)
ggplotly(p1.1)
df.2 <- first.mr$datos

second.mr <- plotMR(df.2)
(p1.2 <- second.mr$graph)
ggplotly(p1.2)
df.3 <- second.mr$datos

third.mr <- plotMR(df.3)
(p1.3 <- third.mr$graph)
ggplotly(p1.3)
df.var.melo <- third.mr$datos
MR <- third.mr$MR
df.ind.1 <- datos_train[df.var.melo$muestra, c("KGS.")] %>% 
  mutate(muestra = df.var.melo$muestra)
sigma <- MR/1.128

plotind <- function(df, mr = MR) {
  n <- max(df$muestra)
  CL <- mean(df$KGS.)
  UCL <- CL + 3*mr/1.128; LCL <- CL - 3*mr/1.128
  df <- df %>% 
    mutate(out = if_else(between(KGS., LCL, UCL), "En control", "Fuera de Control"))
  p <- ggplot(df, aes(x = muestra, y = KGS.)) +
    geom_point(aes(color = out)) +
    geom_path() + 
    geom_hline(yintercept = c(LCL, CL, UCL), linetype = "dashed") +
    labs(y = "Masa del rollo [KG]", x = "Número de rollo",
         title = "Gráfico de control para medidas individuales", color = "Estado") +
    scale_color_manual(values = c ("black", "red")) +
    theme_minimal() +
    theme(axis.text.x = element_blank(),
          plot.title = element_text(hjust = .5))
  df <- df %>% 
    filter(out == "En control")
  return(list(graph = p, datos = df, mu = CL))
}

first.mu <- plotind(df.ind.1)
(p2.1 <- first.mu$graph)
ggplotly(p2.1)
df.ind.2 <- first.mu$datos

second.mu <- plotind(df.ind.2)
(p2.2 <- second.mu$graph)
df.ind.2 <- first.mu$datos
ggplotly(p2.2)

mu <- mean(df.ind.2$KGS.)
UCL <- mu + 3*MR/1.128; LCL <- mu - 3*MR/1.128
datos_test$muestra <- 143:(143 + 76 - 1)

ggplotly(datos_test %>% 
  select(muestra, KGS.) %>% 
  mutate(out = if_else(between(KGS., LCL, UCL), "En control", "Fuera de control")) %>% 
  ggplot(aes(muestra, KGS.)) +
  geom_point(aes(color = out)) +
  geom_path() +
  geom_hline(yintercept = c(mu, UCL, LCL), linetype = "dashed") +
    geom_hline(yintercept = c(19, 22), linetype = "dotted", col = "red") +
  theme_minimal() +
  labs(y = "Masa del rollo [KG]", x = "Número de rollo",
       title = "Gráfico de control para medidas individuales\nFase II", color = "Estado") +
  scale_color_manual(values = c ("black", "red")) +
  theme_minimal() +
  theme(axis.text.x = element_blank(),
        plot.title = element_text(hjust = .5)))

K <- 0.5*sigma.1/2
UCL <- 5*sigma.1
LCL <- -UCL
Ciplus <- numeric(nrow(datos_test))
Ciminus <- numeric(nrow(datos_test))

for (i in 1:nrow(datos_test)) {
  Ciplus[i] <- max(0, df.ind.2$KGS.[i] - (mu + K) + ifelse(i == 1, 0, Ciplus[i-1]))
  Ciminus[i] <- -max(0, (mu - K) - df.ind.2$KGS.[i]  + ifelse(i == 1, 0, Ciminus[i-1]))
}

datoscusum <- data.frame(Muestra = rep(1:nrow(datos_test), 2), Ci = c(Ciplus, Ciminus), 
                         sign = factor(rep(c(1,-1), each = nrow(datos_test)),
                                       labels  = c("-", "+")))
cusumplot <- ggplot(data = datoscusum, aes(Muestra, Ci, color = sign, group = sign)) +
  geom_point() +
  geom_path() +
  geom_hline(yintercept = c(UCL, LCL, 0), linetype = "dashed") +
  labs(y = "Ci", title = "Gráfica de sumas acumuladas para la característica de calidad",
       color = "") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = .5)) +
  scale_color_manual(values = c("cyan", "red"))
ggplotly(cusumplot)
