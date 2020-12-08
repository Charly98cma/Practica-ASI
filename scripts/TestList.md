# Tests

**NOTA**: Desinstalar los servicios que se hayan instalado cada vez que se ejecuten los tests.

X. *TEST*
   [**FICHERO/S**] -> *Código de error*

## Tests comunes (los tres primeros campos de TESTS en run-tests.sh)

1. No proporcionar el fichero de config como argumento -> 1

2. El fichero de config no existe -> 2

3. El fichero de config es un directorio (no un fichero) -> 2

## Tests triviales (tests/tests-triviales)

1. Una de las líneas del fichero no sigue el formato esperado (!= 3 argumentos)
   [**wrong-format.txt**] -> 3

2. Un fichero de config de un servicio no existe
   [**missing-file.txt**] -> 4

3. Uno de los servicio no se reconoce (distinto de los que se han implementado)
   [**unknown-service.txt**] -> 5

---

## Tests de 'mount' (tests/tests-mount)

1. El formato del fichero de config de un servicio es incorrecto
   (el número de campos no es el esperado)
   [**wrong-config-format.txt -> wrong-config-format.conf**] -> 6

2. El dispositivo a montar no existe
   [**disp-doesnt-exist.txt -> disp-doesnt-exist.conf**] -> 10

3. El dispositivo a montar no es un directorio vacío
   [**point-not-empty.txt -> point-not-empty.conf**] -> 11

	*Antes de ejecutar el test hay que crear el dispositivo `/dev/sdb1` con el comando `mkfifo /dev/sdb1`.*

4. El punto de montaje no existe (se tiene que crear) y todo funciona correctamente
   [**point-created.txt -> point-created.conf**] -> 0

5. El punto de montaje existe y todo funciona correctamente
   [**successful-config.txt -> successful-config.conf**] -> 0

## Tests de 'raid'

1. El formato del fichero de config de un servicio es incorrecto
   (el número de campos no es el esperado)
   [**wrong-config-format.txt -> wrong-config-format.conf**] -> 6

2. El nivel de RAID proporcionado no está soportado (!= 0|1|5|6|10)
   [**wrong-raid-level-config.txt -> wrong-raid-level-config.conf**] -> 21

3. TODO: COMPROBAR QUE LOS DISPOSITIVOS NO TIENEN YA UN SISTEMA DE FICHEROS
   [**WIP**] -> ??

4. Todos los campos son correctos y todo funciona correctamente
   [**WIP**]-> 0

## Tests de 'lvm'

1. El formato del fichero de config de un servicio es incorrecto
   (el número de campos no es el esperado)
   [**WIP**] -> 6

2. Uno de los dispositivos a montar no existe
   [**WIP**] -> 30

3. Exceder el tamaño del grupo al crear los volúmenes lógicos
   (Vol.Lógicos > Vol. Físicos)
   [**WIP**] -> 33

4. Todo funciona correctamente
   [**WIP**] -> 0

## Tests de 'nisClient'
## Tests de 'nisServer'
## Tests de 'nfsClient'
## Tests de 'nfsServer'
## Tests de 'backupClient'
## Tests de 'backupServer'
