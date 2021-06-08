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
- [x] backup => CARLOS
  + [x] server
  + [x] client

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


## Correction

Buena estructuración del código. Buena colección de tests.

- [ ] Hay un problema CRÍTICO en la implementación, y es que la función "sshcmd"
	  introduce fallos en aquellas llamadas que trabajan con redirecciones,
	  haciendo que los ficheros de destino no se modifiquen. Se hubiese
	  solucionado con un doble entrecomillado en la mayoría de los casos. Esto
	  da lugar a que muchos de los servicios no funcionen como se esperen. No lo
	  tendré en cuenta en la valoración de los servicios, pero sí en el apartado
	  de código.

### LVM

- [ ] Al instalar el paquete "lvm2" como "lvm2*" (con asterisco) podríamos estar
	  instalando más paquetes de lo deseado. De hecho, así es, puesto que
	  instala numerosos paquetes y librerías que tarda minutos.

- [ ] No se trata de controlar que haya más volúmenes lógicos que dispositivos
	  físicos (eso no es un problema), sino que el tamaño asignado a los
	  volúmenes lógicos supere el total del grupo de volúmenes mediante el
	  mandato "vgs" o "vgdisplay".

### RAID

- [ ] Se reporta un error en la línea 53 ante perfiles de configuración
	  correctos.

- [ ] Falta modificar el fichero "/etc/mdadm/mdadm.conf" para que el RAID se
	  autoensamble tras cada reinicio.

### Mount

- [ ] El fichero /etc/fstab no se ve modificado en realidad.


### NFS
#### C

- [ ] Para el cliente basta con el paquete "nfs-common".

#### S

- [ ] Se debía exportar para todas las redes posibles (con *).

### NIS
#### C

- [ ] No se establece nombre de dominio NIS. El fichero /etc/yp.conf no se ve
	  modificado.

- [ ] El fichero /etc/default/nis no se ve modificado.

#### S

- [ ] El fichero /etc/default/nis no se ve modificado.

### Backup

- [x] No es necesario instalar "cron".

#### C

- [ ] El fichero /etc/crontab no se ve modificado. En todo caso, sobra el
	  "practicas@", puesto que no pretendemos conectarnos como tal usuario en
	  destino a la hora de hacer el backup.

#### S

- [x] No se instala "rsync", que también es necesario para el servidor.

## Marks

- LVM: 8.5
- Mount: 6.0 -> 10.0
- RAID: 7.0
- NFS: 9.8 (C), 10.0 (S). 9.9 (Total)
- NIS: 4.5 (C), 7.0 (S). 5.75 (Total) -> 7.5 (C), 10.0 (S). 8.75 (Total)
- Backup: 6.5
- Código: 10.0 -> 7.0
- Memoria: 10.0
