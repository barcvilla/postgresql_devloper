--  TRIGGERS --
-- Son objetos que nos permiten escuchar eventos transaccionales realizados sobre las tablas de una base de datos. Los triggers se mantienen en escucha de eventos como
-- Insert, Update, Delete

CREATE TABLE productos(
  nombre varchar(20),
  cantidad smallint,
  precio smallint,
  ultima_modificacion timestamp,
  ultimo_usuario_bd text
);

-- En Postgresql antes de crear un TRIGGER, primero se debe crear una Function
-- Variables en los Triggers
-- NEW variable que contiene informacion del nuevo registro que se esta trabajando
-- OLD variable que contiene la informacion del registro anterior a la operacion
-- TG_OP contiene el nombre de la operacion que estamos realizando

CREATE OR REPLACE FUNCTION valida_products()
RETURNS TRIGGER AS
$BODY$
BEGIN
	IF NEW.nombre IS NULL OR length(NEW.nombre) = 0 THEN
		RAISE EXCEPTION 'El nombre debe contener alguna informacion';
	END IF;
	IF NEW.cantidad < 0 THEN
		RAISE EXCEPTION 'La cantidad no puede ser negativa';
	END IF;
	IF NEW.precio < 0 THEN
		RAISE EXCEPTION 'El precio no puede ser negativo';
	END IF;

	NEW.ultima_modificacion = now();
	NEW.ultimo_usuario_bd = user;

	--Retornamos el registro que se intenta insertar, con esta variable ahora podemos hacer la operacion INSERT
	RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;

-- Existe donde momentos en el TRIGGER
-- BEFORE Antes de realizar la accion
-- AFTER Despues de realizar la accion

-- La Captura del RAISE EXCEPTION en Java se realiza mediante SQLException:

CREATE TRIGGER valida_products 
-- indicamos el momento en el que hacemos la validacion (DISPARO DEL TRIGGER y las accion que va analizar el TRIGGER)
BEFORE INSERT OR UPDATE
ON productos
-- El trigger va escuchar por cada registro que tenga la tabla'
FOR EACH ROW EXECUTE PROCEDURE valida_products();

------------------------------

-- Probamos el trigger
SELECT * FROM productos;

INSERT INTO productos (nombre, cantidad, precio) VALUES (null, 10, 1000);

INSERT INTO productos (nombre, cantidad, precio) VALUES ('PAPA', 10, 1000);



