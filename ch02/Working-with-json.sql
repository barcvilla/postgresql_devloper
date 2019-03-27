insert into minosql(informacion) values('{"codigo": "003","nombre": "CAMOTE","cantidad": "30","precio": "1500"}');

select * from minosql;

-- consultar informacion de tipo json
-- QUEREMOS EL OBJETO nombre y cantidad (hacemos un cast :: de la cantidad) DEL OBJETO JSON INFORMACION
select informacion->>'nombre' as producto, informacion->>'cantidad' as cantidad from minosql where informacion->>'nombre' = 'PAPA';

-- Auditoria usando json
create table auditoria
(
	consecutivo serial,
	accion varchar(150),
	fecha timestamp,
	idusuario smallint,
	tabla varchar(100),
	antes json,
	despues json
);