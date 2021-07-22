create database QuanLyVanTai;
use QuanLyVanTai;

create table ChiTietVT(
mavt int primary key,
soxe nvarchar(50),
matrongtai  nvarchar(50),
malotrinh  nvarchar(50),
soluongVT int,
ngaydi date,
ngayden date,
foreign key (matrongtai) references trongtai(matrongtai),
foreign key (malotrinh) references lotrinh(malotrinh)
);

create table LoTrinh(
malotrinh  nvarchar(50) primary key,
tenlotrinh nvarchar(50),
dongia int,
timeDG int
);

create table TrongTai(
matrongtai  nvarchar(50) primary key,
TrongtaiDG int
);

-- C2 Tạo view gồm các trường SoXe, MaLoTrinh, SoLuongVT, NgayDi, NgayDen, ThoiGianVT, CuocPhi, Thuong
create view cau2 as  
select distinct soxe,lotrinh.malotrinh,soluongvt,ngaydi,ngayden,(case when ngayden - ngaydi = 0 then 1 else  datediff(NgayDen, NgayDi)
 end ) as 'Thoi Gian', 
(soluongvt * dongia * 105/100 ) as cuocphi , ((soluongvt * dongia * 105/100 ) * 5/100) as thuong
from lotrinh join chitietvt on lotrinh.malotrinh = chitietvt.malotrinh;

select * from cau2;

-- C3 Tạo view để lập bảng cước phí gồm các trường SoXe, TenLoTrinh, SoLuongVT, NgayDi, NgayDen, CuocPhi
create view cau3 as
select  SoXe, TenLoTrinh, SoLuongVT, NgayDi, 
NgayDen, CuocPhi from lotrinh join cau2 on lotrinh.malotrinh = cau2.malotrinh;

select * from cau3;

-- C4 Tạo view danh sách các xe có có SoLuongVT vượt trọng tải qui định, gồm các trường SoXe, TenLoTrinh, SoLuongVT, TronTaiQD, NgayDi, NgayDen.
create view cau4 as
select distinct cau3.SoXe, cau3.TenLoTrinh, cau3.SoLuongVT, TrongtaiDG, cau3.NgayDi, cau3.NgayDen
from trongtai join chitietvt on trongtai.matrongtai = chitietvt.matrongtai
join cau3 on chitietvt.soxe = cau3.soxe where cau3.soluongvt > TrongtaiDG ;

select * from cau4;





