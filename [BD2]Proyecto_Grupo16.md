# SISTEMAS DE BASES DE DATOS 2 PROYECTO 1

## Pasos para realizar la replicación de los datos en cada uno de los nodos

### Instalar docker
Dentro de la instancia se instalo docker con el siguiente comando:
* > apt install docker.io

Tambien se instalo docker compose utilizando el siguiente comando:
* > apt install docker-compose

Se creo un archivo docker-compose.yml para asi facilitar la creacion de cada contenedor. Este contiene 
La version
* > version:"2"

Los servicios y en cada servicio se pone el siguiente fragmento.
* > nombre: 
* image:4.2
* restart:always
* container_name: GRUPO16_MONGO_MASTER
* ports: 2090:27017
* entrypoint: [ "/usr/bin/mongod", "--replSet", "bd2_grupo16", "--bind_ip_all"]


En el entrypoint se localiza en el archivo mongod y se habilita la replicacion en mongo y tambien se nombra una red.  
--replSet especifica el nombre del conjunto de réplicas, que almacenará varias instancias de MongoDB, en este caso las replicas tienen de nombre "bd2_grupo16".

--bind_ip_all se utiliza para habilitar y vicular todas las direcciones IPv4, habilita los puertos que esten abierto a cualquier Ip.

Se crea de esta forma cambiando el nombre de contenedor por el respectivo nombre que se indico en el enunciado.

Para ejecutar el docker compose se utilizo el siguiente comando:
* > sudo docker-compose up -d 

Tenindo los contenedores creados y ejecutandose se ingresa en el GRUPO16_MONGO_MASTER utilizando 

* > sudo docker exec -it GRUPO16_MONGO_MASTER

y adentro del contenedor se ejecuta el siguiente comando:

* > mongo

Ahora se crea la red de replicacion donde se va a ejecutar
```
rsconf = {
    _id : "bd2_grupo16",
   members: [
       {
           "_id": 1,
           "host": "GRUPO16_MONGO_01:27017",
           "priority": 1
       },
       {
           "_id": 2,
           "host": "GRUPO16_MONGO_02:27017",
           "priority": 2
       },
       {
           "_id": 3,
           "host": "GRUPO16_MONGO_03:27017",
           "priority": 3
       },
       {
           "_id": 4,
           "host": "GRUPO16_MONGO_04:27017",
           "priority": 4
       },
       {
           "_id": 0,
           "host": "GRUPO16_MONGO_MASTER:27017",
           "priority": 5
       }
   ]
}
```
Despues se ejecuto los siguientes comandos:
* > rs.initiate(rsconf);
* rs.conf();

Estos para verificar que la configuracion si se haya creado correctamente en la red.

Se copiaron los archivos de entrada dentro del contenedor
* > sudo docker cp Bases2_Practica2/countries.json GRUPO16_MONGO_MASTER:/tmp/countries.json
* sudo docker exec GRUPO16_MONGO_MASTER mongoimport -d countries_GRUPO16 -c coleccion1_GRUPO16 --file /tmp/countries.json --jsonArray


Por ultimo de los demas contenedores se ejecuta este comando:

* > rs.secondaryOk();

Para que los esclavos aceptarán ser réplicas.

## Pasos y configuraciones necesarias para realizar un full backup de una base de datos en mongodb

Para la realizacion un backup se escribio el siguiente fragmento.

> * sudo docker exec GRUPO16_MONGO_MASTER sh -c 'mongodump --archive' > backup.dump


Esto mongodump, el modo de archivo permite empaquetar varias colecciones dentro del archivo de forma no contigua.

Para la restauracion se utilizo el siguiente comando.

> * sudo docker exec -i GRUPO16_MONGO_MASTER sh -c 'mongorestore --archive' < backup.dump

mongorestore, permite que se restauren múltiples colecciones.
