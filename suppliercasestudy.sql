create database supplier
go


use supplier
go


create table suppliermaster
(
	SID		Integer			Primary Key,
	NAME	Varchar (40)	NOT NULL, 
	CITY	Char(6)			NOT NULL,
	GRADE	Tinyint			NOT NULL check(grade='1'or grade='2' or grade='3' or grade='4')
)
go
-- read the table 
select * from suppliermaster
go

--inserting the value
insert into suppliermaster values(1,'amit','bilasp',2)
insert into suppliermaster values(2,'anand','vizag',3)
insert into suppliermaster values(3,'aditya','pune',1)
insert into suppliermaster values(4,'sandy','nagpur',4)
insert into suppliermaster values(5,'hasin','mumbai',1)
insert into suppliermaster values(6,'md','mirza',3)
insert into suppliermaster values(7,'abhishek','tale',2)
insert into suppliermaster values(8,'akash','guju',1)
insert into suppliermaster values(9,'pawar','aurang',3)
insert into suppliermaster values(10,'kumar','ranchi',2)
insert into suppliermaster values(11,'ayush','bhilai',1)

--creating table partmaster
create table partmaster
(
	PID		  TinyInt			Primary Key,
	NAME	  Varchar(40)		NOT NULL,
	PRICE	   Money			NOT NULL,
	CATEGORY	Tinyint		    NOT NULL,
	QTYONHAND	Integer		    NOT NULL
)
go

--read the table
select * from partmaster

--inserting the values
insert into partmaster values(10,'mobile',1000,9,95)
insert into partmaster values(20,'laptop',1500,8,85)
insert into partmaster values(30,'cover',2000,7,75)
insert into partmaster values(40,'tv',2500,6,65)
insert into partmaster values(50,'washing machine',3000,9,50)
insert into partmaster values(60,'fridge',25000,8,25)
insert into partmaster values(70,'oven',2500,5,60)
insert into partmaster values(80,'helmet',2000,5,55)
insert into partmaster values(90,'speaker',3000,4,45)
insert into partmaster values(100,'frame',1500,5,35)
insert into partmaster values(110,'tv',3300,6,12)

select * from partmaster


--creating supplydetails table
create table supplydetails
(
		PID				TinyInt			NOT NULL Foreign Key references partmaster(PID),
		SID				Integer			NOT NULL Foreign Key references suppliermaster(SID),
		DATEOFSUPPLY	DateTime		NOT NULL,
		CITY			Varchar(40)		NOT NULL,
		QTYSUPPLIED		Integer			NOT NULL
)
go

select * from supplydetails
go


--schema of supplydetails
sp_help 'supplydetails'
go

insert into supplydetails values(10,1,'2015/12/12','ajmer',100)
insert into supplydetails values(20,2,'2015/12/10','rajasthan',150)
insert into supplydetails values(30,3,'2016/12/11','gujarat',200)
insert into supplydetails values(40,4,'2016/12/09','mumbai',250)
insert into supplydetails values(50,5,'2017/12/11','gujarat',100)
insert into supplydetails values(60,6,'2018/12/09','raipur',25)
insert into supplydetails values(70,7,'2018/12/11','gujarat',200)
insert into supplydetails values(80,8,'2019/12/09','durg',300)
insert into supplydetails values(90,9,'2020/12/11','shimla',100)
insert into supplydetails values(100,10,'2020/12/09','leh',25)
insert into supplydetails values(110,11,'2021/12/09','us',10)





select * from supplydetails
go



--Question 1.List the month-wise average supply of parts supplied for all parts. Provide the information only if the average is higher than 20.
--solution-1
select avg(price) as avgsupply,
datepart(yy,dateofsupply) as yno,
datepart(mm,dateofsupply) as mno,
datename(mm,dateofsupply) as mname from partmaster as pm join supplydetails as sp
on pm.pid=sp.pid
group by datepart(yy,dateofsupply),
datepart(mm,dateofsupply),
datename(mm,dateofsupply)
having avg(price)>20



