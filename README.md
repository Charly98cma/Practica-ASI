# Practica-ASI

## Códigos de error
### Códigos de error generales
- **1**: No se proporciona el fichero de configuración como argumento
- **2**: El fichero de configuración no existe
- **3**: Una de las líneas del fichero de configuración no sigue el formato adecuado (DIR SERVICIO FICH_CONFIG)
- **4**: Uno de los ficheros de configuración de un servicio no existe
- **5**: Uno de los servicios en el fichero de configuracion es desconocido

### Códigos de error de *mount*
- **6**: El directorio de montaje no es un directorio vacío

## Tests
- fichero_config no se pasa como argumento
- fichero_config se pasa pero no existe
- Error de formato en fichero_config (!= de 3 campos)
- Error en fichero_config -> Uno de los ficheros de config de un servicio no existe
