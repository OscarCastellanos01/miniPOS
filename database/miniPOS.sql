-- Tabla productos
CREATE TABLE tbl_Productos(
	producto_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	descripcion_producto VARCHAR(150) NOT NULL,
	precio_venta_producto DECIMAL(10,2) NOT NULL,
	precio_compra_producto DECIMAL(10,2) NOT NULL,
	categoria_id INT NOT NULL,
	imagen_id INT NOT NULL
);

-- Tabla almacenes
CREATE TABLE tbl_Almacenes(
	almacen_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	codigo_almacen INT NOT NULL,
	nombre_almacen VARCHAR(50) NOT NULL
);

-- Tabla inventario
CREATE TABLE tbl_inventario(
	inventario_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	producto_id INT NOT NULL,
	almacen_id INT NOT NULL,
	stock_inventario INT NOT NULL,
	FOREIGN KEY(producto_id) REFERENCES tbl_Productos(producto_id),
	FOREIGN KEY(almacen_id) REFERENCES tbl_Almacenes(almacen_id)
);

-- Tabla traslado de productos entre bodegas
CREATE TABLE tbl_TrasladoProductos(
	traslado_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	producto_id INT NOT NULL,
	almacen_origen INT NOT NULL,
	almacen_destino INT NOT NULL,
	FOREIGN KEY(producto_id) REFERENCES tbl_Productos(producto_id),
	FOREIGN KEY(almacen_origen) REFERENCES tbl_Almacenes(almacen_id),
	FOREIGN KEY(almacen_destino) REFERENCES tbl_Almacenes(almacen_id)
);

-- Tabla ventas
CREATE TABLE tbl_ventas(
	venta_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	unidades_venta INT NOT NULL,
	tipo_documento_id INT NOT NULL,
	documento_venta INT NOT NULL,
	cliente_id INT NOT NULL,
	medio_pago_id INT NOT NULL,
	monto_total_venta DECIMAL(10,2) NOT NULL,
	condicion_venta INT NOT NULL DEFAULT 0
);

-- Tabla detalle de ventas
CREATE TABLE tbl_DetalleVentas(
	detalle_venta_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	venta_id INT NOT NULL,
	producto_id INT NOT NULL,
	cantidad INT NOT NULL,
	FOREIGN KEY(venta_id) REFERENCES tbl_ventas(venta_id),
	FOREIGN KEY(producto_id) REFERENCES tbl_Productos(producto_id)
);

-- ALTER TABLE para la tabla detalle de ventas
ALTER TABLE tbl_DetalleVentas
ADD COLUMN almacen_id INT NOT NULL AFTER producto_id,
ADD CONSTRAINT fk_almacen_id FOREIGN KEY (almacen_id) REFERENCES tbl_Almacenes(almacen_id);

-- Insertar registros en tbl_Productos
INSERT INTO tbl_Productos (descripcion_producto, precio_venta_producto, precio_compra_producto, categoria_id, imagen_id)
VALUES 
('Camiseta', 15.99, 8.50, 1, 1),
('Pantalón', 29.99, 18.50, 2, 2),
('Zapatos', 39.99, 25.00, 3, 3),
('Bufanda', 9.99, 5.50, 1, 4),
('Sombrero', 12.99, 7.50, 2, 5),
('Vestido', 49.99, 35.00, 3, 6),
('Calcetines', 5.99, 2.50, 1, 7),
('Pantalones cortos', 19.99, 12.50, 2, 8),
('Abrigo', 59.99, 45.00, 3, 9),
('Gorra', 7.99, 4.50, 1, 10),
('Falda', 24.99, 15.00, 2, 11),
('Botas', 69.99, 50.00, 3, 12),
('Guantes', 8.99, 3.50, 1, 13),
('Sudadera', 34.99, 22.50, 2, 14),
('Bufanda', 9.99, 5.50, 1, 15),
('Pantalón deportivo', 27.99, 20.00, 2, 16),
('Chaqueta', 54.99, 40.00, 3, 17),
('Gafas de sol', 15.99, 9.50, 1, 18),
('Top', 14.99, 10.00, 2, 19),
('Bolso', 49.99, 30.00, 3, 20);

