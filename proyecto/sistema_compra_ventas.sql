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
	return query select a.id_usuarios, a.nombre, b.id_perfil, b.perfil from usuarios as a natural join perfiles as b
	where a.usuarios = _usuarios and a.clave = md5(_clave);
	if not found then
		raise exception 'El usuario o password no coincide';
	end if;
end;
$body$
language plpgsql;
alter function consulta_terceros() owner to escueladigital;
