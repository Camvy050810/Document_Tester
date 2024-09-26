create database DiamondPlace
go
use DiamondPlace
go

create table BillDetail(
	IDBillDetail int IDENTITY(1,1) primary key,
	IDOrder nvarchar(20),
	DateOrder date,
	TimeOrder nvarchar(20),
	Username nvarchar(20),
	SubTotal float,
	DiscountPromo float, 
	Total float,
	pay float,
	readyCash float,
	payMents float
	CONSTRAINT fk_id_BillDetailOrder
   FOREIGN KEY (IDOrder)
   REFERENCES [Order] (IDOrder)
)

Create table BillProduct(	
	IDBillProduct int IDENTITY(1,1) primary key,
	IDOrder nvarchar(20),
	ProductName nvarchar(50),
	Quantity int,
	Price float,
	IntoMoney float,
	
   CONSTRAINT fk_id_BillProductOrder
   FOREIGN KEY (IDOrder)
   REFERENCES [Order] (IDOrder)

)

create table Account(
Fullname nvarchar(50),
Username nvarchar(20) primary key,
[Password] nvarchar(20) ,
Gender bit,
Birthday date,
Phone varchar(12),
Email nvarchar(50),
[Address] nvarchar(255),
[Role] bit
)

create table ProductType(
IDType nvarchar(20) primary key ,
NameType Nvarchar(50),
)

create table Promotions(
IDPromo nvarchar(20) primary key,
NamePromo nvarchar(50),
DiscountPromo float,
[Description] nvarchar(255)
)

create table [Order](
IDOrder nvarchar(20) primary key,
DateOrder date,
TimeOrder nvarchar(20),
IDPromo nvarchar(20) references Promotions(IDPromo)on delete no action,
TotalPrice float,
Username nvarchar(20) references Account(Username) on delete no action,
)

create table Product(
IDProduct nvarchar(20) primary key,
ProductName nvarchar(50),
IDType nvarchar(20) references [ProductType](IDType) on delete no action,
Price float,
[Image] nvarchar(255),
[Description] nvarchar(255)
)

create table OrderDetails(
IDOrderDetails int identity(1,1) primary key,
IDProduct nvarchar(20) references Product(IDProduct)on delete no action,
IDOrder nvarchar(20) references [Order](IDOrder)on delete CASCADE,
Quantity int,
TotalPrice float,
Timeod date
)
create table the_Last_Login(
	remember bit
)
go

insert into the_Last_Login values(0)
go

create trigger trg_XoaDonHang on [Order] after delete as
begin
	delete from OrderDetails 
	where IDorder like (select IDOrder from deleted)
end
go

create proc [dbo].[sp_DoanhThu](@DateMonth int, @DateYears int)
as begin
	select 
		pro.IDProduct,
		pro.ProductName,
		SUM(oddt.Quantity) as 'Soluong',
		(SUM(oddt.Quantity * pro.Price)) - (SUM(oddt.Quantity * pro.Price) - SUM(oddt.TotalPrice)) as 'DoanhThu'
	from Product pro
		join OrderDetails oddt on oddt.IDProduct = pro.IDProduct
		join [Order] od on od.IDOrder = oddt.IDOrder
	where Month(oddt.Timeod) = @DateMonth and year(oddt.Timeod) = @DateYears
	group by pro.IDProduct,pro.ProductName
end
go

insert into Account 
values 
(N'Huỳnh Văn Kiệt','kiethv','123',0,'01/01/2003','0397464965','huynhvankiet@gmail.com',N'Bến Tre',1),
(N'Phạm Gia Hào','haopg','123',0,'02/01/2003','0337564961','phamgiahao@gmail.com',N'Hồ Chí Minh',1),
(N'Trần Nhật Đan','dantn','123',0,'03/01/2003','0323190884','trannhatdan@gmail.com',N'Hồ Chí Minh',1),
(N'Nguyễn Văn Tèo','teonv','123',0,'04/01/2001','0312356564','nguyenvanteo@gmail.com',N'Đà Nẵng',0),
(N'Trần Văn Trung','trungtv','123',0,'05/01/1992','0213123144','Tranvantrung@gmail.com',N'Đồng Nai',0),
(N'Nguyễn Tuấn Kiệt','kiennt','123',0,'06/01/1999','0393213123','nguyentrungkien@gmail.com',N'Hà Nội',0),
(N'Nguyễn Trần Nờ Hiếu','Hieuntn','123',0,'07/01/2000','0123145455','nguyentrungngochieu@gmail.com',N'Thanh Hóa',0),
(N'Huỳnh Ngọc Hân','hanhn','123',1,'08/01/1985','0354355335','huynhngochan@gmail.com',N'Tây Ninh',1),
(N'Nguyễn Thị Bảo Ngọc','ngocntb','123',1,'09/01/1950','0397464965','nguyenthibaongoc@gmail.com',N'Hồ Chí Minh',1)
go


