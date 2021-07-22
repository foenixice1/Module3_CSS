create database qlbanhang;
use qlbanhang;
create table customer(
	CusID int auto_increment primary key,
    CusName varchar(45) not null,
    CusAge int
);
create table OrderCustomer(
	OrderID int auto_increment primary key,
	CusID int not null,
	OrderDate datetime not null,
	OrderTotalPrice int not null,
    foreign key (CusID) references customer(CusID)
);
create table product(
	ProductID int auto_increment primary key,
    ProductName varchar(45) not null,
    ProductPrice int not null
);
create table OrderDetail(
	OrderID int not null,
    ProductID int not null,
    OrderQuantity int not null,
    primary key (OrderID, ProductID),
    foreign key(OrderID) references OrderCustomer(OrderID),
    foreign key(ProductID) references product(ProductID)
);

insert into customer values (1,'Minh Quan',10), (2,'Ngoc Oanh',20), (3,'Hong Ha',50);
insert into ordercustomer (cusId,orderdate) 
values (1,'2006/3/21');
insert into ordercustomer (cusId,orderdate) 
values (2,'2006/3/23');


insert into product (productname, productprice)
values ('May giat',3), ('Tu lanh',5),('Dieu hoa',7),('Quat',1),('Bep dien',2);



select orderID, orderDate, ordertotalprice
from ordercustomer;

select c.cusname, p.productname
from customer c, ordercustomer oc, orderdetail od, product p
where c.cusid = oc.cusid 
and oc.orderid = od.orderid
and od.productid = p.productid;

select cusname from customer
where customer.cusid not in (select cusid from ordercustomer);

select oc.orderID, oc.orderdate, sum(orderquantity*productprice) as ordertotalprice
from ordercustomer oc, orderdetail od, product p
where oc.orderID = od.orderID and od.productID = p.productid
group by oc.orderID;
