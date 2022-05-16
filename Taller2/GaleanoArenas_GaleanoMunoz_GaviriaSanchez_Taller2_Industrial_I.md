---
header-includes:
- \usepackage{longtable}
- \usepackage[utf8]{inputenc}
- \usepackage[spanish]{babel}\decimalpoint
- \setlength{\parindent}{1.25cm}
- \usepackage{amsmath}
- \usepackage{xcolor}
- \usepackage{cancel}
- \usepackage{array}
- \usepackage{float}
- \usepackage{multirow}
output:
  pdf_document: 
    number_sections: yes
fontsize: 12pt
papersize: letter
geometry: margin = 1in
language: "es"
editor_options: 
  markdown: 
    wrap: 72
---



```{=tex}
\input{titlepage}
\thispagestyle{empty}
\tableofcontents
\newpage
\thispagestyle{empty}
\listoffigures
\newpage
```

```{=tex}
\pagestyle{myheadings}
\setcounter{page}{4}
```

<!-- Gaviria -->

\section{Ejercicio 1}

<!-- Juanjo -->

\section{Ejercicio 2}

<!-- Simon -->

\section{Ejercicio 3}

Se tiene que una fábrica de papel utiliza gráficas de control para monitorear el número de defectos en los rollos de papel
terminados, como se tiene que los datos registrados representan una tasa, es decir, la ocurrencia de algún evento por unidad,
lo más adecuado sería utilizar la gráfica C pues esta se encuentra diseñada para monitorear el número total de defectos por 
unidad de inspección.

Se presentan a continuación los datos que se obtuvieron luego de registrar el número de defectos por 20 días en distintas
cantidades de rollos

\begin{table}[H]

\caption{\label{tab:unnamed-chunk-1}Cantidad de defectos totales por rollos inspecionados en los 20 días}
\centering
\begin{tabular}[t]{ccc}
\toprule
Día & Rollos inspeccionados & Cantidad de defectos\\
\midrule
1 & 18 & 12\\
2 & 18 & 14\\
3 & 24 & 20\\
4 & 22 & 18\\
5 & 22 & 15\\
6 & 22 & 12\\
7 & 20 & 11\\
8 & 20 & 15\\
9 & 20 & 12\\
10 & 20 & 10\\
11 & 18 & 18\\
12 & 18 & 14\\
13 & 18 & 9\\
14 & 20 & 10\\
15 & 20 & 14\\
16 & 20 & 13\\
17 & 24 & 16\\
18 & 24 & 18\\
19 & 22 & 20\\
20 & 21 & 17\\
\bottomrule
\end{tabular}
\end{table}

Se tiene que la unidad de inspección son 4 rollos, así que la información mostrada anteriormente no contiene dicha
característica, por lo que se muestra realmente la cantidad de unidades de inspección que fueron tomadas en cuenta (se muestran los
registros de los pŕimeros cinco días).

\begin{table}[H]

\caption{\label{tab:unnamed-chunk-2}Cantidad de defectos totales por unidades de inspección}
\centering
\begin{tabular}[t]{ccc}
\toprule
Día & Unidades de inspección & Cantidad de defectos\\
\midrule
1 & 4.5 & 12\\
2 & 4.5 & 14\\
3 & 6.0 & 20\\
4 & 5.5 & 18\\
5 & 5.5 & 15\\
6 & 5.5 & 12\\
\bottomrule
\end{tabular}
\end{table}

\section{Ejercicio 4}

<!-- Gaviria -->

\section{Ejercicio 5}



