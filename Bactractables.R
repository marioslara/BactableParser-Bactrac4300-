# Establecer directorio de trabajo (ajustar a tu ubicación)
# setwd("~/Desktop/Bctable/")

library("tidyverse")
library(readr)
library(plyr)
# install.packages("writexl")  # Ejecutar solo la primera vez
library(writexl)


# Definir la temperatura como variable
temperatura <- 37 # Cambiar a 37 para modificar todas las rutas

# Construcción dinámica de las rutas
ruta_base <- getwd() # Usa el directorio donde está el script
ruta_carpeta <- file.path(ruta_base, paste0("exptemp", temperatura, "/"))
ruta_carpeta_sinE <- file.path(ruta_base, paste0("exptemp", temperatura, "/MedidassinE/"))

# Crear carpetas para guardar resultados si no existen
dir.create(file.path(ruta_carpeta, paste0("metadatos_", temperatura)), showWarnings = FALSE, recursive = TRUE)
dir.create(file.path(ruta_carpeta, paste0("resultados_", temperatura)), showWarnings = FALSE, recursive = TRUE)

print("Carpetas creadas o ya existentes en:")
print(file.path(ruta_carpeta, paste0("metadatos_", temperatura)))
print(file.path(ruta_carpeta, paste0("resultados_", temperatura)))

# Verificar que la carpeta de temperatura exista
if (!dir.exists(ruta_carpeta)) {
  stop("Error: La carpeta exptemp", temperatura, "/ no existe. Créala primero.")
}

# Obtener lista de archivos .txt en la carpeta
archivos <- list.files(path = ruta_carpeta, pattern = "\\.txt$", full.names = TRUE)
archivos_sinE <- list.files(path = ruta_carpeta_sinE, pattern = "\\.txt$", full.names = TRUE)

# Inicializar dataframes vacíos
datos <- NULL
df_M_table <- NULL
df_E_table <- NULL

# Iterador para asignar un número único a cada entrada
contador_ID <- 1


# Procesar cada archivo en la carpeta
for (archivo in archivos) {
  column_names <- c(
    "ID", "BLOCKNO", "POSNO", "INSTRUMENT", "TIMESTARTED", "WARMUPTIME", "hrs.", "MEASURETIME", "hrs.", "LASTTIME",
    "hrs.", "DETECTIONTIME", "hrs.", "TEMPERATURE", "°C", "STATUS", "measuring", "EVALTYPE", "X",
    "LIMITM", "%", "LIMITE", "%", "TIME1", "hrs.", "TIME2", "hrs.", "DROPSTOPM",
    "DRIFTCOMPTIMEM", "hrs.", "DROPSTOPE", "DRIFTCOMPTIMEE", "hrs.", "CALK0", "CALK1", "CALK2", "CALK3",
    "CFU", "(CFU)", "INFO1", "INFO2", "INFO3", "INFO4", "INFO5", "INFO6", "INFO7",
    "USERID", "M0", "Ohm", "ANALYSEID", "CALNAME"
  )
  # Crear un data.frame vacío con esas columnas
  df_metadatos <- data.frame(matrix(ncol = length(column_names), nrow = 0))
  colnames(df_metadatos) <- column_names

  print(paste("Procesando:", archivo))

  # Leer el archivo
  prueba <- read.delim2(archivo, header = TRUE)

  # 📌 Procesar los metadatos (primeras 50 filas)
  metadatos_col <- prueba %>%
    slice(1:50) %>% # Selecciona las primeras 50 filas
    select(2) %>% # Mantiene solo la segunda columna
    t() # Transponer para que sea una fila

  # 🔹 Eliminar nombres de las filas de la transposición
  rownames(metadatos_col) <- NULL

  # Añadir columna ID
  metadatos_col <- cbind(paste0("ID_", contador_ID), metadatos_col)


  # Convertir metadatos_col en un data.frame
  metadatos_col <- data.frame(metadatos_col, stringsAsFactors = FALSE)

  # 🔹 Usar bind_rows para añadir la nueva fila al dataframe df_metadatos
  if (exists("datos")) {
    # Si df_metadatos ya existe, añadir la fila
    datos <- rbind.fill(datos, metadatos_col)
  }


  # 📌 Procesar M_table (filas impares desde la 51)
  M_table <- prueba %>%
    slice(51:n()) %>%
    filter(row_number() %% 2 == 1)

  if (nrow(M_table) > 0) {
    nombre_columnasM <- M_table[, 1]
    tM_table <- t(M_table[, -1])
    colnames(tM_table) <- nombre_columnasM
    tM_table <- data.frame(tM_table, stringsAsFactors = FALSE, check.names = FALSE)

    tM_table <- cbind(ID = paste0("ID_", contador_ID), tM_table)

    df_M_table <- bind_rows(df_M_table, tM_table)
  }

  # 📌 Procesar E_table (filas pares desde la 51)
  E_table <- prueba %>%
    slice(51:n()) %>%
    filter(row_number() %% 2 == 0)

  if (nrow(E_table) > 0) {
    nombre_columnasE <- E_table[, 1]
    tE_table <- t(E_table[, -1])
    colnames(tE_table) <- nombre_columnasE
    tE_table <- data.frame(tE_table, stringsAsFactors = FALSE, check.names = FALSE)

    tE_table <- cbind(ID = paste0("ID_", contador_ID), tE_table)

    df_E_table <- bind_rows(df_E_table, tE_table)
  }

  # Incrementar el contador
  contador_ID <- contador_ID + 1
}


