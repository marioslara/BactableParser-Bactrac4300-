# BactableParser-Bactrac4300-
Este repositorio contiene un script en R que permite procesar los archivos de texto generados por el equipo Bactrac 4300, extrayendo tres tablas organizadas: metadatos, valores de impedancia M, y valores de impedancia E.

## 🧪 Funcionalidad

Dado un conjunto de archivos `.txt` generados por el Bactrac 4300, el script:
- Extrae automáticamente los metadatos de cada experimento y los va almacenando en un archivo.
- Separa los valores de impedancia M (filas impares) y E (filas pares).
- Guarda las tablas combinadas en formato `.csv` y `.xlsx`.
