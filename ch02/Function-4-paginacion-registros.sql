-- Funcion para paginar los datos retornados por una consulta
-- Formula para encontrar el OFFSET
-- Cantidad de Registros * Nro Pagina que se quiere ver - Cantidad de Registros
CREATE OR REPLACE FUNCTION contabilidad.ventas_paginadas(_registros integer, _pagina integer)
RETURNS SETOF contabilidad.ventas --retorna un conjunto de datos de la tabla ventas
AS
$BODY$
DECLARE
	inicio integer; --declaramos la variable OFFSET
BEGIN
	inicio = _registros * _pagina - _registros;
	RETURN QUERY SELECT consecutivo, producto, cantidad FROM contabilidad.ventas LIMIT _registros OFFSET inicio;
END;
$BODY$
LANGUAGE plpgsql;

--LLamado de la funcion
SELECT * FROM contabilidad.ventas_paginadas(4, 3);
