use master drop database if exists GrafTables create database GrafTables use GrafTables CREATE TABLE [product] (
	id int IDENTITY(1, 1),
	customerID int,
	name nvarchar(50),
	type nvarchar(50),
	wholePrice money,
	retailPrice money,
	info nvarchar(50),
	departmentID int,
	CONSTRAINT [PK_PRODUCT] PRIMARY KEY CLUSTERED ([id] ASC) WITH (IGNORE_DUP_KEY = OFF)
) AS NODE;

GO
	CREATE TABLE [customer] (
		id int IDENTITY(1, 1),
		name nvarchar(50),
		address nvarchar(50),
		number nvarchar(50),
		CONSTRAINT [PK_CUSTOMER] PRIMARY KEY CLUSTERED ([id] ASC) WITH (IGNORE_DUP_KEY = OFF)
	) AS NODE;

GO
	CREATE TABLE [department] (
		id int IDENTITY(1, 1),
		name nvarchar(50),
		prodCount bigint,
		managerID int,
		CONSTRAINT [PK_DEPARTMENT] PRIMARY KEY CLUSTERED ([id] ASC) WITH (IGNORE_DUP_KEY = OFF)
	) AS NODE;

GO
	CREATE TABLE [manager] (
		id int IDENTITY(1, 1),
		name nvarchar(50),
		personCount bigint,
		departID int,
		CONSTRAINT [PK_MANAGER] PRIMARY KEY CLUSTERED ([id] ASC) WITH (IGNORE_DUP_KEY = OFF)
	) AS NODE;

GO
ALTER TABLE
	[product] WITH CHECK
ADD
	CONSTRAINT [product_fk0] FOREIGN KEY ([customerID]) REFERENCES [customer]([id]) ON UPDATE CASCADE ON DELETE NO ACTION
GO
ALTER TABLE
	[product] CHECK CONSTRAINT [product_fk0]
GO
ALTER TABLE
	[product] WITH CHECK
ADD
	CONSTRAINT [product_fk1] FOREIGN KEY ([departmentID]) REFERENCES [department]([id]) ON UPDATE CASCADE ON DELETE NO ACTION
GO
ALTER TABLE
	[product] CHECK CONSTRAINT [product_fk1]
GO
ALTER TABLE
	[department] WITH CHECK
ADD
	CONSTRAINT [department_fk0] FOREIGN KEY ([managerID]) REFERENCES [manager]([id]) ON UPDATE CASCADE ON DELETE NO ACTION
GO
ALTER TABLE
	[department] CHECK CONSTRAINT [department_fk0]
GO
ALTER TABLE
	[manager] WITH CHECK
ADD
	CONSTRAINT [manager_fk0] FOREIGN KEY ([departID]) REFERENCES [department]([id]) ON UPDATE CASCADE ON DELETE NO ACTION
GO
ALTER TABLE
	[manager] CHECK CONSTRAINT [manager_fk0]
GO
	CREATE TABLE [buys] as EDGE
ALTER TABLE
	[buys]
ADD
	CONSTRAINT EC_buys CONNECTION (Customer TO Product) CREATE TABLE [contained_in] as EDGE
ALTER TABLE
	[contained_in]
ADD
	CONSTRAINT EC_contained_in CONNECTION (Product TO Department) CREATE TABLE [lead_by] as EDGE
ALTER TABLE
	[lead_by]
ADD
	CONSTRAINT EC_lead_by CONNECTION (Manager TO Department)
INSERT INTO
	customer(name, address, number)
VALUES
	('Nick', 'Golubeva 23', '80291623131'),
	('Oleg', 'Pravda 112', '80293216753'),
	('Lena', 'Green 90', '80297831265'),
	('Mike', 'Bravo 121', '80337843172'),
	('Igor', 'Henryela 12', '80176548923'),
	('Nigel', 'Brown 23', '80339874222'),
	('Alice', 'Main 45', '80331254875'),
	('Bob', 'Gardens 67', '80113254798'),
	('Kate', 'Park 87', '80223476512'),
	('Tom', 'Lake 12', '80344567890')
INSERT INTO
	product(
		customerID,
		name,
		type,
		wholePrice,
		retailPrice,
		info,
		departmentID
	)
