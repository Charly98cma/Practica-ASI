# Practica-ASI
## Servicios

- [x] mount
- [x] raid
- [x] lvm
- [ ] nis => ANTO
  + [ ] server
  + [ ] client
- [ ] nfs => YOUNES
  + [ ] server
  + [ ] client
- [ ] backup => CARLOS
  + [ ] server
  + [x] client

## TODOs

- [ ] Implementar NisS y NisC
- [ ] Implementar NfsS y NfsC
- [ ] Terminar de implementar backupC
- [ ] Implementar backupS

## Códigos de error
### Códigos de error triviales [1 - 6)

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

- **20**: Error inesperado al configurar el servicio
- **21**": Error en el nivel de RAID proporcionado

### Códigos de error de *lvm* [30 - 40)

- **30**: El dispositivo X en la máquina Y no existe.
- **31**: Error inesperado al inicializar los volúmenes físicos
- **32**: Error inesperado al crear el grupo X
- **33**: Se ha excedido el tamaño del grupo al crear los volúmenes lógicos
- **34**: Error inesperado al crear el volumen lógico X

### Códigos de error de *nisClient* [40 - 50)

### Códigos de error de *nisServer* [50 - 60)

### Códigos de error de *nfsClient* [60 - 70)

### Códigos de error de *nfsServer* [70 - 80)

### Códigos de error de *backupClient* [80 - 90)

- **80**: La dirección de la que hacer backup no existe.
- **81**: La dirección en la que guardar los backups no existe.
- **82**: La frecuencia de los backups tiene que ser mayor que 0
- **83**: Error inesperado al introducir el comando de backup en /etc/crontab

### Códigos de error de *backupServer* [90 - 100)

- **90**: El directorio del servidor de backup no existe.
- **91**: El directorio del servidor de backup no está vacío.
