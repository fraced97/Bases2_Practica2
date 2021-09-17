OPTIONS (SKIP=1)
LOAD DATA
CHARACTERSET UTF8
INFILE '/home/oracle/[BD2]Producto.csv'
BADFILE 'cargaProducto.bad'
DISCARDFILE 'cargaProducto.dsc'
TRUNCATE
INTO TABLE Temp_Producto
FIELDS terminated by ','
(
   id_producto,
   nombre_producto,
   precio_producto,
   stock_producto
)
