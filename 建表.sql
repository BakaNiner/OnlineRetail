
CREATE DATABASE OnlineRetail;
GO


/* Change to the OnlineRetail database */
USE OnlineRetail;
GO

--------------------------------------------------------------------
/* Create tables */
CREATE TABLE Customer(
    customerID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    userName NVARCHAR(32) NOT NULL ,
    encryptedPassword NVARCHAR(512) NOT NULL ,
) ;

CREATE TABLE Product(
    productID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    productName NVARCHAR(128) NOT NULL ,
    productDescription NVARCHAR(512)  ,
    productFigure NVARCHAR(32)  ,
    categoryID INT NOT NULL ,
    productPrice FLOAT(53) NOT NULL ,
    saleAmount INT NOT NULL ,
    stockAmount INT NOT NULL ,
) ;

CREATE TABLE OrderTable(
    orderID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    shippingAddressID INT NOT NULL ,
    customerID INT  ,
    totalAmount FLOAT(53) NOT NULL ,
    orderDate DATE NOT NULL ,
    is_complete VARCHAR(1) NOT NULL ,
) ;

CREATE TABLE ShoppingCart(
    customerID INT NOT NULL,
    productID INT NOT NULL,
    productQuantity INT NOT NULL ,
    addTime DATE NOT NULL ,
    PRIMARY KEY(customerID, productID),
) ;

CREATE TABLE ShipAddress(
    addressID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    streetAddress NVARCHAR(128) NOT NULL ,
    cityName NVARCHAR(128) NOT NULL ,
    provinceName NVARCHAR(128) NOT NULL ,
    postalCode VARCHAR(32)  ,
    customerID INT NOT NULL ,
    phoneNumber NVARCHAR(32) NOT NULL ,
    is_default VARCHAR(1)  ,
) ;

CREATE TABLE Category(
    categoryID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    productCategory NVARCHAR(128) NOT NULL ,
) ;


CREATE TABLE Review(
    reviewID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    reviewerID INT  ,
    productID INT  ,
    grade INT  ,
    comment NVARCHAR(512)  ,
    reviewTime DATE  ,
) ;

CREATE TABLE OrderItem(
    orderID INT NOT NULL,
    itemID INT NOT NULL,
    quantity INT NOT NULL ,
    totalAmount FLOAT(53) NOT NULL ,
    PRIMARY KEY(orderID, itemID),
) ;
GO

--------------------------------------------------------------------
/* Insert values */
INSERT INTO Customer
VALUES
('Alice', '2b4148cd3af87d0801a3ccb12aff6cd648c3dd0d59a3fad9ef004c35556c28c4'),
('Bob', '23a2b31ffd654241a558e4895fb86532ce32e31d3e0bbd51fec07f6e1ef8a4b8'),
('Carol', '8db399939d82aed7fb2eb5f21ffabbda9fd4acc0d9f30215eb9cd8d5f33ecc60'),
('Dave', '3b4d4053193f863a441afa01237779dc1b2cc6199e48ec0dc49929982d7ffd3f'),
('Eve', '772ea1489c4fc641823e092d6afb977d86b3fddeba9ca2436812c5057b18acc0'),
('Francis', '23f4667c14e6154ca2322e979808d733fc60f2d38b32ef5b0f962cf31cabb47c'),
('Grace', '5c6e9ce66cd85898720fcc906a5ccd2e8447deea99e81ac3c46a6563b29200bf'),
('Hans', '67fb418021091acb36222ec8c06564b7c7f4bcc3bee330ed025d1d5ec136add9'),
('Isabella', 'e923e2933d19142ecfb3bba356f0cc5bd5a03c5232406a97df7d6b1d4009a9c0'),
('Jones', '349096910d3c474b61ec0cc741486084dbd9c8f2a57e37557b35c7ab5e6205f3');

INSERT INTO Category
VALUES
('REFRIGERATORS'),
('BATH FAUCETS & SHOWER HEADS'),
('BLINDS & WINDOW TREATMENTS'),
('FENCING'),
('INSULATION'),
('ENTRY DOORS'),
('GARAGE DOORS & ACCESSORIES'),
('HOME ELECTRONICS'),
('LIGHT BULBS'),
('KITCHEN SINKS'),
('CABINETS & CABINET HARDWARE'),
('KITCHEN ACCESSORIES'),
('LAWN CARE'),
('LANDSCAPING'),
('PATIO FURNITURE'),
('CLOSET STORAGE'),
('SHELVES & SHELF BRACKETS');

