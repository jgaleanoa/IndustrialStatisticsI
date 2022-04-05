sgraph <- function(data, sig = 0.05) {
  n <- nrow(data)
  sd.sample <- apply(data[, -1], 1, sd)
  sbar <- mean(sd.sample)
  ucl <- sbar*sqrt(qchisq(sig/2, n-1, lower.tail = F)/(n-1))
  lcl <- sbar*sqrt(qchisq(1-sig/2, n-1, lower.tail = F)/(n-1))
  aux <- data.frame(Muestra = data[, 1], Desvi = sd.sample) %>% 
    mutate(out = if_else(between(Desvi, lcl, ucl), "Dentro", "Fuera"))
  p <- ggplot(aux) +
    geom_point(aes(1:n, Desvi, color = out), show.legend = F) +
    geom_path(aes(1:n, Desvi)) + 
    geom_hline(yintercept = c(sbar, lcl, ucl), linetype = "dashed") +
    geom_label(aes(x = n, y = lcl, label = "LCL"))+
    geom_label(aes(x = n, y = ucl, label = "UCL"))+
    geom_label(aes(x = n, y = sbar, label = "CL"))+
    geom_label(aes(x = 0, y = lcl, label = round(lcl,3)))+
    geom_label(aes(x = 0, y = sbar, label = round(sbar,3)))+
    geom_label(aes(x = 0, y = ucl, label = round(ucl,3)))+
    scale_x_continuous(breaks = 1:n, labels = as.character(data$Muestra)) +
    labs(y = "Desviación estándar estimada", x = "Muestra",
         title = "Gráfico de control para s") +
    scale_color_manual(values = c ("black", "red")) + 
    theme_bw() +
    theme(plot.title = element_text(hjust = .5)) 
  return(list(plot = p, data = aux, lcl = lcl, ucl = ucl, sbar = sbar))
}

xbargraph <- function(data, sbar, sig = 0.05) {
  n <- nrow(data)
  mean.sample <- apply(data[, -1], 1, mean)
  xbarbar <- mean(mean.sample)
  ucl <- xbarbar + qnorm(sig/2, lower.tail = F)*sbar/sqrt(n)
  lcl <- xbarbar - qnorm(sig/2, lower.tail = F)*sbar/sqrt(n)
  aux <- data.frame(Muestra = data[, 1], Media = mean.sample) %>% 
    mutate(out = if_else(between(Media, lcl, ucl), "Dentro", "Fuera"))

  p <- ggplot(aux) +
    geom_point(aes(1:n, Media, color = out), show.legend = F) +
    geom_path(aes(1:n, Media)) + 
    geom_hline(yintercept = c(xbarbar, lcl, ucl), linetype = "dashed") +
    geom_label(aes(x = n, y = lcl, label = "LCL"))+
    geom_label(aes(x = n, y = ucl, label = "UCL"))+
    geom_label(aes(x = n, y = xbarbar, label = "CL"))+
    geom_label(aes(x = 0, y = lcl, label = round(lcl,3)))+
    geom_label(aes(x = 0, y = xbarbar, label = round(xbarbar,3)))+
    geom_label(aes(x = 0, y = ucl, label = round(ucl,3)))+
    scale_x_continuous(breaks = 1:n, labels = as.character(data$Muestra)) +
    labs(y = "Media muestral estimada", x = "Muestra",
         title = "Gráfico de control para la media muestral") +
    scale_color_manual(values = c ("black", "red")) + 
    theme_bw() +
    theme(plot.title = element_text(hjust = .5)) 
  return(list(plot = p, data = aux, lcl = lcl, ucl = ucl, xbar = xbarbar))
}
