create database QLSV;
use QLSV;

create table Marks(
Mark int ,
SubjectsID int,
StudentID int,
foreign key (SubjectsID) references Subjects(SubjectsID)
);

create table ClassStudent(
StudentID int(4),
ClassID int(4),
foreign key (ClassID) references Class(ClassID)
);

create table Subjects(
SubjectsID int(4) primary key,
SubjectsName nvarchar(50)
);

create table Class(
ClassID int(4) primary key,
ClassName nvarchar(50)
);

create table Student(
StudentID int(4) primary key,
StudentName nvarchar(50),
Age int(4),
Email varchar(100),
foreign key (StudentID) references Marks(StudentID),
foreign key (StudentID) references ClassStudent(StudentID)
);

-- C1
select * from student;

-- C2
select * from Subjects;

-- C3
select StudentID,avg(mark) as DiemTB from Marks
group by StudentID;

-- C4 
select max(mark) as DiemCaoNhat, SubjectsName from Marks inner join Subjects
on marks.SubjectsID = Subjects.SubjectsID
group by StudentID;

-- C5
select StudentID , mark from Marks order by  mark desc;

-- C6
alter table subjects change column SubjectsName SubjectsName NVARCHAR(4000) ;

-- C7
UPDATE subjects SET SubjectsName = ' Day la mon hoc SQL' WHERE (SubjectsID = '1');
UPDATE subjects SET SubjectsName = ' Day la mon hoc Java' WHERE (SubjectsID = '2');
UPDATE subjects SET SubjectsName = ' Day la mon hoc C' WHERE (SubjectsID = '3');
UPDATE subjects SET SubjectsName = ' Day la mon hoc Visual Basic' WHERE (SubjectsID = '4');

-- C8
alter table student add check (age > 15 and age < 50);

-- C9
alter table Student
drop FOREIGN KEY `Student_ibfk_2`,
DROP FOREIGN KEY `Student_ibfk_1`;

alter table marks
drop FOREIGN KEY `marks_ibfk_1`;

alter table ClassStudent
drop FOREIGN KEY `ClassStudent_ibfk_1`;

-- C10 
delete from student where studentid = 1;

-- C11
alter table student add column status bit default 1;

-- C12
update student set status = 0 where studentid = 2;
update student set status = 0 where studentid = 3;
update student set status = 0 where studentid = 4;
