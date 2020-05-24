if exists (select * from sysdatabases where name='OnlineRetail')
		drop database OnlineRetail
create database OnlineRetail
go

/* Change to the OnlineRetail database */
USE OnlineRetail;
GO

if exists (select * from sysobjects where if exists (select * from sysdatabases where name='OnlineRetail')
		drop database OnlineRetail
create database OnlineRetail
go

/* Change to the OnlineRetail database */
USE OnlineRetail;
GO

if exists (select * from sysobjects where id = object_id('Customer'))
	drop table Customer
GO

if exists (select * from sysobjects where id = object_id('Product'))
	drop table Product
GO

if exists (select * from sysobjects where id = object_id('Category'))
	drop table Category
GO

if exists (select * from sysobjects where id = object_id('OrderTable'))
	drop table OrderTable
GO

if exists (select * from sysobjects where id = object_id('OrderItem'))
	drop table OrderItem
GO

if exists (select * from sysobjects where id = object_id('Review'))
	drop table Review
GO

if exists (select * from sysobjects where id = object_id('ShipAddress'))
	drop table ShipAddress

if exists (select * from sysobjects where id = object_id('ShoppingCart'))
	drop table ShoppingCart
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
    is_complete VARCHAR(1) DEFAULT NULL,
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
    is_default VARCHAR(1) DEFAULT 0,
) ;

CREATE TABLE Category(
    categoryID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    productCategory NVARCHAR(128) NOT NULL ,
) ;


