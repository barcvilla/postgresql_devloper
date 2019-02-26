-- TIPOS DE DATOS EN LAS FUNCTIONS: Sesportan todos los tipos de datos utilizados dentro de Postgres. Pero tambien existen "tipos de datos especiales" como:
-- %TYPE : se utiliza cuando necesitamos un tipo de datos exactamente igual a un campo de una tabla
-- 	Ejemplo %TYPE
--	DECLARE 
--		mi_variable contabilidad.productos.nombre%TYPE; (mi_variable tendra el mismo tipo y longitud de datos que posee el campo nombre de la tabla productos)

-- %ROWTYPE : Nos permite almacenar la informacion de todo un registro (fila) en una sola variable
--	Ejemplo %ROWTYPE
--	DECLARE
--		mi_variable contabilidad.productos%ROWTYPE
--	Como obtenemos el valor de un campo dentro de una variable %ROWTYPE?
--		mi_variable.valor (valor es el nombre de un campo dentro del registro)

-- CICLOS (FOR, WHILE) : Nos permiten repetir un proceso varias veces
CREATE OR REPLACE FUNCTION contabilidad.repetir_for()
RETURNS void --se muestra resultado solo por consola
AS
$BODY$
DECLARE iteracion integer;
BEGIN
	FOR iteracion IN 1..10 LOOP
		RAISE NOTICE 'voy en la iteracion: %', iteracion;
	END LOOP;
END
$BODY$
LANGUAGE plpgsql;

--Llamamos a la funcion
SELECT contabilidad.repetir_for();


-- CREAMOS UNA FUNCION PARA RECORRER UN SELECT
CREATE OR REPLACE FUNCTION contabilidad.obtener_ventas()
RETURNS SETOF contabilidad.ventas
AS
$BODY$
DECLARE
	fila contabilidad.ventas%ROWTYPE;
BEGIN
	-- almacenamos los registros en un cursos llamado fila
	FOR fila IN SELECT * FROM contabilidad.ventas LOOP
		--fila.valor = fila.valor * 3;
		RETURN NEXT fila;
	END LOOP;
END
$BODY$
LANGUAGE plpgsql;

SELECT * FROM contabilidad.obtener_ventas();

-- CICLO WHILE : Se ejecuta MIENTRAS (WHILE) la condicion se cumpla
CREATE OR REPLACE FUNCTION contabilidad.mientras()
RETURNS void
AS
$BODY$
DECLARE
	valor INTEGER;
BEGIN
	valor = 5;
	WHILE valor < 50 LOOP
		RAISE NOTICE 'valor numero: %', valor;
		valor = valor + 10;
	END LOOP;
END
$BODY$
LANGUAGE plpgsql;

SELECT * FROM contabilidad.mientras();


-- CREAR UN PROCEDIMIENTO DE AUDITORIA
-- CREACION DE LA TABLA AUDITORIA
CREATE TABLE contabilidad.auditoria
(
	consecutivo smallserial,
	nombre varchar(20),
	accion varchar(50),
	fecha timestamp DEFAULT now(),
	CONSTRAINT "pk_consecutivo" PRIMARY KEY(consecutivo)
);

-- PROCEDIMIENTO DONDE CADA VEZ QUE LA PERSONA CONSULTE LA TABLA SE INSERTE LA AUDITORIA
CREATE OR REPLACE FUNCTION contabilidad.fn_mostrar_ventas(_nombre character varying)
RETURNS SETOF contabilidad.ventas
AS
$BODY$
BEGIN
	-- REGISTRAMOS LA AUDIORIA
	INSERT INTO contabilidad.auditoria(consecutivo, nombre, accion, fecha)
	VALUES(DEFAULT, _nombre, 'consulta ventas', DEFAULT);
	-- RETORNO LO SOLICITADO
	RETURN QUERY SELECT * FROM contabilidad.ventas;
END
$BODY$
LANGUAGE plpgsql;

--LLAMADO DE LS FUNCION
SELECT * FROM contabilidad.auditoria;

SELECT * FROM contabilidad.fn_mostrar_ventas('Barcvilla');

