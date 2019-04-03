-- Proyecto Compras Ventas
-- 1. Creacion Usuario
create user escueladigital password 'escueladigital';

-- 2. Creacion del Tablespace: La ruta: C:\PostgreSQL\escuela
create tablespace ts_escuela owner escueladigital location E'C:\\PostgreSQL\\escuela';

-- 3. Creacion de la Base de Datos
create database escueladigital owner = escueladigital tablespace = ts_escuela;

-- 4. Nos conectamos con el usuario escueladigital
-- 5. Creacion Table Perfiles
create table perfiles
(
	id_perfil smallserial,
	perfil varchar(20) not null,
	constraint "pk_perfiles" primary key(id_perfil),
	constraint "uk_perfiles" unique(perfil)
);

-- 6. Creacion Table usuarios
create table usuarios
(
	id_usuario smallserial,
	usuario varchar(20) not null,
	nombre varchar(100) not null,
	clave varchar(32) not null,
	id_perfil smallint,
	constraint pk_usuarios primary key(id_usuario),
	constraint uk_usuarios unique(usuario),
	constraint fk_usuarios foreign key(id_perfil) references perfiles(id_perfil) on update restrict on delete restrict
);

-- 7. Creacion Table terceros
create table terceros
(
	id_tercero smallserial,
	identificacion varchar(20) not null, --usamos varchar ya que no realizaremos calculo numerico con este campo
	nombre varchar(100) not null,
	direccion varchar(100) not null,
	telefono varchar(20) not null,
	constraint pk_terceros primary key(id_tercero),
	constraint uk_terceros unique(identificacion)
);

-- 8. Creacion Table productos
create table productos
(
	id_producto smallserial,
	nombre varchar(20) not null,
	cantidad smallint,
	precio smallint,
	id_usuario smallint,
	constraint pk_productos primary key(id_producto),
	constraint uk_productos unique(nombre),
	constraint fk_productos_usuarios foreign key(id_usuario) references usuarios(id_usuario) on update restrict on delete restrict,
	constraint ck_cantidad check(cantidad > 0),
	constraint ck_precio check(precio > 0)
);

-- 9. Creacion Table compras
create table compras
(
	id_compra smallserial,
	fecha date default now() not null,
	id_tercero smallint not null,
	id_producto smallint not null,
	cantidad smallint not null,
	valor smallint not null,
	id_usuario smallint not null,
	constraint pk_compras primary key(id_compra),
	constraint fk_compras_terceros foreign key(id_tercero) references terceros(id_tercero) on update restrict on delete restrict,
	constraint fk_compras_productos foreign key(id_producto) references productos(id_producto) on update restrict on delete restrict,
	constraint ck_compras_valor check(valor > 0),
	constraint fk_compras_usuario foreign key(id_usuario) references usuarios(id_usuario) on update restrict on delete restrict
);

-- 10. Creacion Table ventas
create table ventas
(
	id_venta smallserial,
	fecha date default now() not null,
	id_tercero smallint not null,
	id_producto smallint not null,
	cantidad smallint not null,
	valor smallint not null,
	id_usuario smallint not null,
	constraint pk_ventas primary key(id_venta),
	constraint fk_ventas_terceros foreign key(id_tercero) references terceros(id_tercero) on update restrict on delete restrict,
	constraint fk_ventas_productos foreign key(id_producto) references productos(id_producto) on update restrict on delete restrict,
	constraint ck_ventas_valor check(valor > 0),
	constraint fk_ventas_usuario foreign key(id_usuario) references usuarios(id_usuario) on update restrict on delete restrict
);

-- 11 Creacion Table auditoria
create table auditoria
(
	id_auditoria smallserial,
	fecha timestamp not null default now(),
	id_usuario smallint not null,
	accion varchar(20) not null,
	tabla varchar(20) not null,
	anterior json not null,
	nuevo json,
	constraint pk_audtoria primary key(id_auditoria),
	constraint fk_auditoria_usuarios foreign key(id_usuario) references usuarios(id_usuario) on update restrict on delete restrict
);

-- 12. Insercion de datos basicos

-- Perfiles
insert into perfiles(perfil) values('ADMINISTRADOR'), ('CAJERO');

-- Usuarios
insert into usuarios(usuario, nombre, clave, id_perfil) values
('alozada', 'Alexys Lozada', md5('clave123+'), 1),('vendedor', 'Pedro Perez', md5('clave123+'), 2);

-- Terceros
insert into terceros(identificacion, nombre, direccion, telefono) values
('123456789', 'Proveedor LTDA', 'CRA 1 #2 - 3', '2114477 EXT 123'), 
('987654321', 'CompraTodo S.A.S', 'Av. Busquela CRA Encuentrela', '4857965'), 
('741852963', 'Cliente Frecuente', 'El Vecino', '5478414');

