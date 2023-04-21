CREATE TABLE [product] (
  id int IDENTITY(1,1) NOT NULL,
  customerID int NOT NULL,
  name nvarchar(50) NOT NULL,
  type nvarchar(50) NOT NULL,
  wholePrice money NOT NULL,
  retailPrice money NOT NULL,
  info nvarchar(50) NOT NULL,
  departmentID int NOT NULL,
  CONSTRAINT [PK_PRODUCT] PRIMARY KEY CLUSTERED
  (
  [id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

) AS NODE;
GO
CREATE TABLE [customer] (
  id int IDENTITY(1,1) NOT NULL,
  name nvarchar(50) NOT NULL,
  address nvarchar(50) NOT NULL,
  number nvarchar(50) NOT NULL,
  CONSTRAINT [PK_CUSTOMER] PRIMARY KEY CLUSTERED
  (
  [id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

) AS NODE;
GO
CREATE TABLE [department] (
  id int IDENTITY(1,1) NOT NULL,
  name nvarchar(50) NOT NULL,
  prodCount bigint NOT NULL,
  managerID int NOT NULL,
  CONSTRAINT [PK_DEPARTMENT] PRIMARY KEY CLUSTERED
  (
  [id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

) AS NODE;
GO
CREATE TABLE [manager] (
  id int IDENTITY(1,1) NOT NULL,
  name nvarchar(50) NOT NULL,
  personCount bigint NOT NULL,
  departID int NOT NULL,
  CONSTRAINT [PK_MANAGER] PRIMARY KEY CLUSTERED
  (
  [id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

) AS NODE;


GO
ALTER TABLE [product] WITH CHECK ADD CONSTRAINT [product_fk0] FOREIGN KEY ([customerID]) REFERENCES [customer]([id])
ON UPDATE CASCADE
ON DELETE NO ACTION
GO
ALTER TABLE [product] CHECK CONSTRAINT [product_fk0]
GO
ALTER TABLE [product] WITH CHECK ADD CONSTRAINT [product_fk1] FOREIGN KEY ([departmentID]) REFERENCES [department]([id])
ON UPDATE CASCADE
ON DELETE NO ACTION
GO
ALTER TABLE [product] CHECK CONSTRAINT [product_fk1]
GO


ALTER TABLE [department] WITH CHECK ADD CONSTRAINT [department_fk0] FOREIGN KEY ([managerID]) REFERENCES [manager]([id])
ON UPDATE CASCADE
ON DELETE NO ACTION
GO
ALTER TABLE [department] CHECK CONSTRAINT [department_fk0]
GO

ALTER TABLE [manager] WITH CHECK ADD CONSTRAINT [manager_fk0] FOREIGN KEY ([departID]) REFERENCES [department]([id])
ON UPDATE CASCADE
ON DELETE NO ACTION
GO
ALTER TABLE [manager] CHECK CONSTRAINT [manager_fk0]
GO

--Create edge for "Customer buys Product"
CREATE TABLE [buys] (
from_id int NOT NULL,
to_id int NOT NULL,
CONSTRAINT [PK_BUYS] PRIMARY KEY CLUSTERED
(
[from_id] ASC,
[to_id] ASC
) WITH (IGNORE_DUP_KEY = OFF)

) AS EDGE;
GO
ALTER TABLE [buys] WITH CHECK ADD CONSTRAINT [buys_fk0] FOREIGN KEY ([from_id]) REFERENCES customer
ON UPDATE CASCADE
ON DELETE NO ACTION
GO
ALTER TABLE [buys] CHECK CONSTRAINT [buys_fk0]
GO
ALTER TABLE [buys] WITH CHECK ADD CONSTRAINT [buys_fk1] FOREIGN KEY ([to_id]) REFERENCES product
ON UPDATE CASCADE
ON DELETE NO ACTION
GO
ALTER TABLE [buys] CHECK CONSTRAINT [buys_fk1]
GO

--Create edge for "Product is contained in Department"
CREATE TABLE [contained_in] (
from_id int NOT NULL,
to_id int NOT NULL,
CONSTRAINT [PK_CONTAINED_IN] PRIMARY KEY CLUSTERED
(
[from_id] ASC,
[to_id] ASC
) WITH (IGNORE_DUP_KEY = OFF)

) AS EDGE;
GO
ALTER TABLE [contained_in] WITH CHECK ADD CONSTRAINT [contained_in_fk0] FOREIGN KEY ([from_id]) REFERENCES product
ON UPDATE CASCADE
ON DELETE NO ACTION
GO
ALTER TABLE [contained_in] CHECK CONSTRAINT [contained_in_fk0]
GO
ALTER TABLE [contained_in] WITH CHECK ADD CONSTRAINT [contained_in_fk1] FOREIGN KEY ([to_id]) REFERENCES department
ON UPDATE CASCADE
ON DELETE NO ACTION

GO
ALTER TABLE [contained_in] CHECK CONSTRAINT [contained_in_fk1]
GO

--Create edge for "Department is lead by Manager"
CREATE TABLE [lead_by] (
from_id int NOT NULL,
to_id int NOT NULL,
CONSTRAINT [PK_LEAD_BY] PRIMARY KEY CLUSTERED
(
[from_id] ASC,
[to_id] ASC
) WITH (IGNORE_DUP_KEY = OFF)

) AS EDGE;
GO
ALTER TABLE [lead_by] WITH CHECK ADD CONSTRAINT [lead_by_fk0] FOREIGN KEY ([from_id]) REFERENCES department
ON UPDATE CASCADE
ON DELETE NO ACTION
GO
ALTER TABLE [lead_by] CHECK CONSTRAINT [lead_by_fk0]
GO
ALTER TABLE [lead_by] WITH CHECK ADD CONSTRAINT [lead_by_fk1] FOREIGN KEY ([to_id]) REFERENCES manager
ON UPDATE CASCADE
ON DELETE NO ACTION 
GO
ALTER TABLE [lead_by] CHECK CONSTRAINT [lead_by_fk1]
GO

INSERT INTO customer(name,address,number) VALUES
('Nick','Golubeva 23','80291623131'),
('Oleg','Pravda 112','80293216753'),
('Lena','Green 90','80297831265'),
('Mike','Bravo 121','80337843172'),
('Igor','Henryela 12','80176548923'),
('Nigel','Brown 23','80339874222'),
('Alice','Main 45','80331254875'),
('Bob','Gardens 67','80113254798'),
('Kate','Park 87','80223476512'),
('Tom','Lake 12','80344567890')

INSERT INTO product(customerID,name,type,wholePrice,retailPrice,info,departmentID) VALUES
(2,'Levis trainers','trainers',800,950,'Black L',3),
(1,'Nike ','trainers',800,950,'White S',2),
(2,'Levis trainers','trainers',800,950,'Green XL',4),
(3,'Gremis T-shirt','T-shirt',1000,1110,'Brown M',2),
(4,'Loko bracelet','bracelet',80,95,'Silver XS',2),
(5,'Goli trousers','trousers',120,190,'Golden XXL',2),
(6,'Fracis earring','earring',1233,1550,'Yellow L',2),
(6,'Levis trainers','trainers',300,450,'Black L',4),
(1,'Gremis bracelet','bracelet',100,250,'White-striped L',6),
(3,'Minis trainers','trainers',400,550,'Black L',2),
(4,'Nike trainers','trainers',800,950,'White M',3),
(5,'Adidas hoodie','hoodie',600,720,'Black S',4),
(6,'Levis shorts','shorts',300,450,'Blue L',4),
(1,'Gremis necklace','necklace',150,300,'Silver S',2),
(2,'Nike hoodie','hoodie',600,720,'Grey M',9)

INSERT INTO department(name,prodCount,managerID) VALUES
('trainers',122,1),
('accesories',192,2),
('shirts',129,3),
('trousers',90,4),
('hoodies',55,1),
('shorts',73,2),
('necklaces',98,3),
('earrings',68,4),
('bracelets',87,1),
('jackets',40,2)

INSERT INTO manager(name,personCount,departID) VALUES
('Greham Harson',20,1),
('Nick Malek',32,2),
('Kyle Nerlin',120,4),
('Kolya Malina',40,3),
('Alison Green',60,5),
('Bob Jackson',80,6),
('Kate Parker',45,7),
('Tom Smith',90,8),
('Sarah Wilson',55,9),
('John Doe',73,10)

