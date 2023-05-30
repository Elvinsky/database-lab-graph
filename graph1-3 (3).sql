use master
drop database if exists GrafTables
create database GrafTables
use GrafTables
go

CREATE TABLE student (
  id int IDENTITY(1,1) primary key,
  name nvarchar(50),
 ) AS NODE;
GO

CREATE TABLE university (
  id int IDENTITY(1,1) primary key,
  name nvarchar(50),
) AS NODE;
GO

CREATE TABLE town (
  id int IDENTITY(1,1) primary key,
  name nvarchar(50),
  ) AS NODE;
GO

INSERT INTO student(name) VALUES
('Nick'),
('Oleg'),
('Lena'),
('Mike'),
('elsa'),
('pony'),
('mary'),
('tim')

INSERT INTO university(name) VALUES
('BSU'), --minsk
('BSUIR'), --minsk
('GSUT'), --gomel
('GSUYK'),--grodno
('VSU'), --vitebsk
('BSUP'), --brest
('MSU') --mogilev


INSERT INTO town(name) VALUES
('Minsk'),
('Gomel'),
('Grodno'),
('Vitebsk'),
('Brest'),
('Mogilev')



CREATE TABLE [enter_in] as EDGE
ALTER TABLE [enter_in] ADD CONSTRAINT EC_enter_in CONNECTION (student TO university)

CREATE TABLE [unik_in_town] as EDGE
ALTER TABLE [unik_in_town] ADD CONSTRAINT EC_unik_in_town CONNECTION (university TO town)

CREATE TABLE [lives_in] as EDGE
ALTER TABLE [lives_in] ADD CONSTRAINT EC_lives_in CONNECTION (student TO town)


CREATE TABLE [friends] as EDGE
ALTER TABLE [friends] ADD CONSTRAINT EC_friends CONNECTION (student TO student)



insert into enter_in ($from_id, $to_id)
values  ((Select $node_id from student where id = 1), (Select $node_id from university where id = 3)),
((Select $node_id from student where id = 8), (Select $node_id from university where id = 3)),
((Select $node_id from student where id = 2), (Select $node_id from university where id = 1)),
((Select $node_id from student where id = 3), (Select $node_id from university where id = 7)),
((Select $node_id from student where id = 4), (Select $node_id from university where id = 2)),
((Select $node_id from student where id = 5), (Select $node_id from university where id = 4)),
((Select $node_id from student where id = 6), (Select $node_id from university where id = 5)),
((Select $node_id from student where id = 7), (Select $node_id from university where id = 6));
	
insert into unik_in_town ($from_id, $to_id)
values  ((Select $node_id from university where id = 1), (Select $node_id from town where id = 1)),
((Select $node_id from university where id = 2), (Select $node_id from town where id = 1)),
((Select $node_id from university where id = 3), (Select $node_id from town where id = 2)),
((Select $node_id from university where id = 4), (Select $node_id from town where id = 3)),
((Select $node_id from university where id = 5), (Select $node_id from town where id = 4)),
((Select $node_id from university where id = 6), (Select $node_id from town where id = 5)),
((Select $node_id from university where id = 7), (Select $node_id from town where id = 6));
	
insert into lives_in ($from_id, $to_id)
values  ((Select $node_id from student where id = 1), (Select $node_id from town where id = 4)),
((Select $node_id from student where id = 2), (Select $node_id from town where id = 4)),
((Select $node_id from student where id = 3), (Select $node_id from town where id = 1)),
((Select $node_id from student where id = 4), (Select $node_id from town where id = 2)),
((Select $node_id from student where id = 5), (Select $node_id from town where id = 2)),
((Select $node_id from student where id = 6), (Select $node_id from town where id = 5)),
((Select $node_id from student where id = 7), (Select $node_id from town where id = 3)),
((Select $node_id from student where id = 8), (Select $node_id from town where id = 6));


insert into friends ($from_id, $to_id)
values  ((Select $node_id from student where id = 2), (Select $node_id from student where id = 8)),
((Select $node_id from student where id = 8), (Select $node_id from student where id = 6)),
((Select $node_id from student where id = 8), (Select $node_id from student where id = 5)),
((Select $node_id from student where id = 5), (Select $node_id from student where id = 1));


--MATCH
-- где учится олег
Select student1.name
	   , university1.name as enter_in
from student as student1
	 , enter_in
	 , university as university1
where Match(student1 - (enter_in) -> university1)
	  and student1.name = N'Oleg';

-- в каком горовде расположен бгу 
Select university1.name
	   , town1.name as unik_in_town
from university as university1
	 , unik_in_town
	 , town as town1
where Match(university1 - (unik_in_town) -> town1)
	  and university1.name = N'BSU';

-- в каком городе находится msu
Select university1.name
	   , town1.name as unik_in_town
from university as university1
	 , unik_in_town
	 , town as town1
where Match(university1 - (unik_in_town) -> town1)
	  and university1.name = N'MSU';

-- где живет лена
Select student1.name
	   , town1.name as lives_in
from student as student1
	 , lives_in
	 , town as town1
where Match(student1 - (lives_in) -> town1)
	  and student1.name = N'Lena';

-- в какой городе учиться олег
Select student1.name as student
	   , town.name as studies_in
from student as student1
	 , university as university1
	 , enter_in
	 , unik_in_town
	 , town
where Match (student1 - (enter_in) -> university1 - (unik_in_town) -> town)
      and student1.name = N'Oleg'



-- SHORTEST_PATH

Select student1.name
	   , string_agg(student2.name, '->') within group (graph path) as  friends
from student as student1
	 , friends for path as fo
	 , student for path as student2
where Match(shortest_path(student1(-(fo)->student2){1,3}))
	  and student1.name = N'Oleg';

	  
Select student1.name
	   , string_agg(student2.name, '->') within group (graph path) as  friends
from student as student1
	 , friends for path as fo
	 , student for path as student2
where Match(shortest_path(student1(-(fo)->student2)+))
	  and student1.name = N'tim';
	  
SELECT P1.ID IdFirst
		, P1.name AS First
		, CONCAT(N'Student', P1.id) AS [First image name]
		, P2.ID IdSecond
		, P2.name AS Second
		, CONCAT(N'University', P2.id) AS [Second image name]
FROM dbo.student AS P1
		, dbo.enter_in as F
		, dbo.university AS P2
WHERE MATCH (P1-(F)->P2)

SELECT P1.ID IdFirst
		, P1.name AS First
		, CONCAT(N'University', P1.id) AS [First image name]
		, P2.ID IdSecond
		, P2.name AS Second
		, CONCAT(N'Town', P2.id) AS [Second image name]
FROM dbo.university AS P1
		, dbo.unik_in_town as F
		, dbo.town AS P2
WHERE MATCH (P1-(F)->P2)

SELECT P1.ID IdFirst
		, P1.name AS First
		, CONCAT(N'Student', P1.id) AS [First image name]
		, P2.ID IdSecond
		, P2.name AS Second
		, CONCAT(N'Student', P2.id) AS [Second image name]
FROM dbo.student AS P1
		, dbo.friends as F
		, dbo.student AS P2
WHERE MATCH (P1-(F)->P2)

SELECT * from friends

SELECT @@SERVERNAME AS 'Server Name'  

