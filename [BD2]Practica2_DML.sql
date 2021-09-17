/*
#Copiar achivos de carpeta Carga P2 a docker home/oracle 
docker cp 'Carga P2/.' 2d76b0603cab:home/oracle

sqlldr userid=bases2/1234 control=cargaCliente.ctl
sqlldr userid=bases2/1234 control=cargaVendedor.ctl
sqlldr userid=bases2/1234 control=cargaFactura.ctl
sqlldr userid=bases2/1234 control=cargaProducto.ctl
sqlldr userid=bases2/1234 control=cargaDetalle.ctl
*/

CREATE OR REPLACE PROCEDURE CargaCliente IS
    CURSOR punto IS
    SELECT * FROM Temp_Cliente;
    fila NUMBER := 0;
BEGIN
    FOR i IN punto LOOP
        BEGIN
            fila := fila + 1;
            INSERT INTO Cliente
            VALUES(i.id_cliente, i.nombre_cliente, i.apellido_cliente, i.direccion_cliente, i.dpi_cliente);                    
        EXCEPTION
          WHEN OTHERS THEN
            INSERT INTO Errores(descripcion, id_obj, fila)
            VALUES('Carga cliente', i.id_cliente, fila);       
        END;
    END LOOP;
END;

BEGIN
    CargaCliente();
    COMMIT;
END;

SELECT COUNT(*) FROM Temp_Cliente; --1000
SELECT COUNT(*) FROM Cliente; --972
SELECT COUNT(*) FROM Errores; --28



CREATE OR REPLACE PROCEDURE cargaVendedor IS
    CURSOR punto IS
    SELECT * FROM Temp_Vendedor;
    fila NUMBER := 0;
BEGIN
    FOR i IN punto LOOP
        BEGIN
            fila := fila + 1;
            INSERT INTO Vendedor
            VALUES(i.id_vendedor, i.nombre_vendedor, i.apellido_vendedor, i.correo_vendedor, i.dpi_vendedor);                    
        EXCEPTION
          WHEN OTHERS THEN
            INSERT INTO Errores(descripcion, id_obj, fila)
            VALUES('Carga vendedor', i.id_vendedor, fila);       
        END;
    END LOOP;
END;

BEGIN
    cargaVendedor();
    COMMIT;
END;

SELECT COUNT(*) FROM Temp_Vendedor; --1000
SELECT COUNT(*) FROM Vendedor; --934
SELECT COUNT(*) FROM Errores; --66 --94


CREATE OR REPLACE PROCEDURE cargaFactura IS
    CURSOR punto IS
    SELECT * FROM Temp_Factura;
    fila NUMBER := 0;
BEGIN
    FOR i IN punto LOOP
        BEGIN
            fila := fila + 1;
            INSERT INTO Factura
            VALUES(i.id_factura, i.id_cliente, i.id_vendedor, i.fecha_factura);                    
        EXCEPTION
          WHEN OTHERS THEN
            INSERT INTO Errores(descripcion, id_obj, fila)
            VALUES('Carga factura', i.id_factura, fila);       
        END;
    END LOOP;
END;

BEGIN
    cargaFactura();
    COMMIT;
END;

SELECT COUNT(*) FROM Temp_Factura; --1000
SELECT COUNT(*) FROM Factura; --911
SELECT COUNT(*) FROM Errores; --89 --183




CREATE OR REPLACE PROCEDURE cargaProducto IS
    CURSOR punto IS
    SELECT * FROM Temp_Producto;
    fila NUMBER := 0;
BEGIN
    FOR i IN punto LOOP
        BEGIN
            fila := fila + 1;
            INSERT INTO Producto
            VALUES(i.id_producto, i.nombre_producto, i.precio_producto, i.stock_producto);                    
        EXCEPTION
          WHEN OTHERS THEN
            INSERT INTO Errores(descripcion, id_obj, fila)
            VALUES('Carga producto', i.id_producto, fila);       
        END;
    END LOOP;
END;

BEGIN
    cargaProducto();
    COMMIT;
END;

SELECT COUNT(*) FROM Temp_Producto; --323
SELECT COUNT(*) FROM Producto; --307
SELECT COUNT(*) FROM Errores; --16 --199


CREATE OR REPLACE PROCEDURE cargaDetalle IS
    CURSOR punto IS
    SELECT * FROM Temp_Detalle;
    fila NUMBER := 0;
BEGIN
    FOR i IN punto LOOP
        BEGIN
            fila := fila + 1;
            INSERT INTO Detalle(id_factura, id_producto, cantidad, sub_total)
            VALUES(i.id_factura, i.id_producto, i.cantidad, 0.00);
        EXCEPTION
          WHEN OTHERS THEN
            INSERT INTO Errores(descripcion, id_obj, fila)
            VALUES('Carga detalle', fila, fila);
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

SELECT COUNT(*) FROM Temp_Detalle; --1999
SELECT COUNT(*) FROM Detalle;
SELECT COUNT(*) FROM Errores;