insert into ProductType 
values
('T6',N'Nước uống'),
('T1',N'xào'),
('T2',N'Chiên'),
('T3',N'Nướng'),
('T4',N'Lẩu'),
('T5',N'Ăn Vặt')
go
insert into Product
values
('HS03',N'Lòng xào dưa',N'T1',150000,'',N'Lòng xào dưa thơm béo có thể gia giảm theo khẩu vị'),
('N03',N'Thịt bò nướng muối hima',N'T3',300000,'',N'Thịt bò nướng muối hồng himalaya'),
('L03',N'Lẫu tomyum kiểu thái',N'T4',250000,'',N'Thịt và nước lẩu tomyum chua chua'),
('AV03',N'Chè táo đỏ hạt sen',N'T5',200000,'',N'Chè táo đỏ ninh cùng hạt sen mát lạnh'),
('AV04',N'Rau câu uyên ương',N'T5',300000,'',N'Rau câu trái cây và phô mai được rướt sữa chua'),
('L04',N'Soup thịt cua tóc tiên',N'T4',800000,'',N'Thịt cua xé nhỏ kèm tóc tiên và nấm đông cô'),
('HS04',N'Gỏi bắp bò đồng quê',N'T1',780000,'',N'Gỏi bắp chuối kèm bắp bò thơm ngon'),
('N04',N'Bacon cuộn tôm sốt BBQ',N'T3',890000,'',N'Bacon cuộn kèm tôm'),
('NU02',N'Hồng trà Diamond',N'T6',42000,'',N'Hồng trà truyền thống do diamond phát triển'),
('NU01',N'Trà đào cam xả',N'T6',38000,'',N'Trà đào truyền thống'),
('NU03',N'Trà sữa trân trâu đường đen',N'T6',40000,'',N'Trà đen pha cùng sữa béo kèm trân trâu sần sật'),
('NU04',N'Trà sữa trân trâu đường đen matcha',N'T6',45000,'',N'Trà đen pha cùng sữa béo kèm trân trâu sần sật từ matcha'),
('NU05',N'Sữa tươi kem trứng',N'T6',40000,'',N'Sữa tươi trân trâu cùng lớp kem trứng béo ngậy trên cùng'),
('NU06',N'Trà dưa lưới hạt CHI-A',N'T6',35000,'',N'Trà dưa lưới thơm ngọt kèm hạt Chi-a tốt cho sức khoẻ'),
('HS01',N'Bắp xào',N'T1',100000,'',N'Bắp xào bơ'),
('C01',N'Cá Chiên',N'T2',120000,'',N'Cá Hồi Chiên'),
('N01',N'Gà Nướng',N'T3',300000,'',N'Gà nướng nguyên con'),
('AV01',N'Khoai Tây Chiên',N'T5',10000,'',N'Lát khoai tây nhỏ'),
('AV02',N'Trái cây dĩa',N'T5',30000,'',N'Trái cây cắt nhỏ'),
('L01',N'Lẩu cá hồi',N'T4',200000,'',N'Nước lẫu và cá hồi'),
('HS02',N'Mực xào',N'T1',150000,'',N'Mực xào ớt chuông'),
('N02',N'Thịt bò nướng',N'T3',150000,'',N'Thịt bò'),
('L02',N'Lẫu thái',N'T4',200000,'',N'Thịt và nước lẩu')
go

insert into Promotions
values
('KM00',N'Không có',0,N'Không có khuyến mãi'),
('KM01',N'Khuyến mãi 20/11',0.1,N'Khuyến mãi dành cho giáo viên ngày 20/11'),
('KM02',N'Khuyến mãi Sinh viên FPT',0.2,N'Khuyến mãi dành cho sinh viên FPT'),
('KM03',N'Khuyến mãi quản lý',0.11,N'Khuyến mãi dành cho quản lý của siêu thị'),
('KM04',N'Khuyến mãi tết âm lịch',0.5,N'Khuyến mãi dành cho những ngày tết âm lịch'),
('KM05',N'Khuyến mãi tết dương lịch',0.1,N'Khuyến mãi dành cho những ngày tết dương lịch'),
('KM06',N'Khuyến mãi ngày quốc khánh',0.3,N'Khuyến mãi dành cho ngày quốc khánh'),
('KM07',N'Khuyến mãi khách hàng mua nhiều',0.15,N'Khuyến mãi dành cho khách hàng mua trên 10 món'),
('KM08',N'Khuyến mãi đặt bàn trước',0.12,N'Khuyến mãi dành cho những khách hàng đặt bàn trước')
go

