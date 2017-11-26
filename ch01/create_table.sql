create table bugs
(
bug_id integer not null,
date_reported timestamp without time zone,
summary character varying(80),
description text,
resolution text,
reported_by integer not null,
assigned_to integer,
verfied_by integer,
status character varying(20) not null,
priority character varying(2),
hours decimal(9,2),
constraint "prm_key_bug" primary key(bug_id)
);

-- aplicando un default value a una columna
alter table bugs
	alter column status set default 'New';

-- añadir foreign key a la tabla bugs
alter table bugs
	add constraint "frn_key_reported" foreign key(reported_by) references accounts(account_id),
	add constraint "frn_key_assigned" foreign key(assigned_to) references accounts(account_id),
	add constraint "frn_key_veryfied" foreign key(verfied_by) references accounts(account_id),
	add constraint "frn_key_status" foreign key(status) references bugstatus(status);

-- table comments
create table comments
(
comment_id integer,
bug_id integer not null,
author integer not null,
comment_date timestamp without time zone not null,
comment text not null,
constraint "prm_key_comment" primary key(comment_id),
constraint "frn_key_bug_id" foreign key(bug_id) references bugs(bug_id),
constraint "frn_key_author" foreign key(author) references accounts(account_id)
);

-- table screenshots
create table screenshots
(
bug_id integer not null,
image_id integer not null,
screenshot_image bytea,
caption character varying(100),
constraint "prm_key_screenshot" primary key(bug_id, image_id),
constraint "frn_key_screenshot_bug_id" foreign key(bug_id) references bugs(bug_id)
);

-- tabla tags
create table tags
(
bug_id integer not null,
tag character varying(20) not null,
constraint "prm_key_tags" primary key(bug_id, tag),
constraint "frn_key_tags_bug_id" foreign key(bug_id) references bugs(bug_id)
);

--table products
create table products
(
product_id integer not null,
product_name character varying(50)
);

alter table products
	add constraint "prm_key_product_id" primary key(product_id);


-- table BugsProducts
create table bugsproducts
(
bug_id integer not null,
product_id integer not null,
constraint "prm_key_bugsproducts" primary key(bug_id, product_id),
constraint "frn_key_bugsproducts_bug_id" foreign key(bug_id) references bugs(bug_id),
constraint "frm_key_bugsproducts_product_id" foreign key(product_id) references products(product_id)
);
