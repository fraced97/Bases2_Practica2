OPTIONS (SKIP=1)
LOAD DATA
CHARACTERSET UTF8
INFILE '/home/oracle/[BD2]Cliente.csv'
BADFILE 'cargaCliente.bad'
DISCARDFILE 'cargaCliente.dsc'
TRUNCATE
INTO TABLE Temp_Cliente
FIELDS terminated by ','
(
   id_cliente,
   nombre_cliente,
   apellido_cliente,
   direccion_cliente,
   dpi_cliente
)
