# Tests

**NOTA**: Desinstalar los servicios que se hayan instalado cada vez que se ejecuten los tests.

X. *TEST* -> [**FICHERO/S**] *Código de error*

## Tests comunes (los tres primeros campos de TESTS en run-tests.sh)
1. No proporcionar el fichero de config como argumento -> 1
2. El fichero de config no existe -> 2
3. El fichero de config es un directorio (no un fichero) -> 2

## Tests triviales (tests-triviales)
1. Una de las líneas del fichero no sigue el formato esperado (!= 3 argumentos) [**wrong-format.txt**] -> 3
2. Un fichero de config de un servicio no existe [**missing-file.txt**] -> 4
3. Uno de los servicio no se reconoce (distinto de los que se han implementado) [**unknown-service.txt**] -> 5

---

## Test comunes de cada servicio
1. El formato del fichero de config de un servicio es incorrecto -> 6
   (el número de campos no es el esperado)

## Tests de 'mount'
1. El dispositivo a montar no existe -> 8
2. El dispositivo a montar no es un directorio vacío -> 9
3. El punto de montaje no existe (se tiene que crear) -> 0
4. El punto de montaje existe y todo funciona correctamente. -> 0

## Tests de 'raid'
1. El nivel de RAID proporcionado no está soportado (!= 0|1|5|6|10) -> 13
2. Todos los campos son correctos y todo funciona correctamente. -> 0

## Tests de 'lvm'
1. Uno de los dispositivos a montar no existe -> 8
2. Exceder el tamaño del grupo al crear los volúmenes lógicos -> 16
   (Vol.Lógicos > Vol. Físicos)
3. Todo funciona correctamente. -> 0