-- Productos
insert into productos(nombre, cantidad, precio, id_usuario) values
('Nevera', 5, 12000, 1), ('Lavadora', 1, 8900, 2), ('Secadora', 3, 7400, 1), ('Calentador', 1, 3200, 2);

-- Creacion de funciones basicas
-- Funcion de Consulta de Terceros
create or replace function consulta_terceros() -- sin parametros
returns setof terceros as -- retornamos un conjunto de registros terceros, si no queremos retornar nada indicamos un void. Si en return menciono una tabla en este caso terceros, en el select debo indicar todos los campos de la tabla y en el mismo orden
$body$
begin
	return query select id_terceros, nombre from terceros order by nombre;
end;
$body$
language plpgsql;
alter function consulta_terceros() owner to escueladigital;

-- Funcion de Autenticacion
create or replace function autenticacion(_usuario character varying, _clave character varying)
returns table(id_usuario smallint, nombre character varying, id_perfil smallint, perfil character varying) as
$body$
begin
	return query select a.id_usuario, a.nombre, b.id_perfil, b.perfil from usuarios as a natural join perfiles as b
	where a.usuario = _usuario and a.clave = md5(_clave);
	if not found then
		raise exception 'El usuario o password no coincide';
	end if;
end;
$body$
language plpgsql;
alter function autenticacion(_usuario character varying, _clave character varying) owner to escueladigital;

-- Llamada de la funcion autenticacion desde un Backend
select id_usuario, nombre, id_perfil, perfil from autenticacion('alozada', 'clave123+')

-- Realizacion de Auditoria: En este utilizamos triggers ya que no tenemos certeza cuando se realice un INSERT, DELETE O UPDATE de la informacion en las tablas
-- Funcion Trigger para Auditoria de Productos
CREATE OR REPLACE FUNCTION tg_productos_auditoria()
RETURNS TRIGGER AS
$BODY$
BEGIN
	IF TG_OP = 'UPDATE' THEN
		INSERT INTO auditoria (id_usuario, accion, tabla, anterior, nuevo)
		SELECT NEW.id_usuario, 'ACTUALIZAR', 'PRODUCTO', row_to_json(OLD.*), row_to_json(NEW.*);
	END IF;
	RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;

-- TRIGGER AUDITORÍA PRODUCTOS
CREATE TRIGGER tg_productos_auditoria
AFTER UPDATE ON productos
FOR EACH ROW EXECUTE PROCEDURE tg_productos_auditoria();


-- Funcion Trigger para Auditoria de Compras
create or replace function tg_compras_auditoria()
returns trigger as
$body$
begin
	if tg_op = 'INSERT' then --cuando se realiza un update
		insert into auditoria(id_usuario, accion, tabla, anterior, nuevo)
		select NEW.id_usuario, 'insertar', 'compras', row_to_json(NEW.*), null;
	end if;
	return NEW;
end;
$body$
language plpgsql;
alter function tg_compras_auditoria() owner to escueladigital;

-- Trigger Auditoria de Compras
create trigger tg_compras_auditoria
after insert on compras
for each row execute procedure tg_compras_auditoria();

-- Funcion Comprar
-- retorna idcomprar o factura de compra que genera el sistema
create or replace function comprar(_proveedor smallint, _producto smallint, _cantidad smallint, _valor smallint, _usuario smallint)
returns smallint as 
$body$
declare 
	_idfactura smallint;
begin
	-- Insertamos el registro de compras. Returning nos puede retornar todo el registro que se esta insertando
	insert into compras(id_tercero, id_producto, cantidad, valor, id_usuario)
	values(_proveedor, _producto, _cantidad, _valor, _usuario) returning id_compra into _idfactura;
	-- En postgres si una accion select, insert, update, delete se realiza exitosamente found es true
	if found then
		-- se actualiza el stock
		update productos set cantidad = cantidad + _cantidad, precio = _valor, id_usuario = _usuario where id_producto = _producto;
	else
		raise exception 'No fue posible insertar el registro de compras';
	end if;
	return _idfactura;
end;
$body$
language plpgsql;
alter function comprar(_cliente smallint, _producto smallint, _cantidad smallint, _valor smallint, _usuario smallint) owner to escueladigital;

-- Funcion Trigger para la Auditoria de Ventas
create or replace function tg_ventas_auditoria()
returns trigger as
$body$
begin
	if tg_op = 'INSERT' then
		insert into auditoria(id_usuario, accion, tabla, anterior, nuevo)
		select NEW.id_usuario, 'Insertar', 'Ventas', row_to_json(NEW.*), null;
	end if;
	return NEW;
end;
$body$
language plpgsql;
alter function tg_ventas_auditoria() owner to escueladigital;

