# Wrappers para gráficas de control
sdcontrolchart <- function(sdqcc){
  #sdqcc es un objeto qcc para la desviacion
  sdqccdf <- data.frame(Subgrupo = 1:length(sdqcc$statistics), 
                        Desviaciones = sdqcc$statistics)
  
  ggplot(sdqccdf, aes(Subgrupo, Desviaciones)) +
    geom_point() +
    geom_point(data = data.frame(Subgrupo = sdqcc$violations$beyond.limits, 
                                 Desviaciones=sdqccdf$Desviaciones[sdqcc$violations$beyond.limits]),                   colour = "red", size = 2)+
    geom_path()+
    geom_hline(yintercept=sdqcc$limits[1], linetype="dashed",size=1)+
    geom_hline(yintercept=sdqcc$limits[2], linetype="dashed",size=1)+
    geom_hline(yintercept=sdqcc$center, linetype="dashed",size=1)+
    geom_label(aes(x = 25, y = sdqcc$limits[1], label = "LCL"))+
    geom_label(aes(x = 25, y = sdqcc$limits[2], label = "UCL"))+
    geom_label(aes(x = 25, y = sdqcc$center, label = "CL"))+
    geom_label(aes(x = 0, y = sdqcc$limits[1], label = round(sdqcc$limits[1],3)))+
    geom_label(aes(x = 0, y = sdqcc$limits[2], label = round(sdqcc$limits[2],3)))+
    geom_label(aes(x = 0, y = sdqcc$center, label = round(sdqcc$center,3)))+
    labs(title="Gráfico de control para desviaciones")+
    theme_bw()+
    theme(plot.title = element_text(hjust = 0.5))
}
#------------------------------------------------------------------

meancontrolchart <- function(meanqcc){
  #meanqcc es un objeto qcc después de depurar
  meanqccdf <- data.frame(Subgrupo = 1:length(meanqcc$statistics), 
                          Promedios = meanqcc$statistics)
  ggplot(meanqccdf, aes(Subgrupo, Promedios)) +
    geom_point() +
    geom_point(data = data.frame(Subgrupo = meanqcc$violations$beyond.limits,
                                 Promedios = meanqccdf$Promedios[meanqcc$violations$beyond.limits]),                   colour = "red", size = 2)+
    geom_path()+
    geom_hline(yintercept=meanqcc$limits[1], linetype="dashed",size=1)+
    geom_hline(yintercept=meanqcc$limits[2], linetype="dashed",size=1)+
    geom_hline(yintercept=meanqcc$center, linetype="dashed",size=1)+
    geom_label(aes(x = 25, y = meanqcc$limits[1], label = "LCL"))+
    geom_label(aes(x = 25, y = meanqcc$limits[2], label = "UCL"))+
    geom_label(aes(x = 25, y = meanqcc$center, label = "CL"))+
    geom_label(aes(x = 0, y = meanqcc$limits[1], label = round(meanqcc$limits[1],3)))+
    geom_label(aes(x = 0, y = meanqcc$limits[2], label = round(meanqcc$limits[2],3)))+
    geom_label(aes(x = 0, y = meanqcc$center, label = round(meanqcc$center,3)))+
    labs(title="Gráfico de control para promedios")+
    theme_bw()+
    theme(plot.title = element_text(hjust = 0.5))
}