# Procesar cada archivo en la carpeta
for (archivo in archivos_sinE) {
  print(paste("Procesando:", archivo))

  # Leer el archivo
  prueba <- read.delim2(archivo, header = TRUE)

  # 📌 Procesar los metadatos (primeras 50 filas)
  metadatos_col <- prueba %>%
    slice(1:50) %>% # Selecciona las primeras 50 filas
    select(2) %>% # Mantiene solo la segunda columna
    t() # Transponer para que sea una fila

  # 🔹 Eliminar nombres de las filas de la transposición
  rownames(metadatos_col) <- NULL

  # Añadir columna ID
  metadatos_col <- cbind(paste0("ID_", contador_ID), metadatos_col)


  # Convertir metadatos_col en un data.frame
  metadatos_col <- data.frame(metadatos_col, stringsAsFactors = FALSE)

  datos <- rbind.fill(datos, metadatos_col)


  # 📌 Procesar M_table (filas impares desde la 51)
  M_table <- prueba %>%
    slice(51:n()) %>%
    slice(-c(2, 3))


  nombre_columnasM <- M_table[, 1]

  tM_table <- t(M_table[, -1])

  colnames(tM_table) <- nombre_columnasM
  tM_table <- data.frame(tM_table, stringsAsFactors = FALSE, check.names = FALSE)

  tM_table <- cbind(ID = paste0("ID_", contador_ID), tM_table)

  df_M_table <- bind_rows(df_M_table, tM_table)


  # Incrementar el contador
  contador_ID <- contador_ID + 1
}


colnames(datos) <- colnames(df_metadatos)


# Guardar los archivos acumulados con nombres dinámicos
write.csv(datos, file.path(ruta_carpeta, paste0("metadatos_", temperatura), paste0("metadatos_", temperatura, ".csv")), row.names = FALSE)
write.csv(df_M_table, file.path(ruta_carpeta, paste0("resultados_", temperatura), paste0("M_table_", temperatura, ".csv")), row.names = FALSE)
write.csv(df_E_table, file.path(ruta_carpeta, paste0("resultados_", temperatura), paste0("E_table_", temperatura, ".csv")), row.names = FALSE)

# Guardar los archivos acumulados en Excel con nombres dinámicos
write_xlsx(datos, file.path(ruta_carpeta, paste0("metadatos_", temperatura), paste0("metadatos_", temperatura, ".xlsx")))
write_xlsx(df_M_table, file.path(ruta_carpeta, paste0("resultados_", temperatura), paste0("M_table_", temperatura, ".xlsx")))
write_xlsx(df_E_table, file.path(ruta_carpeta, paste0("resultados_", temperatura), paste0("E_table_", temperatura, ".xlsx")))

cat("\n✅ Proceso completado exitosamente!\n")
cat("📊 Archivos procesados:", contador_ID - 1, "\n")
cat("📁 Metadatos guardados en:", file.path(ruta_carpeta, paste0("metadatos_", temperatura)), "\n")
cat("📁 Resultados guardados en:", file.path(ruta_carpeta, paste0("resultados_", temperatura)), "\n")
