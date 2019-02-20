-- Function Descuento
CREATE OR REPLACE FUNCTION contabilidad.descuentofijo(_valor integer)
RETURNS real
AS
$BODY$
DECLARE
	nuevo_valor real;
BEGIN
	nuevo_valor = _valor * .9;
	RETURN nuevo_valor;
END
$BODY$
LANGUAGE plpgsql;

-- Llamado de funcion
SELECT codigo, nombre, valor, contabilidad.descuentofijo(valor), vencimiento from contabilidad.productos;
