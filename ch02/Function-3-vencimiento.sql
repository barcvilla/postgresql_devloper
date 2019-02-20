CREATE OR REPLACE FUNCTION contabilidad.alarma_vencimiento(_fecha date)
RETURNS character varying
AS
$BODY$
DECLARE
	dias integer;
	meses integer;
	total integer;
BEGIN
	-- obtenemos los dias entre la fecha de vencimiento y hoy
	meses = date_part('MONTH', age(_fecha, now()));
	dias = date_part('DAY', age(_fecha, now()));
	total = meses * 30 + dias;
	
	IF total < 60 THEN
		RETURN 'cuidado se vence en menos de 2 meses';
	ELSE
		RETURN 'aun queda tiempo';
	END IF;
END;
$BODY$
LANGUAGE plpgsql;

-- Llamamos a la funcion
SELECT codigo, nombre, valor, vencimiento, contabilidad.alarma_vencimiento(vencimiento) from contabilidad.productos;
