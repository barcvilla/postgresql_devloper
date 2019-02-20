-- Creamos la funcion saludar
CREATE OR REPLACE FUNCTION contabilidad.saludar()
-- declaramos el tipo de dato que la funcion retornara
RETURNS character varying
-- palabra clave obligatoria
AS
-- toda funcion en postgres debe incluir $$ al inicio $$ al fin
$$
-- declaramos las variables que utilizara la funcion
DECLARE
	nombre character varying;
-- toda funcion en postgres debe incluir keyword BEGIN y END
BEGIN
	RETURN 'Hola mundo';
END
$$
-- indicemos el tipo del legunaje que utilizara postgres
LANGUAGE plpgsql;

-- Llamamos una funcion en postgres
-- si la funcion retorna varios campos de informacion, podemos indicarlos luego del SELECT
-- si la funcion necesita parametros, dentro de los parentesis indicamos dichos parametros
SELECT contabilidad.saludar();

-- Tambien podemos llamar nuestra funcion dentro de una consulta
SELECT nombre, valor, contabilidad.saludar() from contabilidad.colores;