-- Insertar registros en tbl_Almacenes
INSERT INTO tbl_Almacenes (codigo_almacen, nombre_almacen)
VALUES 
(1001, 'Almacén Central'),
(1002, 'Almacén Norte'),
(1003, 'Almacén Sur'),
(1004, 'Almacén Este'),
(1005, 'Almacén Oeste'),
(1006, 'Almacén Principal'),
(1007, 'Almacén Secundario'),
(1008, 'Almacén Terciario'),
(1009, 'Almacén Cuaternario'),
(1010, 'Almacén Quinario'),
(1011, 'Almacén de Prueba 1'),
(1012, 'Almacén de Prueba 2'),
(1013, 'Almacén de Prueba 3'),
(1014, 'Almacén de Prueba 4'),
(1015, 'Almacén de Prueba 5'),
(1016, 'Almacén de Prueba 6'),
(1017, 'Almacén de Prueba 7'),
(1018, 'Almacén de Prueba 8'),
(1019, 'Almacén de Prueba 9'),
(1020, 'Almacén de Prueba 10');

-- Insertar registros en tbl_inventario
INSERT INTO tbl_inventario (producto_id, almacen_id, stock_inventario)
SELECT 
    producto_id,
    almacen_id,
    FLOOR(RAND() * 100) + 1 AS stock_inventario
FROM 
    tbl_Productos
CROSS JOIN 
    tbl_Almacenes;

-- Insertar registros en tbl_TrasladoProductos
INSERT INTO tbl_TrasladoProductos (producto_id, almacen_origen, almacen_destino)
SELECT 
    producto_id,
    almacen_id,
    (SELECT almacen_id FROM tbl_Almacenes WHERE almacen_id != tbl_inventario.almacen_id ORDER BY RAND() LIMIT 1) AS almacen_destino
FROM 
    tbl_inventario;
-- QUERY CONSULTA STOCK POR ALMACEN
SELECT 
    P.descripcion_producto AS Producto,
    A.nombre_almacen AS Almacen,
    I.stock_inventario AS Stock
FROM 
    tbl_Productos P
JOIN 
    tbl_inventario I ON P.producto_id = I.producto_id
JOIN 
    tbl_Almacenes A ON I.almacen_id = A.almacen_id;

-- QUERY STOCK TOTAL POR PRODUCTO
SELECT 
    P.producto_id,
    P.descripcion_producto AS Producto,
    SUM(I.stock_inventario) AS Stock_Total
FROM 
    tbl_Productos P
JOIN 
    tbl_inventario I ON P.producto_id = I.producto_id
GROUP BY 
    P.producto_id, P.descripcion_producto;
    
-- Crear vista para STOCK POR ALMACEN
CREATE VIEW vista_stock_productos AS
SELECT 
    P.descripcion_producto AS Producto,
    A.nombre_almacen AS Almacen,
    I.stock_inventario AS Stock
FROM 
    tbl_Productos P
JOIN 
    tbl_inventario I ON P.producto_id = I.producto_id
JOIN 
    tbl_Almacenes A ON I.almacen_id = A.almacen_id;

-- Crear vista para STOCK TOTAL POR PRODUCTO
CREATE VIEW vista_stock_total_por_producto AS
SELECT 
    P.producto_id,
    P.descripcion_producto AS Producto,
    SUM(I.stock_inventario) AS Stock_Total
FROM 
    tbl_Productos P
JOIN 
    tbl_inventario I ON P.producto_id = I.producto_id
GROUP BY 
    P.producto_id, P.descripcion_producto;
     

 -- Mostrar contenido de la vista vista_stock_productos
SELECT * FROM vista_stock_productos;

-- Mostrar contenido de la vista vista_stock_total_por_producto
SELECT * FROM vista_stock_total_por_producto;


-- TRIGGER PARA ACTUALIZAR STOCK CUANDO SE REALIZA UNA VENTA
DELIMITER //

CREATE TRIGGER descontar_stock_despues_venta
AFTER INSERT ON tbl_DetalleVentas
FOR EACH ROW
BEGIN
    -- Actualizar el stock en la tabla tbl_inventario
    UPDATE tbl_inventario
    SET stock_inventario = stock_inventario - NEW.cantidad
    WHERE producto_id = NEW.producto_id
    AND almacen_id = NEW.almacen_id;
END;
//

DELIMITER ;
