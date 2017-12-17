-- building data tables
create table suppliers
(
supplier_id integer primary key,
supplier_name varchar(30),
phone_number integer
);
-------------

insert into suppliers(supplier_id, supplier_name, phone_number) values
(1, 'XYZ COMPANY', 11111111), (2, 'XXX SUP', 222222), (3, 'YYY COMPANY', 3333333);

-----------------------------------------------------

create table orders
(
order_number integer primary key,
supplier_id integer references suppliers(supplier_id),
quantity integer,
is_active varchar(10),
price decimal
);
---------------

insert into orders(order_number, supplier_id, quantity, is_active, price)values
(1, 1, 10, 'TRUE', 1000), (2, 1, 30, 'TRUE', 1560.50), (3, 1, 5, 'TRUE', 500), (4, 2, 7, 'TRUE', 5930), (5, 3, 8, 'FALSE', 33.33);

----------------------------------------------------------------------------------------------------------
 
create view active_supplier_orders as
select suppliers.supplier_id, suppliers.supplier_name, orders.quantity, orders.price
from suppliers
inner join orders
on suppliers.supplier_id = orders.supplier_id
where suppliers.supplier_name = 'XYZ COMPANY'
and orders.is_active = 'TRUE';
------------------------------------------------

-- Llamando a una vista

select * from active_supplier_orders;

-- Eliminando una vista: drop view if exists active_supplier_orders

-- Modificando un objeto view y añadiento mas columnas.

create or replace view active_supplier_orders as
select suppliers.supplier_id, suppliers.supplier_name, orders.quantity, orders.price, orders.order_number
from suppliers
inner join orders
on suppliers.supplier_id = orders.supplier_id
where suppliers.supplier_name = 'XYZ COMPANY'
and orders.is_active = 'TRUE';

-- llamando al objeto view
select * from active_supplier_orders;
