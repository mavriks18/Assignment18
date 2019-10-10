CREATE TABLE `storeusers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `EmployeeName` varchar(50) DEFAULT NULL,
  `StoreUserName` varchar(50) DEFAULT NULL,
  `StorePassword` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

CREATE TABLE `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `productName` varchar(50) DEFAULT NULL,
  `unitPrice` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;

CREATE TABLE `employeecart` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `employeeId` int(11) DEFAULT NULL,
  `itemId` int(11) DEFAULT NULL,
  `itemCount` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_empId` (`employeeId`),
  KEY `fk_itemId` (`itemId`),
  CONSTRAINT `fk_empId` FOREIGN KEY (`employeeId`) REFERENCES `storeusers` (`id`),
  CONSTRAINT `fk_itemId` FOREIGN KEY (`itemId`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;

CREATE TABLE `employeeorder` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `employeeId` int(11) DEFAULT NULL,
  `itemId` int(11) DEFAULT NULL,
  `itemCount` int(11) DEFAULT NULL,
  `orderStatus` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_empId_order` (`employeeId`),
  KEY `fk_itemId_order` (`itemId`),
  CONSTRAINT `fk_empId_order` FOREIGN KEY (`employeeId`) REFERENCES `storeusers` (`id`),
  CONSTRAINT `fk_itemId_order` FOREIGN KEY (`itemId`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8;


insert into estore.storeusers (EmployeeName, StoreUserName,StorePassword) values('Tom Lawrence','toml', 'toml1234');
insert into estore.storeusers (EmployeeName, StoreUserName,StorePassword) values('Tom Stevens','toms', 'toms1234');
insert into estore.storeusers (EmployeeName, StoreUserName,StorePassword) values('Ben Hutchkins','benh', 'benh1234');
insert into estore.storeusers (EmployeeName, StoreUserName,StorePassword) values('Ben Joe','benj', 'benj1234');
insert into estore.storeusers (EmployeeName, StoreUserName,StorePassword) values('Mark Blake','marb', 'marb1234');
insert into estore.storeusers (EmployeeName, StoreUserName,StorePassword) values('Will Craig','wilg', 'wilg1234');

insert into estore.products(productName, unitPrice) values ('Pen', 12);
insert into estore.products(productName, unitPrice) values ('Marker', 20);
insert into estore.products(productName, unitPrice) values ('Highlighter', 28);
insert into estore.products(productName, unitPrice) values ('Notepad', 15);
insert into estore.products(productName, unitPrice) values ('Post-it Note', 35);
insert into estore.products(productName, unitPrice) values ('Stapler', 52);
insert into estore.products(productName, unitPrice) values ('Board Pin', 20);
insert into estore.products(productName, unitPrice) values ('Monitor Wipes', 20);
insert into estore.products(productName, unitPrice) values ('Pencil', 30);
insert into estore.products(productName, unitPrice) values ('Pencil Sharpner', 10);
insert into estore.products(productName, unitPrice) values ('Pencil Eraser', 10);
insert into estore.products(productName, unitPrice) values ('Whitener', 25);



DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `addUpdateCart`(IN _employeeid int, IN _itemId int, IN _itemCount int)
BEGIN
IF (select count(*) from estore.employeecart where employeeid=_employeeid and itemid=_itemId) > 0 then
update estore.employeecart set itemCount = _itemCount where employeeid=_employeeid and itemid=_itemId;
else
insert into estore.employeecart (employeeid,itemid,itemcount) values(_employeeid,_itemId,_itemCount);
end if;
select ec.itemid,ec.itemcount, pr.productName from estore.employeecart ec 
join products pr on pr.id = ec.itemId  
where ec.employeeid=_employeeid;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `addUpdateEmployeeOrder`(in id int, in cartid int, in orderstatus int)
BEGIN
if id >0 then
update employeeorder set cartid = cartid, orderstatus = orderstatus where id=id;
else
insert into employeeorder (cartid, orderstatus) values (cartid,orderstatus);
end if;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `authenticateUser`(IN username varchar(50), IN pwd varchar(50))
BEGIN
select * from estore.storeusers where StoreUserName = username and StorePassword=pwd;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllProducts`()
BEGIN
select * from estore.products;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `placeOrder`(IN _employeeId int)
BEGIN
delete from estore.employeeorder where employeeId = _employeeId ;
insert into estore.employeeorder (employeeId, itemId,itemCount, orderStatus)
select employeeId, itemId,itemCount, 1 as orderStatus 
from estore.employeecart where employeeId =_employeeId;
delete from estore.employeecart  where employeeId = _employeeId ;
select employeeId, itemId,itemCount,'Ordered' as orderStatus 
from estore.employeeorder where employeeId = _employeeId ;
 
END$$
DELIMITER ;