VALUES
	(
		2,
		'Levis trainers',
		'trainers',
		800,
		950,
		'Black L',
		3
	),
	(1, 'Nike ', 'trainers', 800, 950, 'White S', 2),
	(
		2,
		'Levis trainers',
		'trainers',
		800,
		950,
		'Green XL',
		4
	),
	(
		3,
		'Gremis T-shirt',
		'T-shirt',
		1000,
		1110,
		'Brown M',
		2
	),
	(4, 'Loko bracelet', 'bracelet', 80, 95, 'Silver XS', 2),
	(
		5,
		'Goli trousers',
		'trousers',
		120,
		190,
		'Golden XXL',
		2
	),
	(
		6,
		'Fracis earring',
		'earring',
		1233,
		1550,
		'Yellow L',
		2
	),
	(
		6,
		'Levis trainers',
		'trainers',
		300,
		450,
		'Black L',
		4
	),
	(
		1,
		'Gremis bracelet',
		'bracelet',
		100,
		250,
		'White-striped L',
		6
	),
	(
		3,
		'Minis trainers',
		'trainers',
		400,
		550,
		'Black L',
		2
	),
	(4, 'Nike trainers', 'trainers', 800, 950, 'White M', 3),
	(5, 'Adidas hoodie', 'hoodie', 600, 720, 'Black S', 4),
	(6, 'Levis shorts', 'shorts', 300, 450, 'Blue L', 4),
	(
		1,
		'Gremis necklace',
		'necklace',
		150,
		300,
		'Silver S',
		2
	),
	(2, 'Nike hoodie', 'hoodie', 600, 720, 'Grey M', 9)
INSERT INTO
	department(name, prodCount, managerID)
VALUES
	('trainers', 122, 1),
	('accesories', 192, 2),
	('shirts', 129, 3),
	('trousers', 90, 4),
	('hoodies', 55, 1),
	('shorts', 73, 2),
	('necklaces', 98, 3),
	('earrings', 68, 4),
	('bracelets', 87, 1),
	('jackets', 40, 2)
INSERT INTO
	manager(name, personCount, departID)
VALUES
	('Greham Harson', 20, 1),
	('Nick Malek', 32, 2),
	('Kyle Nerlin', 120, 4),
	('Kolya Malina', 40, 3),
	('Alison Green', 60, 5),
	('Bob Jackson', 80, 6),
	('Kate Parker', 45, 7),
	('Tom Smith', 90, 8),
	('Sarah Wilson', 55, 9),
	('John Doe', 73, 10)
select
	*
from
	product
insert into
	buys ($ from_id, $ to_id)
values
	(
		(
			Select
				$ node_id
			from
				customer
			where
				id = 1
		),
		(
			Select
				$ node_id
			from
				product
			where
				id = 4
		)
	)
insert into
	buys ($ from_id, $ to_id)
values
	(
		(
			Select
				$ node_id
			from
				customer
			where
				id = 2
		),
		(
			Select
				$ node_id
			from
				product
			where
				id = 3
		)
	),
	(
		(
			Select
				$ node_id
			from
				customer
			where
				id = 2
		),
		(
			Select
				$ node_id
			from
				product
			where
				id = 3
		)
	),
	(
		(
			Select
				$ node_id
			from
				customer
			where
				id = 2
		),
		(
			Select
				$ node_id
			from
				product
			where
				id = 15
		)
	),
	(
		(
			Select
				$ node_id
			from
				customer
			where
				id = 3
		),
		(
			Select
				$ node_id
			from
				product
			where
				id = 4
		)
	),
	(
		(
			Select
				$ node_id
			from
				customer
			where
				id = 3
		),
		(
			Select
				$ node_id
			from
				product
			where
				id = 10
		)
	),
	(
		(
			Select
				$ node_id
			from
				customer
			where
				id = 4
		),
		(
			Select
				$ node_id
			from
				product
			where
				id = 5
		)
	),
	(
		(
			Select
				$ node_id
			from
				customer
			where
				id = 4
		),
		(
			Select
				$ node_id
			from
				product
			where
				id = 11
		)
	),
	(
		(
			Select
				$ node_id
			from
				customer
			where
				id = 5
		),
		(
			Select
				$ node_id
			from
				product
			where
				id = 6
		)
	),
	(
		(
			Select
				$ node_id
			from
				customer
			where
				id = 5
		),
		(
			Select
				$ node_id
			from
				product
			where
				id = 12
		)
	),
	(
		(
			Select
				$ node_id
			from
				customer
			where
				id = 6
		),
		(
			Select
				$ node_id
			from
				product
			where
				id = 7
		)
	),
	(
		(
			Select
				$ node_id
			from
				customer
			where
				id = 6
		),
		(
			Select
				$ node_id
			from
				product
			where
				id = 8
		)
	),
	(
		(
			Select
				$ node_id
			from
				customer
			where
				id = 6
		),
		(
			Select
				$ node_id
			from
				product
			where
				id = 13
		)
	);

insert into
	contained_in ($ from_id, $ to_id)
