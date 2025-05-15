### ACTIVACIÓN DE PAQUETES ###
library(easypackages)
libraries(
  "psych", "PerformanceAnalytics", "ggplot2", "tibble", "readr", "plotly",
  "dplyr", "FactoMineR", "factoextra", "MVA", "datasets", "aplpack",
  "polycor", "ggcorrplot", "Hmisc", "lavaan"
)

### CARGA DE BASES ###
ces_g <- read.csv("ces_g.csv")
ces_g[ , -1] <- ces_g[ , -1] - 1
ces <- ces_g[ , -1]

### PUNTAJE TOTAL ###
ces_g$dep_total_g <- rowSums(ces_g[, paste0("DEP", 1:20)])

### DIFERENCIA DE MEDIAS ENTRE GÉNEROS ###
grupo_hombres <- ces_g$dep_total_g[ces_g$genero == 2]
grupo_mujeres <- ces_g$dep_total_g[ces_g$genero == 1]

# Descriptivos
describe(ces_g$dep_total_g)
describeBy(ces_g$dep_total_g, group = ces_g$genero)

### QUINTILES Y DESCRIPTIVOS POR GÉNERO ###
datos_dep_totalnuevo <- ces_g %>%
  select(genero, dep_totalnuevo = dep_total_g)

# Descriptivos generales
describe(datos_dep_totalnuevo$dep_totalnuevo)
describeBy(datos_dep_totalnuevo$dep_totalnuevo, group = datos_dep_totalnuevo$genero, mat = TRUE)

# Quintiles generales
quintilesTodos <- quantile(datos_dep_totalnuevo$dep_totalnuevo, probs = seq(0, 1, by = 0.2))

# Quintiles por género
quintiles_por_genero <- datos_dep_totalnuevo %>%
  group_by(genero) %>%
  summarise(
    Q0 = quantile(dep_totalnuevo, 0, na.rm = TRUE),
    Q20 = quantile(dep_totalnuevo, 0.2, na.rm = TRUE),
    Q40 = quantile(dep_totalnuevo, 0.4, na.rm = TRUE),
    Q60 = quantile(dep_totalnuevo, 0.6, na.rm = TRUE),
    Q80 = quantile(dep_totalnuevo, 0.8, na.rm = TRUE),
    Q100 = quantile(dep_totalnuevo, 1, na.rm = TRUE)
  )
print(quintiles_por_genero)

### PRUEBA U DE MANN-WHITNEY ###
resultado <- wilcox.test(grupo_hombres, grupo_mujeres, exact = FALSE)
cat("Estadístico W:", format(resultado$statistic, big.mark = ","), "\n")
cat("Valor p:", format(resultado$p.value, scientific = FALSE, digits = 6), "\n")

### SUBESCALAS ###
AD <- ces %>% select(DEP17, DEP18, DEP14, DEP10, DEP3, DEP6, DEP2, DEP20)  # Afecto depresivo
AS <- ces %>% select(DEP19, DEP15, DEP9)                                   # Aspectos sociales
SS <- ces %>% select(DEP7, DEP13, DEP5, DEP1, DEP11)                       # Síntomas somáticos
AP <- ces %>% select(DEP8, DEP12, DEP4, DEP16)                             # Afecto positivo

### ANÁLISIS FACTORIAL EXPLORATORIO ###
poli <- polychoric(ces)$rho

# KMO y prueba de esfericidad
KMO(poli)
bartlett_test <- cortest.bartlett(poli, n = nrow(ces))
bartlett_test$p.value

# Modelos factoriales
modelo4 <- fa(poli, nfactors = 4, rotate = "varimax", fm = "pa", normalize = TRUE)
fa.sort(modelo4)

modelo3 <- fa(poli, nfactors = 3, rotate = "varimax", fm = "pa", normalize = TRUE)
fa.sort(modelo3)

### ANÁLISIS FACTORIAL CONFIRMATORIO CON LAVAAN ###
modelo <- '
  F1 =~ DEP3 + DEP6 + DEP18 + DEP7 + DEP20 + DEP10 + DEP5 + DEP14 + DEP1 + DEP11 + DEP2 + DEP9 + DEP17 + DEP13
  F2 =~ DEP16 + DEP12 + DEP8 + DEP4
  F3 =~ DEP15 + DEP19
'

fit <- cfa(modelo, data = ces, estimator = "WLSMV", std.lv = TRUE)
summary(fit, fit.measures = TRUE, standardized = TRUE)

### FACTORIAL POR GÉNERO ###
hombres_g <- ces_g %>% filter(genero == 2) %>% select(starts_with("DEP"))
mujeres_g <- ces_g %>% filter(genero == 1) %>% select(starts_with("DEP"))

modeloh3 <- fa(hombres_g, nfactors = 3, rotate = "varimax", fm = "pa", normalize = TRUE)
fa.sort(modeloh3)

modelom3 <- fa(mujeres_g, nfactors = 3, rotate = "varimax", fm = "pa", normalize = TRUE)
fa.sort(modelom3)

### CONFIABILIDAD ###
ces1 <- ces + 1

# General
alpha_general <- psych::alpha(ces1)
alpha_general

omega_general <- omega(ces1)
omega_general

# Por género
alpha_hombres <- psych::alpha(hombres_g)
alpha_hombres

alpha_mujeres <- psych::alpha(mujeres_g)
alpha_mujeres

omega_hombres <- omega(hombres_g)
omega_hombres

omega_mujeres <- omega(mujeres_g)
omega_mujeres

# Afecto depresivo (AD)
alpha_AD <- psych::alpha(AD)
print(alpha_AD)

omega_AD <- omega(AD)
print(omega_AD)

# Aspectos sociales (AS)
alpha_AS <- psych::alpha(AS)
print(alpha_AS)

omega_AS <- omega(AS)
print(omega_AS)

# Síntomas somáticos (SS)
alpha_SS <- psych::alpha(SS)
print(alpha_SS)

omega_SS <- omega(SS)
print(omega_SS)

# Afecto positivo (AP)
alpha_AP <- psych::alpha(AP)
print(alpha_AP)

omega_AP <- omega(AP)
print(omega_AP)

### COMPARACIONES ENTRE GRUPOS ###

# Estrato
kruskal.test(dep_totalnuevo ~ estrato, data = datos_dep_totalnuevo)
posthoc_estrato <- pairwise.wilcox.test(datos_dep_totalnuevo$dep_totalnuevo,
                                        datos_dep_totalnuevo$estrato,
                                        p.adjust.method = "bonferroni")
print(posthoc_estrato)

# Género
kruskal.test(dep_totalnuevo ~ genero, data = datos_dep_totalnuevo)
posthoc_genero <- pairwise.wilcox.test(datos_dep_totalnuevo$dep_totalnuevo,
                                       datos_dep_totalnuevo$genero,
                                       p.adjust.method = "bonferroni")
print(posthoc_genero)

# Facultad
kruskal.test(dep_totalnuevo ~ facultad, data = datos_dep_totalnuevo)
posthoc_facultad <- pairwise.wilcox.test(datos_dep_totalnuevo$dep_totalnuevo,
                                         datos_dep_totalnuevo$facultad,
                                         p.adjust.method = "bonferroni")
print(posthoc_facultad)
  