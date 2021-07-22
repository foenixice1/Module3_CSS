create database danhsachSV;
use danhsachSV;

create table tblKhoa(
k_ID int not null primary key,
k_Ten varchar(20)
);

create table tblLop(
l_ID int not null primary key,
l_Ten varchar(20),
l_Khoa int,
foreign key (l_Khoa) references tblKhoa(k_ID)
);
create table tblSinhVien(
sv_Maso int not null primary key,
sv_Hodem varchar(30),
sv_Ten varchar(15),
sv_Ngaysinh date,
sv_Lop int,
sv_DiemTB float(3,2),
foreign key (sv_Lop) references tblLop(l_ID)
);

alter table tblSinhVien modify column sv_DiemTB double;
insert into tblKhoa value (1,'CNTT'),(2,'TNMT'),(3,'BCVT');
insert into tblLop value (1,'C01',1),(2,'C02',2),(3,'C03',3);
insert into tblSinhVien value (1,'Nguyen','Nam','1999-04-05',1,10.0),(2,'Nguyen','Hung','2000-10-04',2,8.2)
,(3,'Dang','Dung','1991-02-02',3,5.1);

select * from tblSinhVien;

select sv_Maso,concat(sv_Hodem , " ", sv_Ten) as 'Ho va Ten', (year(now())-year(sv_Ngaysinh)) as Tuoi from tblSinhVien;
select sv_Maso,sv_Hodem,sv_Ten,sv_Ngaysinh from tblSinhvien;

select * from tblLop;
select * from tblKhoa;

-- Xếp loại sinh viên loại giỏi, loại khá, loại trung bình (trong cùng 1 query
select * , (case when sv_diemtb >= 8 then 'Gioi' when sv_diemtb > 6.5 then 'Kha' 
else 'Trung binh' end) as ' Xep Loai' from tblsinhvien;

select tblSinhVien.sv_HoDem, tblSinhVien.sv_Ten, tblSinhVien.sv_DiemTB, tblLop.l_Ten, tblKhoa.k_Ten from ((tblSinhVien
inner join tblLop on tblSinhVien.sv_Lop = tblLop.l_ID)
inner join tblKhoa on tblLop.l_Khoa = tblKHoa.k_ID)
where tblKhoa.k_Ten = 'CNTT';

-- Số lượng sinh viên loại giỏi, loại khá, loại trung bình (trong cùng 1 query)
select l_ten, count(case when sv_diemtb >= 8 then 'Gioi' end) as 'Gioi',
count(case when sv_diemtb >= 6.5 and sv_diemtb < 8.0 then 'Kha' end) as 'Kha'
from tblsinhvien inner join tbllop on tbllop.l_id = tblsinhvien.sv_lop group by tbllop.l_ten;

-- Số lượng sinh viên loại giỏi, khá, trung bình của từng lớp (trong cùng 1 query)
select l_ten as TenLop , sum(if(sv_diemtb >= 8.0 ,1,0)) as Gioi,
 sum(if(sv_diemtb < 8.0 and sv_diemtb >= 5.0 ,1,0)) as Kha,
 sum(if(sv_diemtb < 5.0 and sv_diemtb >=0 ,1,0)) as TB
 from tblsinhvien join tblLop on tblsinhvien.sv_lop = tblLop.l_id ;
 
 -- Tên lớp, danh sách các sinh viên của lớp sắp xếp theo điểm trung bình giảm dần
 select l_ten as TenLop, concat(sv_hodem , ' ' , sv_ten) as HoTen , sv_diemtb as DiemTB from tblsinhvien inner join tbllop 
 on tblsinhvien.sv_lop = tblLop.l_id order by sv_diemtb desc ;  

-- Tên lớp, tổng số sinh viên của lớp
select l_ten as TenLop,
sum(if( tbllop.l_id = tblsinhvien.sv_lop  ,1 ,0)) as "Tong So SV"
from tbllop join tblsinhvien on
tbllop.l_id = tblsinhvien.sv_lop
group by tbllop.l_id;

-- Tên khoa, tổng số sinh viên của khoa
select k_ten as TenKhoa,
sum(if( tbllop.l_id = tblsinhvien.sv_lop and tbllop.l_khoa = tblkhoa.k_id ,1 ,0)) as "Tong So SV"
from tbllop join tblsinhvien on
tbllop.l_id = tblsinhvien.sv_lop
join tblkhoa on 
tbllop.l_khoa = tblkhoa.k_id
group by tblkhoa.k_id;

 -- Tên khoa, tên lớp, họ tên, ngày sinh, điểm trung bình của sinh viên có điểm trung bình cao nhất lớp 
select k_ten as TenNganh, l_ten as TenLop,concat(sv_hodem," ", sv_ten) as "Ho ten",sv_ngaysinh as NgaySinh, sv_diemtb as DiemTB from tblsinhvien
join tbllop on l_id = sv_lop
join tblkhoa on k_id = l_khoa
group by sv_lop
having sv_diemtb >= any (select sv_diemtb from tblsinhvien join tbllop on l_id = sv_lop group by l_id);

-- Tên khoa, Họ tên, ngày sinh, điểm trung bình của sinh viên có điểm trung bình cao nhất khoa
select k_ten as TenNganh,concat(sv_hodem," ", sv_ten) as "Ho ten",sv_ngaysinh as NgaySinh, sv_diemtb as DiemTB from tblsinhvien
join tbllop on l_id = sv_lop
join tblkhoa on k_id = l_khoa
group by k_id
having sv_diemtb >= any (select sv_diemtb from tblsinhvien join tbllop on l_id = sv_lop group by l_id)