--Question-2  	List the names of the Suppliers who do not supply part with PID ‘10’
--solution-2 
select * from suppliermaster as sm join supplydetails as sd
on sm.sid=sd.sid
  join partmaster as pm
on pm.pid=sd.pid
where not pm.pid=10






--question 3 List the part id, name, price and difference between price and average price of all parts
solution
select name,pid,price,price-(select avg(price) from partmaster) as diff from partmaster




--question 4 	List the names of the suppliers who have supplied at least one part where the quantity supplied is lower than 200
Solution 

select name 
from suppliermaster as sm join supplydetails as sd
on sm.sid=sd.sid
where qtysupplied <200




--question 5.	List the names of the suppliers who live in a city where no supply has been made.

--solution 5
select sm.name from suppliermaster as sm join supplydetails as sd
 on sm.sid=sd.sid
where sm.city not in (sd.city)



--question 6 	List the names of the parts which have not been supplied in the month of May 2019
solution

select pm.name
from partmaster as pm join supplydetails as sd
on pm.pid=sd.pid
where  NOT datepart(yy,dateofsupply)=2019 



--question 7 List name and Price category for all parts. Price category has to be displayed as “Cheap” 
--if price is less than 100, “Medium” if the price is greater than or equal to 100 and less than 500, and “Costly”
--if the price is greater than or equal to 500.

--solution 7
select name,category,
               case
			          when price<100 then 'cheap'
					   when price between 100 and 500 then 'medium'
					   else 'costly'
					  end as customertype
					  from partmaster




--question- 8 List the most recent supply details with information on Product name, price and no. of days elapsed since the latest supply 
solution

select name,price,dateofsupply,
datediff(yy,dateofsupply,getdate()) as recentsupply,
datediff(dd,dateofsupply,getdate()) as [no of days elasped]
from partmaster as pm join supplydetails as sd
on pm.pid=sd.pid
where datediff(dd,'2021/12/09',getdate())=0 


--question- 9 List the names of the suppliers who have supplied exactly 100 units of part P1 
solution
select name
from suppliermaster as sm join supplydetails as sd
on sm.sid=sd.sid
where pid=10 and qtysupplied=100


--question-10 List the names of the parts supplied by more than one supplier
solution

select pm.name
from suppliermaster as sm join supplydetails as sd
on sm.sid=sd.sid
 join partmaster as pm
 on pm.pid=sd.pid 
group by pm.name
having count(*)>1



--question 11.	List the names of the parts whose price is less than the average price of parts
solution-11
select * 
from partmaster as pm
join
(
   select name,avg(price) as avgprice
   from partmaster 
   group by name
   ) as pm1 on pm.name=pm1.name
where price<avgprice

--question 12 List the category-wise number of parts; exclude those where the sum is > 100 and less than 500. List in the descending order of sum
solution

select pm.name,category as total 
from partmaster as pm join supplydetails as sd
on pm.pid=sd.pid
group by category,pm.name




--question 13.	List the supplier name, part name and supplied quantity for all supplies made between 1st and 15th of June 2020.
solution: 
select sm.name,pm.name,qtysupplied
from suppliermaster as sm join supplydetails as sd
on sm.sid=sd.sid
 join partmaster as pm
 on pm.pid=sd.pid
 where datediff(dd,'2020/06/01','2020/06/15')



 

 --question 14	For all products supplied by Supplier S1, List the part name and total quantity.
 solution:

 select pm.name,qtysupplied
 from suppliermaster as sm join supplydetails as sd
 on sm.sid=sd.sid
  join partmaster as pm
on pm.pid=sd.pid
where sm.sid=1

--question 15 	For the part with the minimum price, List the latest supply details (Supplier Name, Part id, Date of supply, Quantity Supplied).
solution-


select sm.name,pm.pid,dateofsupply,qtysupplied,
pm.price,row_number() over(partition by price order by price asc) as Rno 
from partmaster as pm join supplydetails as sd
on pm.pid=sd.pid
join suppliermaster as sm
on sm.sid=sd.sid







