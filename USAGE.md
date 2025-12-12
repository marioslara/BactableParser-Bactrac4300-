# Guía de Uso - BacTrac Tables

Esta guía te ayudará a procesar tus datos del BacTrac 4300 paso a paso.

## 🎯 Antes de empezar

### Verifica que tienes instalados los paquetes de R

Abre R o RStudio y ejecuta:

```r
# Verificar paquetes instalados
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("readr")) install.packages("readr")
if (!require("plyr")) install.packages("plyr")
if (!require("writexl")) install.packages("writexl")
```

## 📂 Paso 1: Organizar tus archivos

Crea la siguiente estructura de carpetas:

```
Bctable/
├── Bactractables.R
├── exptemp25/               ← Archivos de experimentos a 25°C
│   ├── archivo1.txt
│   ├── archivo2.txt
│   └── MedidassinE/         ← Archivos sin medidas de conductancia
│       └── archivo_sinE.txt
└── exptemp37/               ← Archivos de experimentos a 37°C
    ├── archivo1.txt
    ├── archivo2.txt
    └── MedidassinE/
        └── archivo_sinE.txt
```

**Importante**: Coloca todos los archivos `.txt` del BacTrac en la carpeta correspondiente según la temperatura del experimento.

## ⚙️ Paso 2: Configurar el script

1. Abre `Bactractables.R` en RStudio
2. Localiza la línea 14:
   ```r
   temperatura <- 37  # Cambiar a 37 para modificar todas las rutas
   ```
3. Cambia el valor a `25` o `37` según los archivos que quieras procesar

## ▶️ Paso 3: Ejecutar el script

### Opción A: Desde RStudio
1. Abre `Bactractables.R`
2. Presiona `Ctrl + Shift + Enter` (Windows/Linux) o `Cmd + Shift + Return` (Mac)
3. O haz clic en el botón "Source" en la esquina superior derecha

### Opción B: Desde la consola de R
```r
setwd("~/Desktop/Bctable/")
source("Bactractables.R")
```

## 📊 Paso 4: Revisar los resultados

Después de ejecutar el script, encontrarás nuevas carpetas:

```
exptemp37/
├── metadatos_37/
│   ├── metadatos_37.csv     ← Información de cada experimento
│   └── metadatos_37.xlsx
└── resultados_37/
    ├── M_table_37.csv       ← Medidas de impedancia
    ├── M_table_37.xlsx
    ├── E_table_37.csv       ← Medidas de conductancia
    └── E_table_37.xlsx
```

### ¿Qué contiene cada archivo?

- **metadatos**: Info del experimento (temperatura, tiempo, calibración, etc.)
- **M_table**: Valores de impedancia a lo largo del tiempo
- **E_table**: Valores de conductancia a lo largo del tiempo

## 🔄 Procesar múltiples temperaturas

Si tienes datos de ambas temperaturas (25°C y 37°C):

1. Primero procesa una temperatura:
   ```r
   temperatura <- 25
   source("Bactractables.R")
   ```

2. Luego procesa la otra temperatura:
   ```r
   temperatura <- 37
   source("Bactractables.R")
   ```

Esto generará carpetas separadas para cada temperatura.

## ❗ Solución de problemas comunes

### Error: "No such file or directory"
- **Causa**: Los archivos no están en la carpeta correcta
- **Solución**: Verifica que la ruta en línea 17 apunta a tu carpeta Bctable

### Error: "could not find function..."
- **Causa**: Falta algún paquete
- **Solución**: Ejecuta `install.packages("nombre_del_paquete")`

### No se generan archivos E_table
- **Causa**: Tus archivos no tienen medidas de conductancia
- **Solución**: Esto es normal para algunos experimentos. Coloca estos archivos en la carpeta `MedidassinE/`

### Advertencia sobre plyr y dplyr
- **Causa**: Conflicto entre paquetes
- **Solución**: Ignora la advertencia o comenta la línea `library(plyr)` si no la necesitas

## 💡 Consejos útiles

1. **Nombres de archivos**: Mantén los nombres originales del BacTrac para mejor trazabilidad
2. **Respaldos**: Guarda una copia de los archivos `.txt` originales antes de procesar
3. **Excel vs CSV**: Usa Excel para visualizar rápidamente, CSV para análisis estadístico
4. **ID único**: Cada muestra recibe un ID que puedes usar para unir las tablas

## 📈 Siguiente paso: Análisis estadístico

Una vez que tengas tus archivos procesados, puedes:

1. Importar M_table en R para análisis de crecimiento
2. Realizar ANOVAs
3. Crear gráficas de cinética de crecimiento
4. Calcular tiempos de detección

**Ejemplo básico**:
```r
# Cargar los datos procesados
datos_M <- read.csv("exptemp37/resultados_37/M_table_37.csv")
metadatos <- read.csv("exptemp37/metadatos_37/metadatos_37.csv")

# Unir por ID
datos_completos <- merge(datos_M, metadatos, by = "ID")

# ¡Ya estás listo para analizar!
```

---

¿Tienes dudas? Abre un issue en GitHub con tu pregunta.
