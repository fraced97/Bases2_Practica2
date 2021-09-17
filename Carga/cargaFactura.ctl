OPTIONS (SKIP=1)
LOAD DATA
CHARACTERSET UTF8
INFILE '/home/oracle/[BD2]Factura.csv'
BADFILE 'cargaFactura.bad'
DISCARDFILE 'cargaFactura.dsc'
TRUNCATE
INTO TABLE Temp_Factura
FIELDS terminated by ','
(
   id_factura,
   id_cliente,
   id_vendedor,
   fecha_factura
)
