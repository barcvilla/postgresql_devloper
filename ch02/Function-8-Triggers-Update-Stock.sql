-- Trigger Actualizar la cantidad de los productos dependiendo de si compramos o vendemos los productos.
-- Cada vez que realizamos un insert en la tabla de compras deben actualizarse el maestro de productos para reflejar el stock actualizado
-- Cada vez que realizamos una venta de productos se debe realizar una actualizacion (resta) del stock disponible del producto.
-- debe primero validar que exista la cantidad suficiente para realizar la venta.

--5.1
create table compras
(
	consecutivo smallserial,
	fecha date,
	nombre varchar(20),
	cantidad smallint,
	precio smallint
);

--5.2
create table ventas
(
	consecutivo smallserial,
	fecha date,
	nombre varchar(20),
	cantidad smallint,
	precio smallint
);

--5.3 Funcion de compras
create or replace function compra_productos()
returns trigger as
$BODY$
	begin
		--antes de insertar en comprar debemos verificar si el producto existe
		PERFORM nombre from productos where nombre = NEW.nombre; --perform retorna un found or not found
		if FOUND then
			update productos set cantidad = cantidad + NEW.cantidad, precio = NEW.precio where nombre = NEW.nombre;
			
		else
			insert into productos (nombre, cantidad, precio) values (NEW.nombre, NEW.cantidad, NEW.precio);
		
		end if;
		RETURN NEW; -- retornamos el objeto ya sea nuevo o actualizado
		
		-- si el producto existe debemos actualizar su stcok de lo contrario debemos hacer un insert
	end;
$BODY$
language plpgsql;

--5.4 funcion de ventas
create or replace function venta_productos()
returns trigger as
$BODY$
DECLARE --necesitamos crear una fila con el registro que buscamos porque de esa manera podemos usarlo para realizar la validacion
	producto productos%ROWTYPE; --la variable producto es del mismo tipo que una fila de la tabla productos
	begin
		--almacenamos el registro de la tabla productos en nuestra variable producto
		select * into producto from productos where nombre = NEW.nombre;
	
		if FOUND then -- SI ENCONTRO EL PRODUCTO hacemos las validacion
		--verificamos si existe el producto si es true verificamos si hay cantidad suficiente para la venta.
		--si la cantidad es suficiente realizamos la actualizacion del stock del producto
			if producto.cantidad >= NEW.cantidad then
				update productos set cantidad = cantidad - NEW.cantidad where nombre = NEW.nombre;
			else
				raise exception 'No hay suficiente cantidad para la venta: %', producto.cantidad;
			end if;
			RETURN NEW;
		else --NO SE ENCONTRO el producto
			raise exception 'No existe el producto a vender %', NEW.nombre;
		end if;
	end;
$BODY$
language plpgsql;

--5.5 Creamos el trigger de compras
create trigger compra_productos
after insert
on compras
for each row execute procedure compra_productos();

--5.6 Creamos el trigger de ventas
create trigger venta_productos
before insert
on ventas
for each row execute procedure venta_productos();

--5.7 pruebas
select * from productos;
select * from auditoria_productos;
select * from compras;
select * from ventas; 

--5.7.1 Comprando un producto existente
insert into compras (fecha, nombre, cantidad, precio) values (now(), 'YUCA', 1, 1950);

--5.7.2 Comprando un producto que no existe
insert into compras (fecha, nombre, cantidad, precio) values (now(), 'BATATA', 1, 1950);

--5.7.3 Vendiendo un producto que no existe
insert into ventas (fecha, nombre, cantidad, precio) values (now(), 'Frutilla', 10, 800);

--5.7.4 Vendiendo un producto existente pero sin la suficiente cantidad
insert into ventas (fecha, nombre, cantidad, precio) values (now(), 'BATATA', 10, 800);

--5.7.5 Vendiendo un producto con suficiente stock
insert into ventas (fecha, nombre, cantidad, precio) values (now(), 'ARROZ', 10, 2000);

