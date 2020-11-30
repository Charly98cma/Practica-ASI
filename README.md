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
### Códigos de error triviales [0 - 6)
- **1**: No se proporciona el fichero de configuración como argumento
- **2**: El fichero de configuración no existe o es un directorio
- **3**: Una de las líneas del fichero de configuración no sigue el formato adecuado (DIR SERVICIO FICH_CONFIG)
- **4**: Uno de los ficheros de configuración de un servicio no existe
- **5**: Uno de los servicios en el fichero de configuración es desconocido

### Códigos de error comunes a todos los servicios [6 - 10) && 255
- **255**: Error inesperado al intentar instalar el paquete X en el host Y
- **6**: Error en el formato del archivo de configuración

### Códigos de error de *mount* [10 - 20)
- **10**: El dispositivo a montar no existe.
- **11**: El directorio de montaje no es un directorio vacío
- **12**: Error inesperado durante el montaje
- **13**: Error inesperado al crear el directorio

### Códigos de error de *raid* [20 - 30)
- **20**: Error al inesperado configurar el servicio
- **21**": Error en el nivel de RAID proporcionado

### Códigos de error de *lvm* [30 - 40)
- **30**: El dispositivo X en la máquina Y no existe.
- **31**: Error inesperado al inicializar los volúmenes físicos
- **32**: Error inesperado al crear el grupo X
- **33**: Se ha excedido el tamaño del grupo al crear los volúmenes lógicos
- **34**: Error inesperado al crear el volumen lógico X

## Códigos de error de *nisClient* [40 - 50)

## Códigos de error de *nisServer* [50 - 60)

## Códigos de error de *nfsClient* [60 - 70)

## Códigos de error de *nfsServer* [70 - 80)

### Códigos de error de *backupClient* [80 - 90)

### Códigos de error de *backupServer* [90 - 100)
