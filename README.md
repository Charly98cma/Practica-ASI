# Practica-ASI

## TODOs
- Añadir comprobación (e instalación) de librerías
- *raid*: Añadir comprobación para niveles de RAID
- **Revisar los detalles y argumentos de cada parámetros tras leerme las diapos**

## Códigos de error
### Códigos de error generales
- **1**: No se proporciona el fichero de configuración como argumento
- **2**: El fichero de configuración no existe o es un directorio
- **3**: Una de las líneas del fichero de configuración no sigue el formato adecuado (DIR SERVICIO FICH_CONFIG)
- **4**: Uno de los ficheros de configuración de un servicio no existe
- **5**: Uno de los servicios en el fichero de configuración es desconocido
- **6**: Error en el formato del archivo de configuración
- **7**: Error inesperado en 'ssh'

### Códigos de error de *mount*
- **8**: El dispositivo a montar no existe.
- **9**: El directorio de montaje no es un directorio vacío
- **10**: Error inesperado durante el montaje
- **11**: Error inesperado al crear el directorio

### Códigos de error de *raid*
- **12**: Error al configurar el servicio

### Códigos de error de *lvm*
- **8**: El dispositivo X en la máquina Y no existe.
- **13**: Error inesperado al crear el grupo X
