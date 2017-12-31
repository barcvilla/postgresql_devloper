-- Vistas Materializadas ---
-- Vista materailizada de solo lectura.
create materialized view suppliers_matview as select * from suppliers;

-- Vista Materializable Actualizable
create materialized view suppliers_matview for update 
as select * from suppliers;