CREATE TABLE Review(
    reviewID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    reviewerID INT  NOT NULL,
    productID INT  NOT NULL,
    grade INT  NOT NULL,
    comment NVARCHAR(512) ,
    reviewTime DATE  NOT NULL,
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
/*
('Alice', 'Alice9895'),
('Bob', 'lalala123456'),
('Carol', 'reallyStrongPwd666'),
('Dave', 'Yiheyuan5'),
('Eve', 'UnknownLake520'),
('Francis', '0.0and0.0'),
('Grace', 'Helloworld!'),
('Hans', 'loveyou3000'),
('Isabella', 'bella0504'),
('Jones', 'Physics');
*/

INSERT INTO Product
VALUES
('French Door Refrigerator','Get the storage you need in this refrigerator with water dispenser. An exterior refrigerated drawer keeps frequently used items within easy reach. This refrigerator with refrigerated drawers also gives you access to filtered ice and water without ever opening the door. Plus, the tap touch controls are as easy to clean as they are to use.','static/images/1.jpg', 1,1978.2,20,20),
('Side By Side Refrigerator','Fit and find it all with purposefully designed storage spaces in this certified refrigerator from Whirlpool. Get increased loading flexibility with adjustable gallon door bins. The exterior ice and water dispenser lets you access cool refreshments without opening the door while LED lights keep food looking as good as it tastes.','static/images/2.jpg', 1,1979,5,15),
('Top Freezer Refrigerator','Keep food fresh with Criterion top mount refrigerator. The convenient electronic temperature control allows you to keep food at the perfect temperature and E-Star qualified helps you save money on energy costs. Two adjustable full width spill-proof glass shelves and two crispers perfectly meet your storage needs, also a variety of door racks provide extra space and a half width dairy box is at your disposal.','static/images/3.jpg', 1,1245.5,13,20),
('Bottom Freezer Refrigerator','Storing all of your favorite fresh and frozen foods is easy with this cubic foot bottom-freezer refrigerator, featuring glass shelves that help contain leaks and spills for quick cleanup. You''ll be able to keep food at the right temperature thanks to the temperature management system and adaptive defrost, which sense when to activate the compressor and defrost cycle. Plus, to keep fruits and vegetables tasting great, the produce preserver helps keep produce fresh longer in your bottom-freezer refrigerator.','static/images/4.jpg', 1,1480.5,0,20),
('Bathroom Faucet','Cap your bathroom sink with the graceful look of this widespread bathroom faucet. Two handles make it easy to customize the water temperature and flow. The uni-tone design features polished chrome finishes for a stunning look. Washerless quarter-turn drip-free cartridges keep this faucet running smoothly without wasteful drips.','static/images/5.jpg', 2,90,8,15),
('Shower Faucet','Accentuate your bathroom''s classic styling with this gorgeous bath and shower trim set. Featuring Katalyst technology, which aereates your shower spray for more power with less water usage, this set''s perfect for the environmentally conscious, and the included tub spout and single-lever control continue the traditional, upscale styling for a beautiful bath area.','static/images/6.jpg', 2,120,3,15),
('Shower Head','Turn an ordinary shower into an extraordinarily refreshing spa like event with this head shower. It features adjustable spray patterns for custom performance. It also features 3-way diverter, 4''11-inch hose on handheld unit, chrome finish, rub-clean nozzles and more. This peice installs in minutes with no special tools required.','static/images/7.jpg', 2,150,3,14),
('Bath Lighting','Illuminate your bathroom in style with this three-light vanity fixture from Porch & Den. Featuring integrated dimmable LED bulbs and etched white glass shades, this vanity light is ideal for a wide variety of settings. This fixture is available in your choice of brushed nickel or polished chrome finish.','static/images/8.jpg', 2,300,2,13),
('Blinds & Shades','Manage incoming sunlight and add a natural element to your surroundings with this Privacy Greywash Cordless Lift Bamboo Roman Shade. Available in multiple widths to conform to a variety of window sizes, these light and airy shades add a subtle accent to your decor and provide just the right amount of shade on bright days. Install this shade over a kitchen window to soften the incoming breeze, or hang a pair in your bathroom to keep the sun out and create a Zen, spa-like atmosphere.','static/images/9.jpg', 3,60,12,15),
('Faux Wood Blinds','Dress your windows with these faux-wood blinds from Porch & Den. The embossed blinds are paired with PVC ends caps and a wand that allows for cordless operation. Choose from two wood-style finishes and a variety of sizes to fit your windows.','static/images/10.jpg', 3,75,1,11),
('Cellular Shades','Keep glare off your TV screen or monitor while maintaining a fashionable home with this cordless, light-filtering cellular shade. Featuring easy manual adjustment that can''t entangle pets or kids, this classic polyester shade is available in a variety of sizes to suit your needs.','static/images/11.jpg', 3,50,6,11),
('Window Film','With a stylish design inspired by peacock feathers, this premium privacy window film from Brewster creates a chic stained-glass effect. Enjoy naturally-refracted light through the beautiful blues, greens, and purples of this authentic-looking stained-glass cling.','static/images/12.jpg', 3,95,15,18),
('Wood Fencing','Fence in your yard and make your property look great with this timeless decorative panel. Also provides separation between your lot and your neighbors. Install with 4 x 4 x 6'' French gothic cedar posts. Automated assembly ensures consistency in manufacturing.','static/images/13.jpg', 4,10,8,10),
('Vinyl Fencing','Azembla''s Cape Cod gate is manufactured from the highest quality material and is virtually maintenance free, this gate will look new for years to come. Made with superior quality and designed for ease of assembly, this picket gate is the perfect complement to your fence project. This gate features everything needed to build one gate including a hardware kit.','static/images/14.jpg', 4,20,2,10),
('Fiberglass Insulation','Fiberglass insulation is the most cost effective way to increase thermal performance. 1.SAVE MONEY! Adding insulation/having the proper amount will reduce your heating and cooling monthly bills. 2. YEAR ROUND COMFORT! Insulation will keep your home warmer in the winter and cooler in the summer. 3. INCREASED HOME VALUE! A proper insulated and efficient home is worth more and is more attractive to a future buyer.','static/images/15.jpg', 5,25,3,10),
('Rigid Insulation','Owens Corning fanfold underlayment board adds insulating power, eliminates gaps to reduce air infiltration, and provides a smooth nailing surface for re-siding exterior walls. This board is perforated to allow excess moisture to escape.','static/images/16.jpg', 5,20,1,5),
('Patio Doors','There''s nothing like the classic look of a French door to make a patio complete. This model features a center-hinge design to give you the beautiful look of a double French door and the functionality of a single door. With an insulated core and insulated glass, this patio door is stress free all year round. This door has a right inswing, which means the knob is on the right side when you pull the door toward you.','static/images/17.jpg', 6,450,10,9),
('Screen Doors','Replace a broken screen door or upgrade from an older model with this standard swing screen door. This unit is designed to install easily and provides smooth swinging operation for opening and closing. With its T-bar frame, fresh air easily fills your home while the quality screen ensures that insects, pests, and debris stay out. This screen door is built to last and offers long lasting enjoyment for you and your family.','static/images/18.jpg', 6,500,6,10),
('Garage Doors','Traditional Steel Panel garage doors feature a design that works with every home without sacrificing style for strength, durability and comfort. Simply said our doors areWarmer, Quieter and Stronger. At the heart of our door is a continuous layer of polyurethane insulation sandwiched between two layers of steel. The three-layer construction provides strength, dent resistance, insulation and security, as well as quiet operation and a beautiful appearance inside and out. ','static/images/19.jpg', 7,350,13,10),
('Garage Doors Openers','We did not invent the garage door opener, we perfected it. Simple, reliable design combined with heavy-duty, high-quality components and easy installation are what make our garage door openers great. A garage door opener is something you depend on every day, and for this reason our garage door openers have been engineered to operate in all temperatures, from hot summers to extreme winter conditions. This opener is designed to handle most sectional garage doors up to 7-foot tall and 18-foot wide.','static/images/20.jpg', 7,100,2,10),
('TVs','The Nano Cell Display ensures a picture with better quality in an LED TV. Nano Accuracy keeps everything lifelike, and Nano Color delivers a spectrum of color. LG''s powerful processor enriches your content. Dimming control helps light levels. Dolby integrates picture and sound technologies. The world''s most intelligent TVs listen, think and answer to provide the ultimate in personalized entertainment and control over your smart home.','static/images/21.jpg', 8,1250,4,11),
('Home Audio','Turn your TV into a home theater experience with this Blu-ray player and speaker system. Featuring 3-D capabilities, this Blu-ray disc player works with a 3-D TV to replay favorite movies in full 3-D quality or with a standard TV for excellent 2-D reproduction. The two included TallBoy speakers surround you with sound for full immersion in your favorite tracks.','static/images/22.jpg', 8,750,6,12),
('LED Light Bulbs','Restore vibrant lighting with these replacement bulbs by Ecosmart. LED technology makes these bulbs energy efficient, boasting an output of 2600 lumens for soft or bright color temperatures. Compatibility with dimmers lets you tweak lighting levels to your liking, and the bulbs fit into ceiling fixtures and table lamps for convenient, all-purpose use.','static/images/23.jpg', 9,80,7,12),
('CFL Light Bulbs','This compact florescent light bulb (CFL) offers long life and energy efficient task lighting. Whether you want to create a comfortable, pleasant atmosphere in your kitchen or bath or bring the outdoors in with a bright white light, this Goodlite CFL can meet your needs. ','static/images/24.jpg', 9,85,5,12),
('Stainless Steel Sinks','KRAUS KHU100-32 Standart PRO 32-inch 16 Gauge Undermount Single Bowl Stainless Steel Kitchen Sink. Enjoy the advantage of high-end kitchen sinks with the best-selling Standart PRO Series. This KRAUS sink features a clean contemporary design and wear-resistant finish with a beautiful sheen that complements most kitchen appliances.','static/images/25.jpg', 10,125,0,13),
('Apron Front Sinks','Made in Italy, this farmhouse sink is constructed from solid, heavy duty fireclay and features a polished white finish. The apron fronts feature a decorative edge on either side. This classic style, long seen in country houses now is popular everywhere from the suburbs to urban kitchens thanks to ease-of-use and durability. Finished in a gleaming porcelain glaze, it will be the star of your kitchen!','static/images/26.jpg', 10,150,1,13),
('Cabinet Hardware','Take an easy approach to changing the look of your kitchen cabinets or drawers with this pack of 25 bar pulls by GlideRite. A brushed nickel finish gives these accessories a sleek appearance and melds with your existing appliances, and the stainless steel fabrication withstands the demands of daily use.','static/images/27.jpg', 11,150,9,14),
('Water Filters','The PUR Classic Faucet Filtration System provides healthy, clean, great-tasting water straight from your faucet. With 1-click installation and superior contaminant removal with our MAXION Filter Technology, there''s never been an easier or more reliable way to get healthy, clean, great-tasting water straight from your faucet.', 'static/images/28.jpg', 12, 90, 7, 14),
('Grass Seed','Sun & Shade Mix is Scotts most versatile mix, staying green even in extreme conditions of dense shade or blistering sun. It aggressively spreads to fill in bare spots, absorbs 2X more water than uncoated seed, and feeds to jumpstart growth and helps protect seedlings against disease. Grows quicker, thicker, greener grass guaranteed!','static/images/29.jpg', 13,100,16,20),
('Lawn Fertilizers','Vigoro Fertilizer is a quality granular fertilizer formulated for seeding or sodding to encourage strong root development and overall healthier grass. This product provides a balance of primary nutrients whenever seeding or sodding. The phosphorus and potash stimulate strong rapid root development creating early lateral shoot formation and dense even growth. Contains advanced polymer-coated Enhanced Efficiency Fertilizer technology that provides controlled-release nitrogen . ','static/images/30.jpg', 13,90,18,20),
('Pavers & Step Stones','These step stones are great for adding definition to a flower garden, keeping the lawn off of your walkway or driveway, and helping control water runoff. The edgers separate and protect mulch or rock from grass edges, keeping your yard neat and clean.','static/images/31.jpg', 14,95,3,20),
('Retaining Wall Blocks','The Crestone Beveled retaining wall blocks have a unique radial split designed for building strong, stable retaining walls. These retaining wall blocks are very functional, decorative and allow for easier installation. Besides retaining walls, Crestone Beveled blocks are perfect for fire pits, seating, raised flower beds, barbecues, bars and many other landscaping projects.','static/images/32.jpg', 14,45,4,20),
('Seating Sets','Invite the entire gang over for a backyard barbecue with this 8-piece entertainment seating set by Christopher Knight Home. Crafted with aluminum, metal, glass and wicker, the seating set is durable and water-resistant to stand up to inclement weather. The set includes all the cushions needed for comfortable and supportive seating.','static/images/33.jpg', 15,400,8,15),
('Chairs & Stools','Built with sturdy rubberwood and featuring a curved chair back, this stool is both durable and supportive. With a sleek cherry wood finish and a dark vinyl seat, this stool blends well with earth-tone color schemes and contrasts nicely with lighter colors. The 360-degree swivel feature on this stool allows swift and easy rotation when you dine or socialize with guests or family members, while the lower foot ring provides a convenient spot to rest your feet.','static/images/34.jpg', 15,200,1,4),
('Chaise Lounges','Stretch out in the sun in this five-position adjustable chaise lounge from International Caravan. Constructed from heavy-duty Acacia hardwood for sturdiness and durability, this all-weather outdoor chaise is protected with a water- and UV-resistant finish to stand up to harsh sunlight and extreme weather conditions.','static/images/35.jpg', 15,350,0,4),
('Sofas & Loveseats','Pay homage to elegance with this traditional loveseat sofa. Showcasing fabric upholstery and tufted details that lend it a classically elegant look, this loveseat sofa looks inviting. Removable cushion covers make it easy to refresh your loveseat with a plump new insert, and the foam-filled padding offers springy, inviting comfort. Featuring metal legs and a sturdy, wood frame, this durable sofa gives your living room lasting charm.','static/images/36.jpg', 15,200,5,5),
('Garment Racks','Inspired by racks used by couturiers at annual runway shows, the Betsy Adjustable Garment Rack is a space-saving storage solution for any fashion-lover. Finished in an industrial chic metallic finish, this portable wardrobe is an entire extra closet. Perfect for organizing your garage, workshop, kitchen, pantry, closet, or utility room, these multiuse pieces can easily be customized for any desired storage need, proving to be a timeless investment.','static/images/37.jpg', 16,250,2,8),
('Shoe Storage','Pull a pair of footwear from this multi-compartment shoe storage bench. Twenty four open cubbies hold your sneakers, sandals, and boots and keep them easily accessible, while the wide, rectangular top offers a sturdy spot to put on and remove your shoes. Finished in laminate in your choice of color, this storage bench makes for a robust complement to your entryway decor.','static/images/38.jpg', 16,225,5 ,8),
('Wood Closet Organizers','Bring order to your wardrobe with this Woodcrest closet organizer from John Louis Home. Built with open shelves and three garment bars, this unit offers space for hanging clothes, folded items, and storage bins. With its simple white finish, this organizer brightens the interior of your closet.','static/images/39.jpg', 16,100,6,9),
('Decorative Shelving','Wooden shelves with it''s modern and attractive look will give every room its perfect finishing touch. Add it to your room you will see the difference it makes to your room with its elegant look. It suits almost every decor and is great for your kitchen, dining room, living room, bedroom or office. It''s easy to mount and comes with all necessary mounting hardware. Shelf measurements in inches; 22.75" Long x 4.75 High x 4" Deep. ','static/images/40.jpg', 17,600,9,9)

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
(1,1,1,'2020-05-20'),
(2,1,1,'2020-05-20'),
(3,11,5,'2020-05-20'),
(4,9,2,'2020-05-20'),
(5,36,1,'2020-05-20'),
(6,25,1,'2020-05-20');

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

SELECT * FROM Customer


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
*/id = object_id('Customer'))
	drop table Customer
