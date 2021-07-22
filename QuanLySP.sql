create database quanlysanpham;
use quanlysanpham;
create table khachhang(
makh int primary key,
hoten nvarchar(45)
);
create table hang(
masp int primary key,
tensp nvarchar(45),
gia int
);
create table hoadon(
sohoadon int primary key,
makh int,
ngayxuat date,
trigia int,
foreign key (makh) references khachhang(makh)
);
create table chitiet(
sohoadon int,
masp int,
soluong int,
primary key (sohoadon,masp),
foreign key (sohoadon) references hoadon(sohoadon),
foreign key (masp) references hang(masp)
);
insert into khachhang(makh, hoten)
value (1,"Toan"),
(2,"Tám"),
(3,"Chung"),
(4,"Hưng"),
(5,"Hoàng"),
(6,"Nguyễn Văn A");
insert into hang (masp, tensp, gia)
value (1,"Máy giặt",50),
(2,"Tủ lạnh",100),
(3,"Hảo Hảo tôm chua cay",10),
(4,"Red bull",15);
insert into hoadon (sohoadon,makh,ngayxuat)
value(1,1,"2006-10-05"),
(2,1,"2007-06-19"),
(3,6,"2006-10-05"),
(4,2,"2006-06-19"),
(5,3,"2006-06-20");
insert into chitiet(sohoadon, masp, soluong)
value
(2,1,10);

--  In ra các số hóa đơn, trị giá hóa đơn bán ra trong ngày 19/6/2006 và ngày 20/6/2006.
select hoadon.sohoadon, sum(hang.gia * chitiet.soluong) as trigia 
from hoadon join hang join chitiet on chitiet.sohoadon = hoadon.sohoadon and
hang.masp = chitiet.masp
where ngayxuat between "2006-06-19" and "2006-06-20"
group by hoadon.sohoadon;

--  In ra các số hóa đơn, trị giá hóa đơn trong tháng 6/2007, sắp xếp theo ngày (tăng dần) và trị giácủa hóa đơn (giảm dần).
select hoadon.sohoadon, sum(hang.gia * chitiet.soluong) as trigia 
from hoadon join hang join chitiet on chitiet.sohoadon = hoadon.sohoadon and
hang.masp = chitiet.masp
where ngayxuat like "2007-06%"
group by hoadon.sohoadon
order by hoadon.sohoadon asc,trigia desc;

-- In ra danh sách các khách hàng (MAKH, HOTEN) đã mua hàng trong ngày 19/06/2007.
select khachhang.* from khachhang join hoadon on khachhang.makh = hoadon.makh
where hoadon.ngayxuat like "2007-06-19";

-- In ra danh sách các sản phẩm (MASP,TENSP) được khách hàng có tên “Nguyen Van A” muatrong tháng 10/2006.
select hang.masp, hang.tensp from hang
join hoadon
join khachhang
join chitiet on
chitiet.sohoadon = hoadon.sohoadon and chitiet.masp = hang.masp and hoadon.makh = khachhang.makh
where khachhang.hoten like "Nguyễn Văn A";

-- Tìm các số hóa đơn đã mua sản phẩm “Máy giặt” hoặc “Tủ lạnh”.
select hoadon.sohoadon from hoadon
inner join hang
inner join chitiet
on chitiet.masp = hang.masp and hoadon.sohoadon = chitiet.sohoadon
where hang.masp = 1 or hang.masp = 2
group by hoadon.sohoadon
order by hoadon.sohoadon asc;

--  Tìm các số hóa đơn đã mua sản phẩm “Máy giặt” hoặc “Tủ lạnh”, mỗi sản phẩm muavới số lượng từ 10 đến 20
select hoadon.sohoadon from hoadon
inner join hang
inner join chitiet
on chitiet.masp = hang.masp and hoadon.sohoadon = chitiet.sohoadon
where (hang.masp = 1 or hang.masp = 2) and (chitiet.soluong between 10 and 20)
group by hoadon.sohoadon
order by hoadon.sohoadon asc;

-- Tìm các số hóa đơn mua cùng lúc 2 sản phẩm “Máy giặt” và “Tủ lạnh”, mỗi sản phẩm mua với số lượng từ 10 đến 20.
select sohoadon from chitiet
inner join hang on chitiet.masp = hang.masp
where (tensp like"Máy giặt" or tensp like "Tủ lạnh") and (soluong between 10 and 20)
group by sohoadon
having count(sohoadon) = 2;

select  sohoadon from chitiet 
inner join hang on chitiet.sohoadon = hang.masp
where (tensp like "may giat" or tensp like "tu lanh") and (soluong>=5 and soluong<=10) group by sohoadon having count(sohoadon)=2;

-- In ra danh sách các sản phẩm (MASP,TENSP) không bán được.
select masp,tensp from hang 
where not exists (select null from chitiet
where chitiet.masp = hang.masp);

-- In ra danh sách các sản phẩm (MASP,TENSP) không bán được trong năm 2006.
select masp,tensp from hang 
where not exists (select null from chitiet
join hoadon on chitiet.sohoadon = hoadon.sohoadon
where chitiet.masp = hang.masp
and ngayxuat like "2006%");

-- In ra danh sách các sản phẩm (MASP,TENSP) có giá >300 sản xuất bán được trong năm2006.
select hang.masp,tensp from hang join hoadon
join chitiet on hoadon.sohoadon = chitiet.sohoadon and hang.masp = chitiet.masp
where hoadon.ngayxuat like "2006%" and hang.gia >300
group by tensp;

-- 26
select hoten from khachhang 
inner join hoadon on hoadon.makh = khachhang.makh
where hoadon.trigia = (select max(trigia) from hoadon where hoadon.ngayxuat like "2006%");

-- 28
select * from hang order by gia desc limit 3;

-- 29 
select * from
(select gia from hang
order by gia desc
limit 3) as topgiahang
join hang on hang.gia = topgiahang.gia
where tensp like "M%";


-- c39 
select sohoadon from chitiet  join hoadon on chitiet.sohoadon=hoadon.sohoadon
join hang on chitiet.masp=hang.masp
where gia<300 group by sohoadon
having count(sohoadon)=3 ;
/* nếu là mua đúng 3 sp <300 thì để =3 còn nếu mua nhiều hơn 3 sp thì >= */






