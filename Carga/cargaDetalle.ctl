OPTIONS (SKIP=1)
LOAD DATA
CHARACTERSET UTF8
INFILE '/home/oracle/[BD2]Detalle.csv'
BADFILE 'cargaDetalle.bad'
DISCARDFILE 'cargaDetalle.dsc'
TRUNCATE
INTO TABLE Temp_Detalle
FIELDS terminated by ','
(
   id_factura,
   id_producto,
   cantidad
)
