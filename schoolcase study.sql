use master
go


create database school
go
sp_helpdb 'school'


--change the db context
use school
go
/************************************************************
NAME: code for school DB
Author:  aditya
date: 12/09/2021
Purpose: this db will create db and few table in it to store information about school




**********************************************************/
--coursemaster
create table coursemaster
(
	CID			Integer			Primary Key,
	CourseName	Varchar (40)	NOT NULL, 
	Category	Char(1)			NULL check (category='B' or category='M' or category='A'),
	Fee			Smallmoney		NOT NULL check(Fee>0)
)
go

select * from coursemaster

--schema of table
sp_help 'coursemaster'

--read the data
select * from coursemaster
--insert data
insert into coursemaster values(10,'java','B',5000)
insert into coursemaster values(20,'advanced java','B',2500)
insert into coursemaster values(30,'big data','B',40000)
insert into coursemaster values(40,'SQL server','B',20000)
insert into coursemaster values(50,' myserver','M',21000)
insert into coursemaster values(60,'data sciene','A',22000)
insert into coursemaster values(70,' ML','A',210)
insert into coursemaster values(80,'AI','A',22220)
insert into coursemaster values(90,' cyber security','A',50000)
insert into coursemaster values(100,' IOT','A',55000)

--student master
create table studentmaster
(
	SID		TinyInt			Primary Key,
	Name	Varchar(40)		NOT NULL,
	Origin	Char(1)			NOT NULL check(origin='L' or origin='F'), 
	Type	Char(1)			NOT NULL check(type='U' or type='G')

)
go

select * from studentmaster

insert into studentmaster values(1,'bieln haile','F','G')
insert into studentmaster values(2,'durga prasad','L','U')
insert into studentmaster values(3,'Geni','F','U')
insert into studentmaster values(4,'Gopi krishna','L','G')
insert into studentmaster values(5,'Gopi ','L','U')
insert into studentmaster values(6,'david','F','U')
insert into studentmaster values(7,'ronaldo','F','G')
insert into studentmaster values(8,'neymar','F','U')
insert into studentmaster values(9,'beckham','F','U')
insert into studentmaster values(10,'messi','F','U')

--enrollmentmaster
create table enrollmentmaster
(
				CID		Integer				NOT NULL Foreign Key References coursemaster(CID),
				SID		Tinyint				NOT NULL Foreign Key References studentmaster(SID),
				DOE		DateTime			NOT NULL,
				FWF 	Bit					NOT NULL,
				Grade	Char(1)				NULL check(grade='o' or grade='A' or grade='B'or grade='C')
)
go
-- check(grade in ('O','A','B')) ----shortcut way
-- gender='M' or gender='F'
--gender in ('M','F')

insert into enrollmentmaster values(40,1,'2020/11/19',0,'O')
insert into enrollmentmaster values(30,2,'2020/10/19',1,'A')
insert into enrollmentmaster values(20,3,'2020/11/15',0,'B')
insert into enrollmentmaster values(10,4,'2020/10/14',1,'A')
insert into enrollmentmaster values(50,5,'2017/11/15',1,'C')
insert into enrollmentmaster values(60,6,'2017/10/14',0,'A')
insert into enrollmentmaster values(70,5,'2017/11/15',1,'C')
insert into enrollmentmaster values(80,6,'2018/10/14',0,'A')
insert into enrollmentmaster values(90,7,'2019/11/15',1,'C')
insert into enrollmentmaster values(100,6,'2018/10/14',0,'B')



select * from enrollmentmaster
go



--coursewise no of students enrolled
select count(*) as [no of counts] from studentmaster where type='G'


select * from coursemaster as cm join enrollmentmaster as em
on cm.cid=em.cid

--question 1 	List the course wise total no. of Students enrolled. Provide the information only for students of foreign origin and
--only if the total exceeds 10.
--solution  1
select sm.name,cm.coursename,origin,count('origin') as [no of origin] from studentmaster as sm join enrollmentmaster as em
on sm.sid=em.sid
join coursemaster as cm
on cm.cid=em.cid
where sm.origin='F' 
group by sm.name,cm.coursename,origin
having count('origin')>10


