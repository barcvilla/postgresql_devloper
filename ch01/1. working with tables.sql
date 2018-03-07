create table product
(
	productId integer not null,
	productName character varying(100),
	price decimal(9,2),
	constraint "prk_productId" primary key(productId)
);

create table order_details
(
	order_number integer not null,
	order_detail_id integer not null,
	productId integer not null,
	order_quantity integer not null,
	unit_price decimal(9,2) not null,
	line_total decimal(9,2),
	constraint "fk_order_number" foreign key(order_number) references orders(order_number),
	constraint "fk_productId" foreign key(productId) references product(productId)
);

insert into product(productId, productName, price) values(1, 'memoria ram DDD', 150);
insert into product(productId, productName, price) values(2, 'mouse', 75);
insert into product(productId, productName, price) values(3, 'teclado logitech', 95);

select * from orders;

insert into order_details(order_number,order_detail_id,productId,order_quantity,unit_price,line_total)
values(5,1,1,2,150,300);

insert into order_details(order_number,order_detail_id,productId,order_quantity,unit_price,line_total)
values(5,2,2,2,75,150);

insert into order_details(order_number,order_detail_id,productId,order_quantity,unit_price,line_total)
values(5,3,3,1,95,95);

select order_number, sum(line_total) from order_details where order_number in (1,2,3,4,5) group by order_number;

update orders set price = 545;