INSERT INTO Product
VALUES
('French Door Refrigerator','','static/images/1.jpg', 1,1978.2,20,20),
('Side By Side Refrigerator','','static/images/2.jpg', 1,1979,5,15),
('Top Freezer Refrigerator','','static/images/3.jpg', 1,1245.5,13,20),
('Bottom Freezer Refrigerator','','static/images/4.jpg', 1,1480.5,0,20),
('Bathroom Faucet','','static/images/5.jpg', 2,90,8,15),
('Shower Faucet','','static/images/6.jpg', 2,120,3,15),
('Shower Head','','static/images/7.jpg', 2,150,3,14),
('Bath Lighting','','static/images/8.jpg', 2,300,2,13),
('Blinds & Shades','','static/images/9.jpg', 3,60,12,15),
('Faux Wood Blinds','','static/images/10.jpg', 3,75,1,11),
('Cellular Shades','','static/images/11.jpg', 3,50,6,11),
('Window Film','','static/images/12.jpg', 3,95,15,18),
('Wood Fencing','','static/images/13.jpg', 4,10,8,10),
('Vinyl Fencing','','static/images/14.jpg', 4,20,2,10),
('Fiberglass Insulation','','static/images/15.jpg', 5,25,3,10),
('Rigid Insulation','','static/images/16.jpg', 5,20,1,5),
('Patio Doors','','static/images/17.jpg', 6,450,10,9),
('Screen Doors','','static/images/18.jpg', 6,500,6,10),
('Garage Doors','','static/images/19.jpg', 7,350,13,10),
('Garage Doors Openers','','static/images/20.jpg', 7,100,2,10),
('TVs','','static/images/21.jpg', 8,1250,4,11),
('Home Audio','','static/images/22.jpg', 8,750,6,12),
('LED Light Bulbs','','static/images/23.jpg', 9,80,7,12),
('CFL Light Bulbs','','static/images/24.jpg', 9,85,5,12),
('Stainless Steel Sinks','','static/images/25.jpg', 10,125,0,13),
('Apron Front Sinks','','static/images/26.jpg', 10,150,1,13),
('Cabinet Hardware','','static/images/27.jpg', 11,150,9,14),
('Water Filters','','static/images/28.jpg', 12,90,7,14),
('Grass Seed','','static/images/29.jpg', 13,100,16,20),
('Lawn Fertilizers','','static/images/30.jpg', 13,90,18,20),
('Pavers & Step Stones','','static/images/31.jpg', 14,95,3,20),
('Retaining Wall Blocks','','static/images/32.jpg', 14,45,4,20),
('Seating Sets','','static/images/33.jpg', 15,400,8,15),
('Chairs & Stools','','static/images/34.jpg', 15,200,1,4),
('Chaise Lounges','','static/images/35.jpg', 15,350,0,4),
('Sofas & Loveseats','','static/images/36.jpg', 15,200,5,5),
('Garment Racks','','static/images/37.jpg', 16,250,2,8),
('Shoe Storage','','static/images/38.jpg', 16,225,5 ,8),
('Wood Closet Organizers','','static/images/39.jpg', 16,100,6,9),
('Decorative Shelving','','static/images/40.jpg', 17,600,9,9)

INSERT INTO ShipAddress
VALUES
('24 South Walles','Chicago','IL', NULL, 1,'01-503-555-7555',1),
('15 West King Drive','Chicago','IL',NULL,1,'01-503-555-7555',0),
('08 North Michigan Avenue','Chicago','IL',NULL,2,'01-503-555-6874',1),
('451 Canal Street','Chicago','IL',NULL,3,'01-307-555-4680',1),
('55 Grizzly Peak Rd.','Butte','MT','59801',4,'01-406-555-5834',1),
('12 Orchestra Terrace','Walla Walla','WA','99362',4,'01-509-555-7969',0),
('87 Polk St. Suite 5','San Francisco','CA','94117',5,'01-415-555-5938',1),
('12 Orchestra Terrace','Kirkland','WA','98034',6,'01-206-555-8257',1),
('89 Chiaroscuro Rd.','Portland','OR','97219',6,'01-503-555-9573',0),
('2743 Bering St.','Anchorage','AK','99508',6,'01-907-555-7584',0),
('187 Suffolk Ln.','Boise','ID','83720',7,'01-208-555-8097',1),
('55 Grizzly Peak Rd.','Butte','MT','59801',8,'01-406-983-6100',1),
('305 - 14th Ave. S. Suite 3B','Seattle','WA','98128',9,'01-206-555-4112',1),
('17030 N 49th st','Phoenix','AZ','85254',10,'01-623-787-9922',1),
('1654 Columbia St','San Diego','CA','92101',10,'01-619-427-0121',0);


INSERT INTO ShoppingCart
VALUES
(1,1,1,1978.2,'2020-05-20'),
(2,1,1,1978.2,'2020-05-20'),
(3,11,5,250,'2020-05-20'),
(4,9,2,120,'2020-05-20'),
(5,36,1,200,'2020-05-20'),
(6,25,1,125,'2020-05-20');

INSERT INTO OrderTable
VALUES
(1,1,75,'2020-05-20',1);

INSERT INTO OrderItem
VALUES
(1,10,1,75);

INSERT INTO Review
VALUES
(1,10,3,'No wonder no one likes it.','2020-05-20');
GO

--------------------------------------------------------------------
/* Select data */
/*
SELECT * FROM Review
*/




--------------------------------------------------------------------
/* Drop tables */
/*
DROP TABLE Customer
DROP TABLE Product
DROP TABLE Category
DROP TABLE ShoppingCart
DROP TABLE OrderItem
DROP TABLE OrderTable
DROP TABLE ShipAddress
DROP TABLE Review
*/