--3.List the name of the advanced course where the enrollment by foreign students is the highest
--solution 3
select coursename,name,origin,count('F') as [no of foreign origin] from
  coursemaster as cm join enrollmentmaster as em
  on cm.cid=em.cid
    join studentmaster as sm
on sm.sid=em.sid
where origin='F'
group by coursename,name,origin
order by 4 desc




--question 2.	List the names of the Students who have not enrolled for Java course.
--solution-2
select coursename from coursemaster
where coursename not like '%java%'


--question 4.	List the names of the students who have enrolled for at least one basic course in the current month
--solution-4
 select name,datename(yy,doe) as yrno ,datename(mm,doe) as mno from
  coursemaster as cm join enrollmentmaster as em
  on cm.cid=em.cid
    join studentmaster as sm
on sm.sid=em.sid
where datediff(mm,doe,getdate())=0

--question 5.	List the names of the Undergraduate, local students who have got a “C” grade in any basic course.
--solution-5
select coursename,type,origin from
  coursemaster as cm join enrollmentmaster as em
  on cm.cid=em.cid
    join studentmaster as sm
on sm.sid=em.sid
where grade='C'


--question- 6.	List the names of the courses for which no student has enrolled in the month of november 2017.
--solution- 6
select coursename from
  coursemaster as cm join enrollmentmaster as em
  on cm.cid=em.cid
    join studentmaster as sm
on sm.sid=em.sid
where not datepart(yy,doe)=2017 and not datepart(mm,doe)=11
\
--question-7 	List name, Number of Enrollments and Popularity for all Courses.
--Popularity has to be displayed as “High” if number of enrollments is higher than 50,
--“Medium” if greater than or equal to 20 and less than 50, and “Low” if the no.  Is less than 20

--solution 7)
select cm.coursename,
     count(*) as [no of enrollment],
        doe,
	      case
	         when DOE > 50 then 'High'
			 when doe  between 20 and 50 then 'Medium'
			 when doe < 20 then 'low'
		end as popularity
from  coursemaster as cm join enrollmentmaster as em
 on cm.cid=em.cid
group by doe,cm.coursename


--question 8. List the most recent enrollment details with information on Student Name, Course name and age of enrollment in days
--solution 8)


 select name,coursename,datediff(dd,doe,getdate()) as [age of enrollment in days] from
  coursemaster as cm join enrollmentmaster as em
  on cm.cid=em.cid
    join studentmaster as sm
on sm.sid=em.sid
where datediff(dd,doe,getdate())=0




--question 9.	List the names of the Local students who have enrolled for exactly 3 basic courses
--solution: 9
select  coursename,cm.cid, sm.name as [students],origin as [local students] from
  coursemaster as cm join enrollmentmaster as em
  on cm.cid=em.cid
    join studentmaster as sm
on sm.sid=em.sid
where origin='L' and cm.cid in (10,20,30)





--question 10 	List the names of the Courses enrolled by all (every) students
--solution 10
solution: select coursename from
  coursemaster as cm join enrollmentmaster as em
  on cm.cid=em.cid
    join studentmaster as sm
on sm.sid=em.sid


--question 11.	For those enrollments for which fee have been waived, provide the names of students who have got ‘O’ grade.
--solution 11
select name from
  coursemaster as cm join enrollmentmaster as em
  on cm.cid=em.cid
    join studentmaster as sm
on sm.sid=em.sid
where fwf=1 and grade='o'


--question 12	List the names of the foreign, undergraduate students who have got grade ‘C’ in any basic course
--solution: 12
select name,origin,type from
  coursemaster as cm join enrollmentmaster as em
  on cm.cid=em.cid
    join studentmaster as sm
on sm.sid=em.sid
where origin='F' and grade='C' and type='U'



--question 13 List the course name, total no. of enrollments in the current month.
--solution: 13
select datediff(mm,doe,getdate()) as [current month],coursename from
  coursemaster as cm join enrollmentmaster as em
  on cm.cid=em.cid
    join studentmaster as sm
on sm.sid=em.sid
where datediff(mm,doe,getdate())=0