values
	(
		(
			Select
				$ node_id
			from
				product
			where
				id = 3
		),
		(
			Select
				$ node_id
			from
				department
			where
				id = 4
		)
	),
	(
		(
			Select
				$ node_id
			from
				product
			where
				id = 4
		),
		(
			Select
				$ node_id
			from
				department
			where
				id = 3
		)
	),
	(
		(
			Select
				$ node_id
			from
				product
			where
				id = 5
		),
		(
			Select
				$ node_id
			from
				department
			where
				id = 2
		)
	),
	(
		(
			Select
				$ node_id
			from
				product
			where
				id = 6
		),
		(
			Select
				$ node_id
			from
				department
			where
				id = 2
		)
	),
	(
		(
			Select
				$ node_id
			from
				product
			where
				id = 7
		),
		(
			Select
				$ node_id
			from
				department
			where
				id = 2
		)
	),
	(
		(
			Select
				$ node_id
			from
				product
			where
				id = 8
		),
		(
			Select
				$ node_id
			from
				department
			where
				id = 4
		)
	),
	(
		(
			Select
				$ node_id
			from
				product
			where
				id = 9
		),
		(
			Select
				$ node_id
			from
				department
			where
				id = 6
		)
	),
	(
		(
			Select
				$ node_id
			from
				product
			where
				id = 10
		),
		(
			Select
				$ node_id
			from
				department
			where
				id = 2
		)
	),
	(
		(
			Select
				$ node_id
			from
				product
			where
				id = 11
		),
		(
			Select
				$ node_id
			from
				department
			where
				id = 3
		)
	),
	(
		(
			Select
				$ node_id
			from
				product
			where
				id = 12
		),
		(
			Select
				$ node_id
			from
				department
			where
				id = 4
		)
	),
	(
		(
			Select
				$ node_id
			from
				product
			where
				id = 13
		),
		(
			Select
				$ node_id
			from
				department
			where
				id = 4
		)
	),
	(
		(
			Select
				$ node_id
			from
				product
			where
				id = 14
		),
		(
			Select
				$ node_id
			from
				department
			where
				id = 2
		)
	),
	(
		(
			Select
				$ node_id
			from
				product
			where
				id = 15
		),
		(
			Select
				$ node_id
			from
				department
			where
				id = 9
		)
	);

select
	*
from
	lead_by
insert into
	lead_by ($ from_id, $ to_id)
values
	(
		(
			Select
				$ node_id
			from
				manager
			where
				id = 2
		),
(
			Select
				$ node_id
			from
				department
			where
				id = 2
		)
	),
	(
		(
			Select
				$ node_id
			from
				manager
			where
				id = 3
		),
(
			Select
				$ node_id
			from
				department
			where
				id = 3
		)
	),
	(
		(
			Select
				$ node_id
			from
				manager
			where
				id = 4
		),
(
			Select
				$ node_id
			from
				department
			where
				id = 4
		)
	),
	(
		(
			Select
				$ node_id
			from
				manager
			where
				id = 1
		),
(
			Select
				$ node_id
			from
				department
			where
				id = 5
		)
	),
	(
		(
			Select
				$ node_id
			from
				manager
			where
				id = 2
		),
(
			Select
				$ node_id
			from
				department
			where
				id = 6
		)
	),
	(
		(
			Select
				$ node_id
			from
				manager
			where
				id = 3
		),
(
			Select
				$ node_id
			from
				department
			where
				id = 7
		)
	),
	(
		(
			Select
				$ node_id
			from
				manager
			where
				id = 4
		),
(
			Select
				$ node_id
			from
				department
			where
				id = 8
		)
	),
	(
		(
			Select
				$ node_id
			from
				manager
			where
				id = 1
		),
(
			Select
				$ node_id
			from
				department
			where
				id = 9
		)
	),
	(
		(
			Select
				$ node_id
			from
				manager
			where
				id = 2
		),
(
			Select
				$ node_id
			from
				department
			where
				id = 10
		)
	);

--MATCH
--
Select
	customer1.name,
	product1.name as Buys
from
	customer as customer1,
	buys,
	product as product1
where
	Match(customer1 - (buys) -> product1)
	and customer1.name = N'Oleg';

--
Select
	product1.name,
	department1.name as Contained_in_DEP
from
	product as product1,
	contained_in,
	department as department1
where
	Match(product1 - (contained_in) -> department1)
	and product1.name = N'Levis trainers';

--
Select
	department1.name,
	manager1.name as Lead_by
from
	department as department1,
	lead_by,
	manager as manager1
where
	Match(department1 - (lead_by) -> manager1)
	and department1.name = N'shorts';

--
Select
	product1.name as product,
	department.name as department
from
	customer as customer1,
	product as product1,
	buys,
	contained_in,
	department
where
	Match (
		customer1 - (buys) -> product1 - (contained_in) -> department
	)
	and customer1.name = N'Oleg' --
Select
	department.name as department,
	manager.name as manager
from
	department,
	product as product1,
	contained_in,
	lead_by,
	manager
where
	Match (
		product1 - (contained_in) -> department - (lead_by) -> manager
	)
	and product1.name = N 'Nike' -- SHORTEST_PATH
Select
	product1.name,
	string_agg(department1.name, '->') within group (graph path) as also_contained_in_dep
from
	product as product1,
	contained_in for path as fo,
	department for path as department1
where
	Match(shortest_path(product1(-(fo) -> department1) +))
	and product1.name = N'Levis trainers';

Select
	department1.name,
	string_agg(manager1.name, '->') within group (graph path) as also_lead_by
from
	department as department1,
	lead_by for path as fo,
	manager for path as manager1
where
	Match(shortest_path(department1(-(fo) -> manager1) { 1, 2 }))
	and department1.name = N'Levis trainers';