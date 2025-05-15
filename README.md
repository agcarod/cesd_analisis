# Análisis factorial y confiabilidad de la escala CES-D

Este repositorio contiene el código en R utilizado para el análisis factorial, la estimación de confiabilidad (α y ω) y las comparaciones de puntajes del instrumento CES-D en una muestra universitaria. El análisis es parte de un artículo de investigación que busca evaluar la estructura interna de la escala y su comportamiento por género, estrato y facultad.

## 📂 Contenido

- `analisis_ces.R`: Script principal con todo el procesamiento y análisis.
- `resultados/`: Carpeta opcional con gráficas, tablas o salidas relevantes.
- `README.md`: Este archivo.
- `LICENSE`: Licencia abierta para reutilización.
- (Opcional) `datos_simulados.csv`: Versión de ejemplo si no se publican los datos originales.

## 🧪 Paquetes utilizados

- `psych`
- `lavaan`
- `polycor`
- `dplyr`
- `FactoMineR`, `factoextra`
- `ggplot2`, `plotly`
- `Hmisc`, `PerformanceAnalytics`
- entre otros (ver primeras líneas del script)

## 📊 Análisis incluidos

- Estadísticos descriptivos por género
- Pruebas no paramétricas (Mann-Whitney, Kruskal-Wallis, post hoc)
- Análisis factorial exploratorio (PAF con rotación varimax)
- Análisis factorial confirmatorio (CFA con `lavaan`)
- Estimación de confiabilidad:
  - Coeficiente alfa de Cronbach
  - Coeficiente omega total
  - Por escala y por grupo (género)

## 📁 Datos

Los datos utilizados no están disponibles públicamente debido a restricciones éticas. Si deseas replicar el análisis, puedes utilizar datos simulados o ponerte en contacto con los autores.

## 📜 Licencia

Este repositorio se distribuye bajo la licencia MIT (ver archivo `LICENSE`), lo que permite su libre uso con atribución adecuada.

## ✍️ Cita sugerida

Si utilizas este código o parte del análisis, por favor cita el proyecto como:

> \<Autor/es\> (2025). *Análisis factorial y confiabilidad de la escala CES-D*. GitHub. https://github.com/<tu_usuario>/cesd_analisis

## 📬 Contacto

Para dudas, sugerencias o colaboración, puedes contactar a:

**\<Tu nombre completo\>**  
\<Institución / Grupo de investigación\>  
\<Correo electrónico (opcional)\>