-- Trigger de Auditoria de Ventas
create trigger tg_ventas_auditoria
after insert on ventas
for each row execute procedure tg_ventas_auditoria();

-- Funcion de Ventas
create or replace function vender(_cliente smallint, _producto smallint, _cantidad smallint, _usuario smallint)
returns smallint as
$body$
declare
	_valor smallint; --almacenamos el valor de venta
	_existencia smallint; --nos permite saber si tenemos el suficiente stock para vender
	_idfactura smallint; -- variable que almacena la factura de venta
begin
	-- se busca el precio de venta y se valida si hay stock de ventas
	-- al precio le aumentamos el 30%, si el resultado es de tipo double o real se realiza un CAST para convertir el valor a tipo entero
	select cast(precio * 1.3 as smallint), cantidad
	-- _valor almacena precio * 1.3
	-- _existencia almacena cantidad
	-- strict nos permite asegurarnos que nos devolvera un solo registro
	into strict _valor, _existencia from productos where id_producto = _producto;

	-- si hay suficiente stock
	if _existencia >= _cantidad then
		-- se inserta el registro de ventas
		insert into ventas(id_tercero, id_producto, cantidad, valor, id_usuario) values(_cliente, _producto, _cantidad, _valor, _usuario)
		returning id_venta into _idfactura; --retornamos el id_venta y lo guardamos en _idfactura
		-- found significa: si la sentencia previa se ejecuto exitosamente
		if found then
			--se actualiza el stock del producto
			update productos set cantidad = cantidad - _cantidad, id_usuario = _usuario where id_producto = _producto;
		else
			raise exception 'no fue posible insertar el registro de ventas %';
		end if;
	else
		raise exception 'No existe suficiente cantidad para la venta %', _existencia;
	end if;
	
	return _idfactura;

	exception
	-- lanzamos excepcion cuando no se encuentra informacion del select cast(precio * 1.3 as smallint), cantidad
	when NO_DATA_FOUND then
		raise exception 'No se encontro el producto a vender';
end;
$body$
language plpgsql;
alter function vender(_cliente smallint, _producto smallint, _cantidad smallint, _usuario smallint) owner to escueladigital;

-- Funciones de Consulta con Paginacion
-- Consulta Ventas
create or replace function consulta_ventas(_limite smallint, _pagina smallint)
returns table(id_venta smallint, fecha date, cliente character varying, producto character varying, cantidad smallint, valor smallint)
as
$body$
declare
	_inicio smallint;
begin
	_inicio = _limite * _pagina - _limite;
	
	return query select v.id_venta, v.fecha, t.nombre as proveedor, p.nombre as producto, v.cantidad, v.valor from ventas as v
	inner join terceros as t on v.id_tercero = t.id_tercero
	inner join productos as p on v.id_producto = p.id_producto
	limit _limite -- en mysql basta con colocar limit _limite, _inicio para hacer la pagiacion
	offset _inicio;	
end;
$body$
language plpgsql;
alter function consulta_ventas(_limite smallint, _pagina smallint) owner to escueladigital;

-- Consulta de Compras
create or replace function consulta_compras(_limite smallint, _pagina smallint)
returns table(id_compra smallint, fecha date, cliente character varying, producto character varying, cantidad smallint, valor smallint)
as
$body$
declare
	_inicio smallint;
begin
	_inicio = _limite * _pagina - _limite;

	return query select c.id_compra, c.fecha, t.nombre as cliente, p.nombre as producto, c.cantidad, c.valor from compras as c
	inner join terceros as t on c.id_tercero = t.id_tercero
	inner join productos as p on c.id_producto = p.id_producto
	limit _limite
	offset _inicio;
end;
$body$
language plpgsql;
alter function consulta_compras(_limite smallint, _pagina smallint) owner to escueladigital;

-- Consulta Inventario actual
create or replace function consulta_inventario(_limite smallint, _pagina smallint)
returns setof productos as
$body$
declare
	_inicio smallint;
begin
	_inicio = _limite * _pagina - _limite;
	return  query select id_producto, nombre, cantidad, precio, id_usuario from productos order by id_producto limit _limite offset _inicio;
end;
$body$
language plpgsql;
alter function consulta_inventario(_limite smallint, _pagina smallint) owner to escueladigital;

-- Prueba de las funciones
select * from ventas;
select * from compras;
select * from productos;
select * from terceros;
select * from auditoria;

-- Simulamos llamadas desde el Backend
-- Ejecutamos la funcion comprar. Esta funcion me retorna un numero por esa razon no utilizamos * from 
-- Comprar(id_tercero, id_producto, cantidad, valor, id_usuario)
select comprar(2::smallint, 2::smallint, 1::smallint, 13500::smallint, 2::smallint);

select vender(1:: smallint, 1::smallint, 2::smallint, 1::smallint);