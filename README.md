# Practica-ASI
## Servicios
- [ ] mount -> *Pendiente de testear*
- [ ] raid -> *Pendiente de testear*
- [ ] lvm -> *Pendiente de testear*
- [ ] nis =>
  + [ ] server
  + [ ] client
- [ ] nfs =>
  + [ ] server
  + [ ] client
- [ ] backup => CARLOS
  + [ ] server
  + [ ] client

## TODOs
- Añadir comprobación (e instalación) de librerías
  + [x] mount -> No lo veo muy necesario (por defecto en cualquier sistema GNU)
  + [x] lvm   -> Igual que *mount*
  + [x] raid  -> **DUDA**: ¿Se requiere la pwd para instalar algo? (ya que se usa *sudo apt install*)
- Revisar *raid* por si faltan parámetros o comprobaciones
- Revisar *lvm* (por si falta o hay algo mal)

## Códigos de error
### Códigos de error generales
- **255**: Error inesperado al intentar instalar el paquete X en el host Y
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
- **12**: Error al inesperado configurar el servicio
- **13**: Error en el nivel de RAID proporcionado

### Códigos de error de *lvm*
- **8**: El dispositivo X en la máquina Y no existe.
- **14**: Error inesperado al inicializar los volúmenes físicos
- **15**: Error inesperado al crear el grupo X
- **16**: Se ha excedido el tamaño del grupo al crear los volúmenes lógicos
- **17**: Error inesperado al crear el volúmen lógico X