insert into [Order]
values
('DH01','01/11/2022','11:00','KM01',900000,'kiethv'),
('DH02','04/11/2022','20:30','KM02',1800000,'dantn'),
('DH03','02/11/2022','9:00','KM03',2310000,'haopg'),
('DH04','03/11/2022','12:00','KM04',20000,'haopg'),
('DH05','05/12/2022','21:00','KM02',850000,'kiethv'),
('DH06','06/12/2022','22:00','KM06',290000,'kiethv'),
('DH07','08/12/2022','15:00','KM07',970000,'dantn'),
('DH08','07/12/2022','12:00','KM01',1550000,'haopg'),
('DH09','09/12/2022','21:00','KM08',1420000,'kiethv'),
('DH010','10/12/2022','15:00','KM01',840000,'dantn'),
('DH011','11/25/2022','15:00','KM00',520000,'dantn'),
('DH012','12/12/2022','15:00','KM00',230000,'dantn')

go

insert into OrderDetails values
('C01','DH01',5,700000,'01/11/2022'),
('L01','DH01',1,200000,'01/11/2022'),
('HS01','DH02',2,20000,'04/11/2022'),
('N01','DH03',3,500000,'02/11/2022'),
('L01','DH03',5,200000,'02/11/2022'),
('C01','DH03',2,150000,'02/11/2022'),
('HS02','DH04',5,270000,'03/11/2022'),
('AV01','DH04',5,20000,'03/11/2022'),
('L01','DH05',1,200000,'05/12/2022'),
('C01','DH05',1,100000,'05/12/2022'),
('AV01','DH05',2,20000,'05/12/2022'),
('N01','DH05',2,400000,'05/12/2022'),
('HS01','DH05',5,50000,'05/12/2022'),
('AV02','DH05',5,200000,'05/12/2022'),
('C01','DH06',5,200000,'06/12/2022'),
('AV01','DH06',3,150000,'06/12/2022'),
('L01','DH06',3,600000,'06/12/2022'),
('AV01','DH06',5,200000,'06/12/2022'),
('N01','DH06',2,400000,'06/12/2022'),
('C01','DH07',5,700000,'08/12/2022'),
('L01','DH07',1,200000,'08/12/2022'),
('HS01','DH07',2,20000,'08/12/2022'),
('N01','DH07',3,500000,'08/12/2022'),
('L01','DH08',5,200000,'07/12/2022'),
('C01','DH08',2,150000,'07/12/2022'),
('HS02','DH08',5,270000,'07/12/2022'),
('AV01','DH08',5,20000,'07/12/2022'),
('L01','DH08',1,200000,'07/12/2022'),
('C01','DH09',1,100000,'09/12/2022'),
('AV01','DH09',2,20000,'09/12/2022'),
('N01','DH09',2,400000,'09/12/2022'),
('HS01','DH010',5,50000,'10/12/2022'),
('AV02','DH010',5,200000,'10/12/2022'),
('C01','DH010',5,200000,'10/12/2022'),
('AV01','DH010',3,150000,'10/12/2022'),
('L01','DH010',3,600000,'10/12/2022'),
('AV01','DH010',5,200000,'10/12/2022'),
('N01','DH010',2,400000,'10/12/2022'),
('AV03','DH011',1,100000,'11/25/2022'),
('AV04','DH011',1,110000,'11/25/2022'),
('HS03','DH011',1,120000,'11/25/2022'),
('HS04','DH011',1,130000,'11/25/2022'),
('L03','DH011',1,140000,'11/25/2022'),
('L04','DH011',1,150000,'11/25/2022'),
('N03','DH011',1,160000,'11/25/2022'),
('N04','DH011',1,170000,'11/25/2022'),
('NU01','DH011',1,180000,'11/25/2022'),
('NU02','DH011',1,190000,'11/25/2022'),
('NU03','DH011',1,200000,'11/25/2022'),
('NU04','DH011',1,210000,'11/25/2022'),
('NU05','DH011',1,220000,'11/25/2022'),
('NU06','DH011',1,230000,'11/25/2022'),
('NU06','DH012',1,230000,'12/12/2022')
go

