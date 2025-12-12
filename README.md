# BacTrac Tables (Bctable)

Herramienta en R para procesar y organizar automáticamente los datos generados por el sistema BacTrac 4300, extrayendo metadatos y medidas de impedancia (M-value) y conductancia (E-value) de archivos de texto.

## 📋 Descripción

Este proyecto permite procesar múltiples archivos `.txt` generados por el BacTrac 4300 y organizarlos en tablas estructuradas que facilitan el análisis estadístico posterior. El script separa automáticamente:

- **Metadatos**: Información del experimento (temperatura, tiempo de inicio, parámetros de calibración, etc.)
- **M-table**: Medidas de impedancia a lo largo del tiempo
- **E-table**: Medidas de conductancia a lo largo del tiempo

## ✨ Características

- ✅ Procesamiento por lotes de múltiples archivos BacTrac
- ✅ Separación automática de metadatos y medidas
- ✅ Sistema de ID único para rastrear cada muestra
- ✅ Configuración flexible por temperatura (25°C / 37°C)
- ✅ Manejo de archivos con y sin medidas de conductancia
- ✅ Exportación en formatos CSV y Excel
- ✅ Creación automática de carpetas de salida

## 📦 Requisitos

### R y paquetes necesarios

- R (versión ≥ 4.0)
- `tidyverse`
- `dplyr`
- `readr`
- `plyr`
- `writexl`

### Instalación de paquetes

```r
install.packages("tidyverse")
install.packages("readr")
install.packages("plyr")
install.packages("writexl")
```

## 🚀 Uso

### 1. Estructura de carpetas recomendada

```
Bctable/
├── Bactractables.R
├── exptemp25/
│   ├── *.txt (archivos BacTrac a 25°C)
│   └── MedidassinE/ (archivos sin E-table)
└── exptemp37/
    ├── *.txt (archivos BacTrac a 37°C)
    └── MedidassinE/ (archivos sin E-table)
```

### 2. Configurar temperatura

Abre `Bactractables.R` y modifica la variable de temperatura según tus datos:

```r
temperatura <- 37  # Cambiar a 25 o 37 según el experimento
```

### 3. Ejecutar el script

```r
source("Bactractables.R")
```

### 4. Resultados

El script generará automáticamente:

```
exptemp{temperatura}/
├── metadatos_{temperatura}/
│   ├── metadatos_{temperatura}.csv
│   └── metadatos_{temperatura}.xlsx
└── resultados_{temperatura}/
    ├── M_table_{temperatura}.csv
    ├── M_table_{temperatura}.xlsx
    ├── E_table_{temperatura}.csv
    └── E_table_{temperatura}.xlsx
```

## 📊 Formato de datos de entrada

El script espera archivos `.txt` con la estructura estándar del BacTrac 4300:
- Primeras 50 líneas: metadatos del experimento
- Líneas 51+: datos de medidas (filas impares = M-values, filas pares = E-values)

## 🔧 Personalización

### Modificar ruta base

Si tus archivos están en otra ubicación, modifica:

```r
ruta_base <- path.expand("~/Desktop/Bctable/")
```

### Procesar solo archivos M (sin E-table)

Los archivos sin medidas de conductancia se procesan automáticamente desde la carpeta `MedidassinE/`.

## 📝 Ejemplo de uso

```r
# 1. Configurar trabajando con experimentos a 37°C
temperatura <- 37

# 2. El script procesa automáticamente todos los archivos .txt
# 3. Los resultados se guardan en:
#    - exptemp37/metadatos_37/
#    - exptemp37/resultados_37/
```

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Si encuentras algún error o tienes sugerencias de mejora, no dudes en abrir un issue o pull request.

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Consulta el archivo `LICENSE` para más detalles.

## 👤 Autor

Mario Lara López

## 📧 Contacto

Si tienes preguntas o necesitas ayuda, abre un issue en este repositorio.

---

**Nota**: Este script fue diseñado específicamente para procesar archivos del sistema BacTrac 4300. Si trabajas con otros sistemas de medición microbiana, puede que necesites adaptarlo.
