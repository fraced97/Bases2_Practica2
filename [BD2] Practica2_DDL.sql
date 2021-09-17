CREATE TABLE Cliente(
    id_cliente          INT NOT NULL,
    nombre_cliente      VARCHAR(50) NOT NULL,
    apellido_cliente    VARCHAR(50) NOT NULL,
    direccion_cliente   VARCHAR(50) NOT NULL,
    dpi_cliente         VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_cliente)
);

CREATE TABLE Vendedor(
    id_vendedor          INT NOT NULL,
    nombre_vendedor      VARCHAR(50) NOT NULL,
    apellido_vendedor    VARCHAR(50) NOT NULL,
    correo_vendedor      VARCHAR(50) NOT NULL,
    dpi_vendedor         VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_vendedor)
);

CREATE TABLE Factura(
    id_factura          INT NOT NULL,
    id_cliente          INT NOT NULL,
    id_vendedor         INT NOT NULL,
    fecha_factura       DATE NOT NULL,
    PRIMARY KEY (id_factura),
    CONSTRAINT fk_id_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente) ON DELETE CASCADE,
    CONSTRAINT fk_id_vendedor FOREIGN KEY (id_vendedor) REFERENCES Vendedor(id_vendedor) ON DELETE CASCADE
);

CREATE TABLE Producto(
    id_producto          INT NOT NULL,
    nombre_producto      VARCHAR(30) NOT NULL,
    precio_producto      FLOAT NOT NULL,
    stock_producto       INT NOT NULL,
    PRIMARY KEY (id_producto)
);

CREATE TABLE Detalle(
    id_detalle          INT GENERATED ALWAYS AS IDENTITY,
    id_factura          INT NOT NULL,
    id_producto         INT NOT NULL,
    cantidad            INT NOT NULL,
    sub_total           FLOAT NOT NULL,
    PRIMARY KEY (id_detalle),
    CONSTRAINT fk_id_factura FOREIGN KEY (id_factura) REFERENCES Factura(id_factura) ON DELETE CASCADE,
    CONSTRAINT fk_id_producto FOREIGN KEY (id_producto) REFERENCES Producto(id_producto) ON DELETE CASCADE
);


CREATE TABLE Errores(
    id_mal          INT GENERATED ALWAYS AS IDENTITY,
    descripcion     VARCHAR(50) NOT NULL,
    id_obj          VARCHAR(50) NOT NULL,
    fila            INT NOT NULL
);

CREATE TABLE Temp_Cliente(
    id_cliente          INT ,
    nombre_cliente      VARCHAR(50) ,
    apellido_cliente    VARCHAR(50) ,
    direccion_cliente   VARCHAR(50) ,
    dpi_cliente         VARCHAR(50) 
);

CREATE TABLE Temp_Vendedor(
    id_vendedor          INT,
    nombre_vendedor      VARCHAR(50),
    apellido_vendedor    VARCHAR(50),
    correo_vendedor      VARCHAR(50),
    dpi_vendedor         VARCHAR(50)
);

CREATE TABLE Temp_Factura(
    id_factura          INT,
    id_cliente          INT,
    id_vendedor         INT,
    fecha_factura       DATE
);

CREATE TABLE Temp_Producto(
    id_producto          INT,
    nombre_producto      VARCHAR(30),
    precio_producto      FLOAT,
    stock_producto       INT
);

CREATE TABLE Temp_Detalle(
    id_factura          INT,
    id_producto         INT,
    cantidad            INT
);