GO

if exists (select * from sysobjects where id = object_id('Product'))
	drop table Product
GO

if exists (select * from sysobjects where id = object_id('Category'))
	drop table Category
GO

if exists (select * from sysobjects where id = object_id('OrderTable'))
	drop table OrderTable
GO

if exists (select * from sysobjects where id = object_id('OrderItem'))
	drop table OrderItem
GO

if exists (select * from sysobjects where id = object_id('Review'))
	drop table Review
GO

if exists (select * from sysobjects where id = object_id('ShipAddress'))
	drop table ShipAddress

if exists (select * from sysobjects where id = object_id('ShoppingCart'))
	drop table ShoppingCart
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
    is_complete VARCHAR(1) DEFAULT NULL,
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
    is_default VARCHAR(1) DEFAULT 0,
) ;

CREATE TABLE Category(
    categoryID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    productCategory NVARCHAR(128) NOT NULL ,
) ;


CREATE TABLE Review(
    reviewID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    reviewerID INT  NOT NULL,
    productID INT  NOT NULL,
    grade INT  NOT NULL,
    comment NVARCHAR(512) ,
    reviewTime DATE  NOT NULL,
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
/*
('Alice', 'Alice9895'),
('Bob', 'lalala123456'),
('Carol', 'reallyStrongPwd666'),
('Dave', 'Yiheyuan5'),
('Eve', 'UnknownLake520'),
('Francis', '0.0and0.0'),
('Grace', 'Helloworld!'),
('Hans', 'loveyou3000'),
('Isabella', 'bella0504'),
('Jones', 'Physics');
*/

INSERT INTO Product
VALUES
('French Door Refrigerator','Get the storage you need in this refrigerator with water dispenser. An exterior refrigerated drawer keeps frequently used items within easy reach. This refrigerator with refrigerated drawers also gives you access to filtered ice and water without ever opening the door. Plus, the tap touch controls are as easy to clean as they are to use.','static/images/1.jpg', 1,1978.2,20,20),
('Side By Side Refrigerator','Fit and find it all with purposefully designed storage spaces in this certified refrigerator from Whirlpool. Get increased loading flexibility with adjustable gallon door bins. The exterior ice and water dispenser lets you access cool refreshments without opening the door while LED lights keep food looking as good as it tastes.','static/images/2.jpg', 1,1979,5,15),
('Top Freezer Refrigerator','Keep food fresh with Criterion top mount refrigerator. The convenient electronic temperature control allows you to keep food at the perfect temperature and E-Star qualified helps you save money on energy costs. Two adjustable full width spill-proof glass shelves and two crispers perfectly meet your storage needs, also a variety of door racks provide extra space and a half width dairy box is at your disposal.','static/images/3.jpg', 1,1245.5,13,20),
('Bottom Freezer Refrigerator','Storing all of your favorite fresh and frozen foods is easy with this cubic foot bottom-freezer refrigerator, featuring glass shelves that help contain leaks and spills for quick cleanup. You''ll be able to keep food at the right temperature thanks to the temperature management system and adaptive defrost, which sense when to activate the compressor and defrost cycle. Plus, to keep fruits and vegetables tasting great, the produce preserver helps keep produce fresh longer in your bottom-freezer refrigerator.','static/images/4.jpg', 1,1480.5,0,20),
('Bathroom Faucet','Cap your bathroom sink with the graceful look of this widespread bathroom faucet. Two handles make it easy to customize the water temperature and flow. The uni-tone design features polished chrome finishes for a stunning look. Washerless quarter-turn drip-free cartridges keep this faucet running smoothly without wasteful drips.','static/images/5.jpg', 2,90,8,15),
('Shower Faucet','Accentuate your bathroom''s classic styling with this gorgeous bath and shower trim set. Featuring Katalyst technology, which aereates your shower spray for more power with less water usage, this set''s perfect for the environmentally conscious, and the included tub spout and single-lever control continue the traditional, upscale styling for a beautiful bath area.','static/images/6.jpg', 2,120,3,15),
('Shower Head','Turn an ordinary shower into an extraordinarily refreshing spa like event with this head shower. It features adjustable spray patterns for custom performance. It also features 3-way diverter, 4''11-inch hose on handheld unit, chrome finish, rub-clean nozzles and more. This peice installs in minutes with no special tools required.','static/images/7.jpg', 2,150,3,14),
('Bath Lighting','Illuminate your bathroom in style with this three-light vanity fixture from Porch & Den. Featuring integrated dimmable LED bulbs and etched white glass shades, this vanity light is ideal for a wide variety of settings. This fixture is available in your choice of brushed nickel or polished chrome finish.','static/images/8.jpg', 2,300,2,13),
('Blinds & Shades','Manage incoming sunlight and add a natural element to your surroundings with this Privacy Greywash Cordless Lift Bamboo Roman Shade. Available in multiple widths to conform to a variety of window sizes, these light and airy shades add a subtle accent to your decor and provide just the right amount of shade on bright days. Install this shade over a kitchen window to soften the incoming breeze, or hang a pair in your bathroom to keep the sun out and create a Zen, spa-like atmosphere.','static/images/9.jpg', 3,60,12,15),
('Faux Wood Blinds','Dress your windows with these faux-wood blinds from Porch & Den. The embossed blinds are paired with PVC ends caps and a wand that allows for cordless operation. Choose from two wood-style finishes and a variety of sizes to fit your windows.','static/images/10.jpg', 3,75,1,11),
('Cellular Shades','Keep glare off your TV screen or monitor while maintaining a fashionable home with this cordless, light-filtering cellular shade. Featuring easy manual adjustment that can''t entangle pets or kids, this classic polyester shade is available in a variety of sizes to suit your needs.','static/images/11.jpg', 3,50,6,11),
('Window Film','With a stylish design inspired by peacock feathers, this premium privacy window film from Brewster creates a chic stained-glass effect. Enjoy naturally-refracted light through the beautiful blues, greens, and purples of this authentic-looking stained-glass cling.','static/images/12.jpg', 3,95,15,18),
('Wood Fencing','Fence in your yard and make your property look great with this timeless decorative panel. Also provides separation between your lot and your neighbors. Install with 4 x 4 x 6'' French gothic cedar posts. Automated assembly ensures consistency in manufacturing.','static/images/13.jpg', 4,10,8,10),
('Vinyl Fencing','Azembla''s Cape Cod gate is manufactured from the highest quality material and is virtually maintenance free, this gate will look new for years to come. Made with superior quality and designed for ease of assembly, this picket gate is the perfect complement to your fence project. This gate features everything needed to build one gate including a hardware kit.','static/images/14.jpg', 4,20,2,10),
('Fiberglass Insulation','Fiberglass insulation is the most cost effective way to increase thermal performance. 1.SAVE MONEY! Adding insulation/having the proper amount will reduce your heating and cooling monthly bills. 2. YEAR ROUND COMFORT! Insulation will keep your home warmer in the winter and cooler in the summer. 3. INCREASED HOME VALUE! A proper insulated and efficient home is worth more and is more attractive to a future buyer.','static/images/15.jpg', 5,25,3,10),
('Rigid Insulation','Owens Corning fanfold underlayment board adds insulating power, eliminates gaps to reduce air infiltration, and provides a smooth nailing surface for re-siding exterior walls. This board is perforated to allow excess moisture to escape.','static/images/16.jpg', 5,20,1,5),
('Patio Doors','There''s nothing like the classic look of a French door to make a patio complete. This model features a center-hinge design to give you the beautiful look of a double French door and the functionality of a single door. With an insulated core and insulated glass, this patio door is stress free all year round. This door has a right inswing, which means the knob is on the right side when you pull the door toward you.','static/images/17.jpg', 6,450,10,9),
('Screen Doors','Replace a broken screen door or upgrade from an older model with this standard swing screen door. This unit is designed to install easily and provides smooth swinging operation for opening and closing. With its T-bar frame, fresh air easily fills your home while the quality screen ensures that insects, pests, and debris stay out. This screen door is built to last and offers long lasting enjoyment for you and your family.','static/images/18.jpg', 6,500,6,10),
('Garage Doors','Traditional Steel Panel garage doors feature a design that works with every home without sacrificing style for strength, durability and comfort. Simply said our doors areWarmer, Quieter and Stronger. At the heart of our door is a continuous layer of polyurethane insulation sandwiched between two layers of steel. The three-layer construction provides strength, dent resistance, insulation and security, as well as quiet operation and a beautiful appearance inside and out. ','static/images/19.jpg', 7,350,13,10),
('Garage Doors Openers','We did not invent the garage door opener, we perfected it. Simple, reliable design combined with heavy-duty, high-quality components and easy installation are what make our garage door openers great. A garage door opener is something you depend on every day, and for this reason our garage door openers have been engineered to operate in all temperatures, from hot summers to extreme winter conditions. This opener is designed to handle most sectional garage doors up to 7-foot tall and 18-foot wide.','static/images/20.jpg', 7,100,2,10),
('TVs','The Nano Cell Display ensures a picture with better quality in an LED TV. Nano Accuracy keeps everything lifelike, and Nano Color delivers a spectrum of color. LG''s powerful processor enriches your content. Dimming control helps light levels. Dolby integrates picture and sound technologies. The world''s most intelligent TVs listen, think and answer to provide the ultimate in personalized entertainment and control over your smart home.','static/images/21.jpg', 8,1250,4,11),
('Home Audio','Turn your TV into a home theater experience with this Blu-ray player and speaker system. Featuring 3-D capabilities, this Blu-ray disc player works with a 3-D TV to replay favorite movies in full 3-D quality or with a standard TV for excellent 2-D reproduction. The two included TallBoy speakers surround you with sound for full immersion in your favorite tracks.','static/images/22.jpg', 8,750,6,12),
('LED Light Bulbs','Restore vibrant lighting with these replacement bulbs by Ecosmart. LED technology makes these bulbs energy efficient, boasting an output of 2600 lumens for soft or bright color temperatures. Compatibility with dimmers lets you tweak lighting levels to your liking, and the bulbs fit into ceiling fixtures and table lamps for convenient, all-purpose use.','static/images/23.jpg', 9,80,7,12),
('CFL Light Bulbs','This compact florescent light bulb (CFL) offers long life and energy efficient task lighting. Whether you want to create a comfortable, pleasant atmosphere in your kitchen or bath or bring the outdoors in with a bright white light, this Goodlite CFL can meet your needs. ','static/images/24.jpg', 9,85,5,12),
('Stainless Steel Sinks','KRAUS KHU100-32 Standart PRO 32-inch 16 Gauge Undermount Single Bowl Stainless Steel Kitchen Sink. Enjoy the advantage of high-end kitchen sinks with the best-selling Standart PRO Series. This KRAUS sink features a clean contemporary design and wear-resistant finish with a beautiful sheen that complements most kitchen appliances.','static/images/25.jpg', 10,125,0,13),
('Apron Front Sinks','Made in Italy, this farmhouse sink is constructed from solid, heavy duty fireclay and features a polished white finish. The apron fronts feature a decorative edge on either side. This classic style, long seen in country houses now is popular everywhere from the suburbs to urban kitchens thanks to ease-of-use and durability. Finished in a gleaming porcelain glaze, it will be the star of your kitchen!','static/images/26.jpg', 10,150,1,13),
('Cabinet Hardware','Take an easy approach to changing the look of your kitchen cabinets or drawers with this pack of 25 bar pulls by GlideRite. A brushed nickel finish gives these accessories a sleek appearance and melds with your existing appliances, and the stainless steel fabrication withstands the demands of daily use.','static/images/27.jpg', 11,150,9,14),
('Water Filters','The PUR Classic Faucet Filtration System provides healthy, clean, great-tasting water straight from your faucet. With 1-click installation and superior contaminant removal with our MAXION Filter Technology, there''s never been an easier or more reliable way to get healthy, clean, great-tasting water straight from your faucet.', 'static/images/28.jpg', 12, 90, 7, 14),
('Grass Seed','Sun & Shade Mix is Scotts most versatile mix, staying green even in extreme conditions of dense shade or blistering sun. It aggressively spreads to fill in bare spots, absorbs 2X more water than uncoated seed, and feeds to jumpstart growth and helps protect seedlings against disease. Grows quicker, thicker, greener grass guaranteed!','static/images/29.jpg', 13,100,16,20),
('Lawn Fertilizers','Vigoro Fertilizer is a quality granular fertilizer formulated for seeding or sodding to encourage strong root development and overall healthier grass. This product provides a balance of primary nutrients whenever seeding or sodding. The phosphorus and potash stimulate strong rapid root development creating early lateral shoot formation and dense even growth. Contains advanced polymer-coated Enhanced Efficiency Fertilizer technology that provides controlled-release nitrogen . ','static/images/30.jpg', 13,90,18,20),
('Pavers & Step Stones','These step stones are great for adding definition to a flower garden, keeping the lawn off of your walkway or driveway, and helping control water runoff. The edgers separate and protect mulch or rock from grass edges, keeping your yard neat and clean.','static/images/31.jpg', 14,95,3,20),
('Retaining Wall Blocks','The Crestone Beveled retaining wall blocks have a unique radial split designed for building strong, stable retaining walls. These retaining wall blocks are very functional, decorative and allow for easier installation. Besides retaining walls, Crestone Beveled blocks are perfect for fire pits, seating, raised flower beds, barbecues, bars and many other landscaping projects.','static/images/32.jpg', 14,45,4,20),
('Seating Sets','Invite the entire gang over for a backyard barbecue with this 8-piece entertainment seating set by Christopher Knight Home. Crafted with aluminum, metal, glass and wicker, the seating set is durable and water-resistant to stand up to inclement weather. The set includes all the cushions needed for comfortable and supportive seating.','static/images/33.jpg', 15,400,8,15),
('Chairs & Stools','Built with sturdy rubberwood and featuring a curved chair back, this stool is both durable and supportive. With a sleek cherry wood finish and a dark vinyl seat, this stool blends well with earth-tone color schemes and contrasts nicely with lighter colors. The 360-degree swivel feature on this stool allows swift and easy rotation when you dine or socialize with guests or family members, while the lower foot ring provides a convenient spot to rest your feet.','static/images/34.jpg', 15,200,1,4),
('Chaise Lounges','Stretch out in the sun in this five-position adjustable chaise lounge from International Caravan. Constructed from heavy-duty Acacia hardwood for sturdiness and durability, this all-weather outdoor chaise is protected with a water- and UV-resistant finish to stand up to harsh sunlight and extreme weather conditions.','static/images/35.jpg', 15,350,0,4),
('Sofas & Loveseats','Pay homage to elegance with this traditional loveseat sofa. Showcasing fabric upholstery and tufted details that lend it a classically elegant look, this loveseat sofa looks inviting. Removable cushion covers make it easy to refresh your loveseat with a plump new insert, and the foam-filled padding offers springy, inviting comfort. Featuring metal legs and a sturdy, wood frame, this durable sofa gives your living room lasting charm.','static/images/36.jpg', 15,200,5,5),
('Garment Racks','Inspired by racks used by couturiers at annual runway shows, the Betsy Adjustable Garment Rack is a space-saving storage solution for any fashion-lover. Finished in an industrial chic metallic finish, this portable wardrobe is an entire extra closet. Perfect for organizing your garage, workshop, kitchen, pantry, closet, or utility room, these multiuse pieces can easily be customized for any desired storage need, proving to be a timeless investment.','static/images/37.jpg', 16,250,2,8),
('Shoe Storage','Pull a pair of footwear from this multi-compartment shoe storage bench. Twenty four open cubbies hold your sneakers, sandals, and boots and keep them easily accessible, while the wide, rectangular top offers a sturdy spot to put on and remove your shoes. Finished in laminate in your choice of color, this storage bench makes for a robust complement to your entryway decor.','static/images/38.jpg', 16,225,5 ,8),
('Wood Closet Organizers','Bring order to your wardrobe with this Woodcrest closet organizer from John Louis Home. Built with open shelves and three garment bars, this unit offers space for hanging clothes, folded items, and storage bins. With its simple white finish, this organizer brightens the interior of your closet.','static/images/39.jpg', 16,100,6,9),
('Decorative Shelving','Wooden shelves with it''s modern and attractive look will give every room its perfect finishing touch. Add it to your room you will see the difference it makes to your room with its elegant look. It suits almost every decor and is great for your kitchen, dining room, living room, bedroom or office. It''s easy to mount and comes with all necessary mounting hardware. Shelf measurements in inches; 22.75" Long x 4.75 High x 4" Deep. ','static/images/40.jpg', 17,600,9,9)

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
(1,1,1,'2020-05-20'),
(2,1,1,'2020-05-20'),
(3,11,5,'2020-05-20'),
(4,9,2,'2020-05-20'),
(5,36,1,'2020-05-20'),
(6,25,1,'2020-05-20');

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

SELECT * FROM Customer


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