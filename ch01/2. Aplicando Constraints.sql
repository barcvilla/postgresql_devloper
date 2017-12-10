-- Definiendo Individual Constraints
create table tools
(
tool_id integer unique,
tool_name text,
tool_class numeric
);

-- Definiendo Constraints para un grupo de columnas
create table cards
(
card_id integer,
owner_number integer,
owner_name text,
unique(card_id, owner_name)
);

-- Not null Constraints
alter table tools
	alter column tool_id set not null,
	alter column tool_name set not null;

-- Exclusion constraints
create table movies
(
title text,
copies integer
);

alter table movies
	add exclude(title with=, copies with=);

-- Add Primary key constraints
alter table tools
	add primary key(tool_id);


-- Add Foreign key Constraints
create table tools_list
(
list_id integer primary key,
tool_id integer references tools(tool_id),
list_name text
);

-- Add Check Constraints
alter table tools
	add column tool_quantity numeric check(tool_quantity > 0);
	
-- Otra forma de adicionar un check constraint
alter table tools
	drop column tool_quantity,
	add column tool_quantity numeric,
	add constraint positive_quantity check(tool_quantity > 0);

