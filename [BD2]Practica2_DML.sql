/*
INSTRUCCIONES PARA CARGAR LAS TABLAS

#COPIAR ARCHIVOS DE LA CARPETA CARGA EN DOCKER EN LA RUTA home/oracle 
docker cp 'Carga/.' bf97febab64f:home/oracle
----CARGAR EN TEMPORAL CLIENTE
sqlldr userid=bases2/1234 control=cargaCliente.ctl
----CARGAR EN TEMPORAL VENDEDOR
sqlldr userid=bases2/1234 control=cargaVendedor.ctl
----CARGAR EN TEMPORAL FACTURA
sqlldr userid=bases2/1234 control=cargaFactura.ctl
----CARGAR EN TEMPORAL PRODUCTO
sqlldr userid=bases2/1234 control=cargaProducto.ctl
----CARGAR EN TEMPORAL DETALLE
sqlldr userid=bases2/1234 control=cargaDetalle.ctl

*/

/*
-----------------------------> PROCEDIMIENTO PARA INGRESAR EN CARGA CLIENTE
*/

CREATE OR REPLACE PROCEDURE CargaCliente IS
    CURSOR arreglo IS
    SELECT * FROM Temp_Cliente;
    elemento NUMBER := 0;
BEGIN
    FOR i IN arreglo LOOP
        BEGIN
            elemento := elemento + 1;
            INSERT INTO Cliente
            VALUES(i.id_cliente, i.nombre_cliente, i.apellido_cliente, i.direccion_cliente, i.dpi_cliente);                    
        EXCEPTION
          WHEN OTHERS THEN
            INSERT INTO Errores(descripcion, id_obj, elemento)
            VALUES('Cliente', i.id_cliente, elemento);       
        END;
    END LOOP;
END;

BEGIN
    CargaCliente();
    COMMIT;
END;
/*
-----------------------------> PROCEDIMIENTO PARA INGRESAR EN CARGA VENDEDOR
*/

CREATE OR REPLACE PROCEDURE cargaVendedor IS
    CURSOR arreglo IS
    SELECT * FROM Temp_Vendedor;
    elemento NUMBER := 0;
BEGIN
    FOR i IN arreglo LOOP
        BEGIN
            elemento := elemento + 1;
            INSERT INTO Vendedor
            VALUES(i.id_vendedor, i.nombre_vendedor, i.apellido_vendedor, i.correo_vendedor, i.dpi_vendedor);                    
        EXCEPTION
          WHEN OTHERS THEN
            INSERT INTO Errores(descripcion, id_obj, elemento)
            VALUES('Vendedor', i.id_vendedor, elemento);       
        END;
    END LOOP;
END;

BEGIN
    cargaVendedor();
    COMMIT;
END;

/*
-----------------------------> PROCEDIMIENTO PARA INGRESAR EN CARGA FACTURA
*/


CREATE OR REPLACE PROCEDURE cargaFactura IS
    CURSOR arreglo IS
    SELECT * FROM Temp_Factura;
    elemento NUMBER := 0;
BEGIN
    FOR i IN arreglo LOOP
        BEGIN
            elemento := elemento + 1;
            INSERT INTO Factura
            VALUES(i.id_factura, i.id_cliente, i.id_vendedor, i.fecha_factura);                    
        EXCEPTION
          WHEN OTHERS THEN
            INSERT INTO Errores(descripcion, id_obj, elemento)
            VALUES('Factura', i.id_factura, elemento);       
        END;
    END LOOP;
END;

BEGIN
    cargaFactura();
    COMMIT;
END;

/*
-----------------------------> PROCEDIMIENTO PARA INGRESAR EN CARGA PRODUCTO
*/





CREATE OR REPLACE PROCEDURE cargaProducto IS
    CURSOR arreglo IS
    SELECT * FROM Temp_Producto;
    elemento NUMBER := 0;
BEGIN
    FOR i IN arreglo LOOP
        BEGIN
            elemento := elemento + 1;
            INSERT INTO Producto
            VALUES(i.id_producto, i.nombre_producto, i.precio_producto, i.stock_producto);                    
        EXCEPTION
          WHEN OTHERS THEN
            INSERT INTO Errores(descripcion, id_obj, elemento)
            VALUES('Producto', i.id_producto, elemento);       
        END;
    END LOOP;
END;

BEGIN
    cargaProducto();
    COMMIT;
END;

/*
-----------------------------> PROCEDIMIENTO PARA INGRESAR EN CARGA DETALLE
*/


CREATE OR REPLACE PROCEDURE cargaDetalle IS
    CURSOR arreglo IS
    SELECT * FROM Temp_Detalle;
    elemento NUMBER := 0;
BEGIN
    FOR i IN arreglo LOOP
        BEGIN
            elemento := elemento + 1;
            INSERT INTO Detalle(id_factura, id_producto, cantidad, sub_total)
            VALUES(i.id_factura, i.id_producto, i.cantidad, 0.00);
        EXCEPTION
          WHEN OTHERS THEN
            INSERT INTO Errores(descripcion, id_obj, elemento)
            VALUES('Detalle', elemento, elemento);
        END;
    END LOOP;
    UPDATE Detalle D
    SET D.sub_total = D.cantidad*(
        select P.precio_producto 
        from Producto P 
        where P.id_producto = D.id_producto 
        AND ROWNUM = 1
    );
END;

BEGIN
    cargaDetalle();
    COMMIT;
END;


