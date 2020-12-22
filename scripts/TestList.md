# Tests

**NOTA**: Desinstalar los servicios que se hayan instalado cada vez que se ejecuten los tests.

X. *TEST*
   [**FICHERO/S**] -> *Código de error*

## Tests cliente (los tres primeros campos de TESTS en run-tests.sh)

1. No proporcionar el fichero de config como argumento -> 1

2. El fichero de config no existe -> 2

3. El fichero de config es un directorio (no un fichero) -> 2

## Tests triviales (tests/tests-triviales/)

1. Una de las líneas del fichero no sigue el formato esperado (!= 3 argumentos)
   [**wrong-format.txt**] -> 3

2. Un fichero de config de un servicio no existe
   [**missing-file.txt**] -> 4

3. Uno de los servicio no se reconoce (distinto de los que se han implementado)
   [**unknown-service.txt**] -> 5

---

## Tests de 'mount' (tests/tests-mount/)

1. El formato del fichero de config de un servicio es incorrecto
   (el número de campos no es el esperado)
   [**wrong-config-format.txt -> wrong-config-format.conf**] -> 6

2. El dispositivo a montar no existe
   [**disp-doesnt-exist.txt -> disp-doesnt-exist.conf**] -> 10

3. El dispositivo a montar no es un directorio vacío
   [**point-not-empty.txt -> point-not-empty.conf**] -> 11

4. El punto de montaje no existe (se tiene que crear) y todo funciona correctamente
   [**point-created.txt -> point-created.conf**] -> 0

5. El punto de montaje existe y todo funciona correctamente
   [**successful-config.txt -> successful-config.conf**] -> 0

   *Tras estos tests hay que desmontar los dispositivos montados por el test 9 y 10 para que no den error en la siguiente ejecución*


## Tests de 'raid' (tests/tests-raid/)

1. El formato del fichero de config de un servicio es incorrecto
   (el número de campos no es el esperado)
   [**wrong-config-format.txt -> wrong-config-format.conf**] -> 6

2. El nivel de RAID proporcionado no está soportado (!= 0|1|5|6|10)
   [**wrong-raid-level-config.txt -> wrong-raid-level-config.conf**] -> 21

3. Uno de los dispositivos ya posee un sistema de ficheros
   [**disp-with-fs-config.txt -> disp-with-fs-config.conf**] -> 22

4. TODO - Todos los campos son correctos y todo funciona correctamente
   [**WIP**]-> 0

   *Tras ejecutar los tests, hay que revertir los cambios si se quiere volver a ejecutar el test y que no falle*

## Tests de 'lvm' (tests/tests-lvm/)

1. El formato del fichero de config de un servicio es incorrecto
   (el número de campos no es el esperado)
   (*los volúmenes físicos y el grupo se crearán*)
   [**wrong-config-format.txt -> wrong-config-format.conf**] -> 6

2. Uno de los dispositivos a montar no existe
   [**disp-doesnt-exist.txt -> disp-doesnt-exist.conf**] -> 30

3. Exceder el tamaño del grupo al crear los volúmenes lógicos
   (Vol.Lógicos > Vol. Físicos)
   [**too-many-lvs.txt -> too-many-lvs.conf**] -> 33

4. TODO: Tamaño de volúmenes lógicos mayor del disponible (almacenamiento)
   [**WIP**] -> 34

5. Todo funciona correctamente
   [**successful-lvm.txt ->successful-lvm.conf**] -> 0

## Tests de 'nisClient' (tests/tests-nisc/)
## Tests de 'nisServer' (tests/tests-niss/)
## Tests de 'nfsClient' (tests/tests-nfsc/)
## Tests de 'nfsServer' (tests/tests-nfss/)
## Tests de 'backupClient' (tests/tests-backupc/)



## Tests de 'backupServer' (tests/tests-backups/)
