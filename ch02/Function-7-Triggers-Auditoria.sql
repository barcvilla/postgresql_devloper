-- Vamos a escuchar cuando se inserta, modifica y borra informacion y sera almacenada en la Tabla de Auditorias
-- 1. Creacion de Tabla de Auditorias 
CREATE TABLE auditoria_productos(
  accion varchar(20),
  fecha timestamp,
  nombre varchar(20),
  cantidad smallint,
  precio smallint
);

-- 2. Creamos la funcion de auditoria
CREATE OR REPLACE FUNCTION auditoria_productos()
RETURNS TRIGGER 
AS
$BODY$
BEGIN
	IF TG_OP = 'INSERT' THEN
		INSERT INTO auditoria_productos (accion, fecha, nombre, cantidad, precio) VALUES('INSERTAR', now(), NEW.nombre, NEW.cantidad, NEW.precio);
		RETURN NEW;
	ELSIF TG_OP = 'DELETE' THEN
		INSERT INTO auditoria_productos (accion, fecha, nombre, cantidad, precio) VALUES ('BORRAR', now(), OLD.nombre, OLD.cantidad, OLD.precio);
		RETURN NULL;
	ELSIF TG_OP = 'UPDATE' THEN
		INSERT INTO auditoria_productos (accion, fecha, nombre, cantidad, precio) VALUES ('ANTES ACTUALIZAR', now(), OLD.nombre, OLD.cantidad, OLD.precio);
		INSERT INTO auditoria_productos (accion, fecha, nombre, cantidad, precio) VALUES ('DESPUES ACTULIZAR', now(), NEW.nombre, NEW.cantidad, NEW.precio);
		RETURN NEW;
	END IF;
END;
$BODY$
LANGUAGE plpgsql;

-- 3. CREAR TRIGGER
CREATE TRIGGER auditoria_productos
AFTER INSERT OR UPDATE OR DELETE -- Se ejecuta la funcion de Insert en la auditoria despues que se realice un INSERT OR UPDATE OR DELETE en la tabla productos
ON productos
FOR EACH ROW EXECUTE PROCEDURE auditoria_productos();

-- 4. Prueba de Trigger
SELECT * FROM PRODUCTOS;
SELECT * FROM AUDITORIA_PRODUCTOS;

-- 4.1 INSERTAR
INSERT INTO PRODUCTOS (nombre, cantidad, precio) VALUES ('YUCA', 5, 1900);

INSERT INTO PRODUCTOS (nombre, cantidad, precio) VALUES ('CARNE', 40, 3500); 

INSERT INTO PRODUCTOS (nombre, cantidad, precio) VALUES ('ARROZ', 22, 2200);

-- 4.2 BORRAR
DELETE FROM productos WHERE nombre = 'PAPA';

-- 4.3 ACTUALIZAR
UPDATE productos SET cantidad = 20 WHERE nombre = 'CARNE';


