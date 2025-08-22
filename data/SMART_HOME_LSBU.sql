-- Table: Client
CREATE TABLE Client (
    ClientID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    PhoneNumber NVARCHAR(20),
    Email NVARCHAR(255),
    CompanyName NVARCHAR(255),
    BillingAddress NVARCHAR(255),
    ZipCode NVARCHAR(10),
    City NVARCHAR(100),
    Country NVARCHAR(100),
    RegistrationDate DATE NOT NULL DEFAULT GETDATE()
);

SELECT * FROM Client;

-- Table: Building
CREATE TABLE Building (
    BuildingID INT PRIMARY KEY IDENTITY(1,1),
    Address NVARCHAR(255) NOT NULL,
    Postcode NVARCHAR(20),
    BuildingType NVARCHAR(100)
);

SELECT * FROM Building;

-- Table: ClientBuilding
CREATE TABLE ClientBuilding (
    ClientID INT NOT NULL,
    BuildingID INT NOT NULL,
    OwnershipType NVARCHAR(50),
    AccessLevel NVARCHAR(50),
    ContractStartDate DATE,
    ContractEndDate DATE,
    Notes NVARCHAR(255),
    PRIMARY KEY (ClientID, BuildingID),
    FOREIGN KEY (ClientID) REFERENCES Client(ClientID),
    FOREIGN KEY (BuildingID) REFERENCES Building(BuildingID)
);

SELECT * FROM ClientBuilding;

-- Table: Sensor
CREATE TABLE Sensor (
    SensorID INT PRIMARY KEY IDENTITY(1,1),
    SensorType NVARCHAR(100) NOT NULL,
    Manufacturer NVARCHAR(100),
    Model NVARCHAR(100),
    Description NVARCHAR(255)
);

SELECT * FROM Sensor;

-- Table: Controller
CREATE TABLE Controller (
    ControllerID INT PRIMARY KEY IDENTITY(1,1),
    ControllerType NVARCHAR(100) NOT NULL,
    Protocol NVARCHAR(50),
    Manufacturer NVARCHAR(100),
    Model NVARCHAR(100)
);

SELECT * FROM Controller;

-- Table: SpecialDevice
CREATE TABLE SpecialDevice (
    SpecialDeviceID INT PRIMARY KEY IDENTITY(1,1),
    DeviceType NVARCHAR(100) NOT NULL,
    Manufacturer NVARCHAR(100),
    Model NVARCHAR(100),
    Description NVARCHAR(255)
);

SELECT * FROM SpecialDevice;

-- Table: Design
CREATE TABLE Design (
    DesignID INT PRIMARY KEY IDENTITY(1,1),
    BuildingID INT NOT NULL,
    DateCreated DATE NOT NULL DEFAULT GETDATE(),
    ImplementedByLSBU BIT NOT NULL,
    FOREIGN KEY (BuildingID) REFERENCES Building(BuildingID)
);

SELECT * FROM Design;

-- Table: DesignComponent
CREATE TABLE DesignComponent (
    ComponentID INT PRIMARY KEY IDENTITY(1,1),
    DesignID INT NOT NULL,
    SensorID INT,
    ControllerID INT,
    SpecialDeviceID INT,
    LocationInBuilding NVARCHAR(255),
    FOREIGN KEY (DesignID) REFERENCES Design(DesignID),
    FOREIGN KEY (SensorID) REFERENCES Sensor(SensorID),
    FOREIGN KEY (ControllerID) REFERENCES Controller(ControllerID),
    FOREIGN KEY (SpecialDeviceID) REFERENCES SpecialDevice(SpecialDeviceID)
);

SELECT * FROM DesignComponent;

-- Table: SensorControllerCompatibility
CREATE TABLE SensorControllerCompatibility (
    SensorID INT NOT NULL,
    ControllerID INT NOT NULL,
    PRIMARY KEY (SensorID, ControllerID),
    FOREIGN KEY (SensorID) REFERENCES Sensor(SensorID),
    FOREIGN KEY (ControllerID) REFERENCES Controller(ControllerID)
);

SELECT * FROM SensorControllerCompatibility;

-- Table: Supplier
CREATE TABLE Supplier (
    SupplierID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Website NVARCHAR(255),
    ContactEmail NVARCHAR(255)
);

SELECT * FROM Supplier;

-- Table: StockItem
CREATE TABLE StockItem (
    StockItemID INT PRIMARY KEY IDENTITY(1,1),
    SupplierID INT NOT NULL,
    ItemType NVARCHAR(50),
    QuantityAvailable INT NOT NULL,
    LastCheckedDate DATE,
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
);

SELECT * FROM StockItem;

-- Table: StockDevice
CREATE TABLE StockDevice (
    StockDeviceID INT PRIMARY KEY IDENTITY(1,1),
    StockItemID INT NOT NULL,
    SensorID INT,
    ControllerID INT,
    SpecialDeviceID INT,
    FOREIGN KEY (StockItemID) REFERENCES StockItem(StockItemID),
    FOREIGN KEY (SensorID) REFERENCES Sensor(SensorID),
    FOREIGN KEY (ControllerID) REFERENCES Controller(ControllerID),
    FOREIGN KEY (SpecialDeviceID) REFERENCES SpecialDevice(SpecialDeviceID)
);

SELECT * FROM StockDevice;

-- Table: StockCheckLog
CREATE TABLE StockCheckLog (
    CheckID INT PRIMARY KEY IDENTITY(1,1),
    StockItemID INT NOT NULL,
    CheckedDate DATE NOT NULL DEFAULT GETDATE(),
    QuantityAvailable INT,
    FOREIGN KEY (StockItemID) REFERENCES StockItem(StockItemID)
);

SELECT * FROM StockCheckLog;

-- Table: Staff
CREATE TABLE Staff (
    StaffID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    PhoneNumber NVARCHAR(20),
    Email NVARCHAR(255),
    AvailabilityStatus NVARCHAR(50),
    AreaOfExpertise NVARCHAR(100)
);

SELECT * FROM Staff;

-- Table: InstallationTeam
CREATE TABLE InstallationTeam (
    TeamID INT PRIMARY KEY IDENTITY(1,1),
    TeamName NVARCHAR(100)
);

SELECT * FROM InstallationTeam;

-- Table: TeamMember
CREATE TABLE TeamMember (
    TeamID INT NOT NULL,
    StaffID INT NOT NULL,
    PRIMARY KEY (TeamID, StaffID),
    FOREIGN KEY (TeamID) REFERENCES InstallationTeam(TeamID),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);

SELECT * FROM TeamMember;

-- Table: ComponentInstallationLog
CREATE TABLE ComponentInstallationLog (
    ComponentID INT NOT NULL,
    StaffID INT NOT NULL,
    InstallDate DATE NOT NULL DEFAULT GETDATE(),
    Notes NVARCHAR(255),
    PRIMARY KEY (ComponentID, StaffID),
    FOREIGN KEY (ComponentID) REFERENCES DesignComponent(ComponentID),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);

SELECT * FROM ComponentInstallationLog;

-- Table: Invoice
CREATE TABLE Invoice (
    InvoiceID INT PRIMARY KEY IDENTITY(1,1),
    ClientID INT NOT NULL,
    IssueDate DATE NOT NULL DEFAULT GETDATE(),
    DueDate DATE,
    Amount DECIMAL(10,2) NOT NULL,
    InvoiceType NVARCHAR(50),
    FOREIGN KEY (ClientID) REFERENCES Client(ClientID)
);

SELECT * FROM Invoice;

-- Table: PaymentMethod
CREATE TABLE PaymentMethod (
    PaymentMethodID INT PRIMARY KEY IDENTITY(1,1),
    MethodName NVARCHAR(100) NOT NULL
);

SELECT * FROM PaymentMethod;

-- Table: Payment
CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    InvoiceID INT NOT NULL,
    PaymentMethodID INT NOT NULL,
    PaymentDate DATE NOT NULL,
    FOREIGN KEY (InvoiceID) REFERENCES Invoice(InvoiceID),
    FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethod(PaymentMethodID)
);

SELECT * FROM Payment;




SELECT name AS TableName
FROM sys.tables
ORDER BY name;


SELECT 
    fk.name AS ForeignKeyName,
    tp.name AS ParentTable,
    cp.name AS ParentColumn,
    tr.name AS ReferencedTable,
    cr.name AS ReferencedColumn
FROM 
    sys.foreign_keys fk
JOIN 
    sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
JOIN 
    sys.tables tp ON fkc.parent_object_id = tp.object_id
JOIN 
    sys.columns cp ON fkc.parent_object_id = cp.object_id AND fkc.parent_column_id = cp.column_id
JOIN 
    sys.tables tr ON fkc.referenced_object_id = tr.object_id
JOIN 
    sys.columns cr ON fkc.referenced_object_id = cr.object_id AND fkc.referenced_column_id = cr.column_id
ORDER BY 
    fk.name;



SELECT 
    t.name AS TableName,
    c.name AS PrimaryKeyColumn
FROM 
    sys.indexes i
JOIN 
    sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
JOIN 
    sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
JOIN 
    sys.tables t ON i.object_id = t.object_id
WHERE 
    i.is_primary_key = 1
ORDER BY 
    t.name;





	-------------------------------------------- Values Insertion---------------------------------


	INSERT INTO Client (FirstName, LastName, PhoneNumber, Email, CompanyName, BillingAddress, ZipCode, City, Country, RegistrationDate)
VALUES
('John', 'Smith', '07400111222', 'john.smith@smithsol.co.uk', 'Smith Solutions', '221B Baker Street', 'NW1 6XE', 'London', 'UK', '2023-01-15'),
('Emily', 'Watson', '07500987654', 'emily.watson@watsonltd.uk', 'Watson Technologies', '14 Liverpool Street', 'EC2M 7PP', 'London', 'UK', '2023-02-10'),
('Raj', 'Patel', '07399443567', 'raj.patel@greenhome.co.uk', 'GreenHome Systems', '45 Victoria Road', 'W3 6BL', 'London', 'UK', '2022-11-20'),
('Aisha', 'Hassan', '07789992233', 'aisha.hassan@smartbuild.uk', 'SmartBuild Ltd', '3A Stratford Avenue', 'E15 4QS', 'London', 'UK', '2023-03-05'),
('Oliver', 'Brown', '07512345678', 'oliver.brown@brownenergy.co.uk', 'Brown Energy', '101 Camden High Street', 'NW1 7JN', 'London', 'UK', '2022-12-01'),
('Sophie', 'Turner', '07450987612', 'sophie.turner@techspace.uk', 'TechSpace Ltd', '7A Oxford Street', 'W1D 2LT', 'London', 'UK', '2023-01-25'),
('Mohammed', 'Ali', '07780123456', 'mohammed.ali@futureconnect.uk', 'Future Connect', '20 Clapham Road', 'SW9 0JG', 'London', 'UK', '2023-03-12'),
('Isabella', 'King', '07344321234', 'isabella.king@buildsmart.uk', 'BuildSmart Plc', '88 Kensington Road', 'W8 5NX', 'London', 'UK', '2023-01-18'),
('Thomas', 'Green', '07566778899', 'thomas.green@greenit.uk', 'GreenIT Solutions', '12 Shoreditch High St', 'E1 6PG', 'London', 'UK', '2022-10-30'),
('Charlotte', 'Wood', '07400099887', 'charlotte.wood@homeiq.co.uk', 'HomeIQ Ltd', '55 Brixton Hill', 'SW2 1HT', 'London', 'UK', '2023-02-14'),
('Jake', 'Reed', '07455678900', 'jake.reed@reedtech.co.uk', 'ReedTech Ltd', '100 Whitechapel Road', 'E1 1JG', 'London', 'UK', '2023-01-08'),
('Lily', 'Bennett', '07300223344', 'lily.bennett@smartzone.uk', 'SmartZone Services', '62 Notting Hill Gate', 'W11 3HT', 'London', 'UK', '2023-03-03'),
('Mason', 'Wright', '07577889922', 'mason.wright@urbanwave.co.uk', 'UrbanWave Ltd', '77 Tottenham Court Road', 'W1T 4TJ', 'London', 'UK', '2022-09-18'),
('Grace', 'Morgan', '07334556677', 'grace.morgan@connectedhomes.uk', 'Connected Homes Ltd', '4 Hackney Road', 'E2 7NX', 'London', 'UK', '2023-03-10'),
('Leo', 'Anderson', '07490011223', 'leo.anderson@techhaven.co.uk', 'TechHaven', '5 Croydon High Street', 'CR0 1QQ', 'London', 'UK', '2023-02-01'),
('Chloe', 'Robinson', '07770998811', 'chloe.robinson@solarity.uk', 'Solarity Energy', '39 King’s Cross Road', 'WC1X 9LP', 'London', 'UK', '2023-03-09'),
('Noah', 'Scott', '07511223344', 'noah.scott@innovateliving.co.uk', 'Innovate Living', '15 Bermondsey Street', 'SE1 2BT', 'London', 'UK', '2022-11-25'),
('Ella', 'Hughes', '07393456789', 'ella.hughes@londoniot.uk', 'London IoT', '33 Peckham Rye', 'SE15 4JR', 'London', 'UK', '2023-01-30'),
('Oscar', 'Hall', '07600012345', 'oscar.hall@energyloop.co.uk', 'EnergyLoop Ltd', '21 Westbourne Grove', 'W2 4UA', 'London', 'UK', '2023-02-20'),
('Freya', 'Davies', '07403334455', 'freya.davies@nextgenhome.co.uk', 'NextGen Home Ltd', '6 Elephant Road', 'SE17 1LB', 'London', 'UK', '2023-03-06');
SELECT * FROM Client


INSERT INTO Building (Address, Postcode, BuildingType)
VALUES
('221B Baker Street', 'NW1 6XE', 'Townhouse'),
('14 Liverpool Street', 'EC2M 7PP', 'Office Block'),
('45 Victoria Road', 'W3 6BL', 'Detached House'),
('3A Stratford Avenue', 'E15 4QS', 'Semi-Detached House'),
('101 Camden High Street', 'NW1 7JN', 'Retail and Apartment'),
('7A Oxford Street', 'W1D 2LT', 'Retail Unit'),
('20 Clapham Road', 'SW9 0JG', 'Terraced House'),
('88 Kensington Road', 'W8 5NX', 'Luxury Apartment'),
('12 Shoreditch High Street', 'E1 6PG', 'Loft Conversion'),
('55 Brixton Hill', 'SW2 1HT', 'Apartment Block'),
('100 Whitechapel Road', 'E1 1JG', 'Flat'),
('62 Notting Hill Gate', 'W11 3HT', 'Terraced House'),
('77 Tottenham Court Road', 'W1T 4TJ', 'Office Floor'),
('4 Hackney Road', 'E2 7NX', 'Studio Flat'),
('5 Croydon High Street', 'CR0 1QQ', 'Commercial Unit'),
('39 King’s Cross Road', 'WC1X 9LP', 'Shared Housing'),
('15 Bermondsey Street', 'SE1 2BT', 'New Build Apartment'),
('33 Peckham Rye', 'SE15 4JR', 'Maisonette'),
('21 Westbourne Grove', 'W2 4UA', 'Converted Townhouse'),
('6 Elephant Road', 'SE17 1LB', 'Council Flat');
SELECT * FROM Building



INSERT INTO ClientBuilding (ClientID, BuildingID, OwnershipType, AccessLevel, ContractStartDate, ContractEndDate, Notes)
VALUES
(1, 1, 'Owner', 'Full', '2023-01-16', NULL, 'Primary residence'),
(1, 2, 'Tenant', 'Read-Only', '2023-03-01', '2024-03-01', 'Temporary access for testing'),
(2, 3, 'Owner', 'Full', '2023-02-11', NULL, 'Full office access'),
(3, 4, 'Owner', 'Full', '2022-12-01', NULL, ''),
(3, 5, 'Owner', 'Full', '2022-12-15', NULL, ''),
(4, 6, 'Tenant', 'Read-Only', '2023-03-05', '2024-03-05', ''),
(5, 7, 'Owner', 'Full', '2023-01-01', NULL, 'Main office'),
(6, 8, 'Owner', 'Full', '2023-02-01', NULL, 'Private residence'),
(7, 9, 'Owner', 'Full', '2023-03-13', NULL, ''),
(8, 10, 'Tenant', 'Limited', '2023-01-19', '2024-01-19', ''),
(9, 11, 'Owner', 'Full', '2022-10-30', NULL, ''),
(10, 12, 'Owner', 'Full', '2023-02-15', NULL, ''),
(11, 13, 'Owner', 'Full', '2023-01-08', NULL, ''),
(11, 14, 'Tenant', 'Read-Only', '2023-03-01', '2023-09-01', 'Shared test site'),
(12, 15, 'Owner', 'Full', '2023-03-04', NULL, ''),
(13, 16, 'Tenant', 'Read-Only', '2022-09-19', '2023-09-19', ''),
(14, 17, 'Owner', 'Full', '2023-03-11', NULL, 'Smart project site'),
(15, 18, 'Owner', 'Full', '2023-02-01', NULL, ''),
(16, 19, 'Owner', 'Full', '2023-03-10', NULL, ''),
(17, 20, 'Tenant', 'Limited', '2022-11-26', '2023-11-26', 'Trial project');

SELECT * FROM ClientBuilding;


INSERT INTO Sensor (SensorType, Manufacturer, Model, Description)
VALUES
('Temperature', 'Honeywell', 'THX9421R', 'High-precision indoor temperature sensor'),
('Humidity', 'Bosch', 'BME280', 'Compact humidity and pressure sensor'),
('Smoke Detector', 'Nest', 'Protect-2ndGen', 'Smart smoke and CO detector with alerts'),
('Motion', 'Philips Hue', 'MotionSensorV2', 'Indoor motion sensor with light level detection'),
('Door/Window Contact', 'Aqara', 'MCCGQ11LM', 'Magnetic contact sensor for doors/windows'),
('Leak Detection', 'Fibaro', 'FGFS-101', 'Water leak sensor for under sinks and appliances'),
('Air Quality', 'Netatmo', 'HealthyHomeCoach', 'Monitors CO₂, humidity, noise and temperature'),
('Light Sensor', 'Aeotec', 'ZWA005', 'Light level detection for automation'),
('Vibration Sensor', 'Samsung SmartThings', 'STS-MLT-250', 'Detects vibration or tampering'),
('CO2 Sensor', 'Libelium', 'Waspmote-Gases', 'Measures CO2 for air quality monitoring'),
('Occupancy Sensor', 'Ecolink', 'PIRZWAVE2.5-ECO', 'Passive infrared motion for occupancy detection'),
('Glass Break Sensor', 'Honeywell', 'FG1625', 'Detects glass breakage with audio analysis'),
('UV Sensor', 'VEML6075', 'Adafruit-VEML6075', 'Ultraviolet light detection for indoor exposure'),
('Sound Sensor', 'Grove', 'SEN-12462', 'Monitors ambient sound levels'),
('Flood Sensor', 'D-Link', 'DCH-S162', 'Wi-Fi water leak and freeze detector'),
('Pressure Sensor', 'Bosch', 'BMP280', 'Barometric pressure sensor for weather data'),
('Temperature & Humidity', 'Xiaomi', 'LYWSD03MMC', 'Bluetooth temp and humidity combo sensor'),
('Presence Sensor', 'Sonoff', 'SNZB-03', 'Infrared human presence detection'),
('Gas Detector', 'Fibaro', 'FGCD-001', 'Z-Wave CO gas detector'),
('Multi-Sensor', 'Aeotec', 'ZWA005-A', '6-in-1 sensor: motion, temp, humidity, light, UV, vibration');

SELECT * FROM Sensor;



INSERT INTO Controller (ControllerType, Protocol, Manufacturer, Model)
VALUES
('Smart Hub', 'Zigbee', 'Samsung SmartThings', 'STH-ETH-250'),
('Bridge', 'Zigbee', 'Philips Hue', 'Hue Bridge v2'),
('Home Gateway', 'Z-Wave', 'Aeotec', 'Z-Stick Gen5'),
('IoT Edge Gateway', 'Wi-Fi', 'Cisco', 'IR1101'),
('Smart Hub', 'Wi-Fi', 'Amazon', 'Echo 4th Gen'),
('Controller', 'Z-Wave', 'Fibaro', 'Home Center 3'),
('Hub', 'Thread', 'Google Nest', 'Nest Hub Max'),
('Central Unit', 'LoRa', 'Libelium', 'Meshlium Xtreme'),
('Gateway', 'Bluetooth', 'Xiaomi', 'Aqara Hub M2'),
('Edge Controller', 'Ethernet', 'Bosch', 'IoT Gateway'),
('Smart Gateway', 'Zigbee', 'Tuya', 'Zigbee 3.0 Hub'),
('Router + Hub', 'Zigbee/Z-Wave', 'Hubitat', 'Elevation C-8'),
('IoT Hub', 'Wi-Fi', 'TP-Link', 'Kasa Smart Hub KH100'),
('Security Panel', 'Z-Wave', 'Ring', 'Alarm Base Station Gen2'),
('Bridge', 'Zigbee', 'IKEA', 'TRÅDFRI Gateway'),
('IoT Gateway', 'LTE', 'Teltonika', 'TRB140'),
('Mini Controller', 'Wi-Fi', 'Sonoff', 'NSPanel'),
('Mesh Controller', 'Z-Wave', 'Ezlo', 'Plus Hub'),
('Smart Panel', 'Zigbee', 'Moes', 'Zigbee Scene Controller'),
('IoT Edge Box', 'Modbus TCP', 'Advantech', 'UNO-420');

SELECT * FROM Controller;


INSERT INTO SpecialDevice (DeviceType, Manufacturer, Model, Description)
VALUES
('HD CCTV Camera', 'Arlo', 'Pro 4', '1080p wire-free security camera with night vision'),
('Smart Door Lock', 'August', 'Wi-Fi Smart Lock', 'Keyless entry with mobile control'),
('Smart Thermostat', 'Nest', 'Learning Thermostat Gen 3', 'Learns schedule and controls temperature'),
('Smart Plug', 'TP-Link', 'HS110', 'Wi-Fi plug with energy monitoring'),
('Smart Light Switch', 'Lutron', 'Caseta Wireless', 'Wireless smart light dimmer'),
('Smart Doorbell', 'Ring', 'Video Doorbell Pro 2', 'HD video with motion detection and audio'),
('Smart Alarm Siren', 'Aeotec', 'Z-Wave Siren 6', 'Loud alarm with visual alerts'),
('Automation Panel', 'Fibaro', 'Walli Controller', 'Scene activation panel for automation'),
('Smart Curtain Controller', 'Aqara', 'Roller Shade Driver E1', 'Controls motorized blinds'),
('Garage Door Opener', 'Meross', 'MSG100', 'Wi-Fi smart garage controller'),
('Ultrasonic Motion Detector', 'Milesight', 'EM300-UDL', 'Ultrasonic level & motion sensor'),
('IR Blaster', 'BroadLink', 'RM4 Pro', 'Controls IR and RF home devices'),
('Smart Leak Shutoff Valve', 'Guardian', 'Leak Prevention System', 'Detects leaks and shuts off water'),
('Smart Fan Controller', 'Sensibo', 'Sky', 'Wi-Fi AC and fan controller'),
('Smart Energy Monitor', 'Shelly', '3EM', 'Three-phase electricity monitoring device'),
('Smart Window Opener', 'Opalux', 'OPWX-01', 'Motorized window opener with remote'),
('Smart Intercom System', '2N', 'IP Verso', 'Smart video/audio intercom for buildings'),
('IR Temperature Scanner', 'Seek', 'CompactPRO', 'Thermal imaging for entry points'),
('Smart Pet Feeder', 'PetSafe', 'Smart Feed 2nd Gen', 'Automatic feeder with Wi-Fi app control'),
('Smart Irrigation Controller', 'Rachio', 'Rachio 3', 'Wi-Fi sprinkler controller with weather sync');

SELECT * FROM SpecialDevice;


INSERT INTO Supplier (Name, Website, ContactEmail)
VALUES
('Libelium', 'https://www.libelium.com', 'contact@libelium.com'),
('Shenzhen Kingtech', 'https://www.kingtech.com.cn', 'info@kingtech.com.cn'),
('Bosch UK', 'https://www.bosch.co.uk', 'iot@bosch.co.uk'),
('Aqara', 'https://www.aqara.com', 'support@aqara.com'),
('Fibaro', 'https://www.fibaro.com', 'contact@fibaro.com'),
('Philips Hue', 'https://www.philips-hue.com', 'support@hue.philips.com'),
('Samsung SmartThings', 'https://www.smartthings.com', 'support@smartthings.com'),
('Honeywell Home', 'https://www.honeywellhome.com', 'support@honeywellhome.com'),
('Arlo Technologies', 'https://www.arlo.com', 'support@arlo.com'),
('TP-Link UK', 'https://www.tp-link.com/uk', 'support.uk@tp-link.com'),
('Amazon Devices UK', 'https://www.amazon.co.uk', 'alexa-devices@amazon.com'),
('Google Nest UK', 'https://store.google.com/uk', 'nest-support@google.com'),
('Netatmo', 'https://www.netatmo.com', 'contact@netatmo.com'),
('Xiaomi Global', 'https://www.mi.com/global', 'support@mi.com'),
('Aeotec', 'https://aeotec.com', 'support@aeotec.com'),
('Ring UK', 'https://en-uk.ring.com', 'help@ring.com'),
('Tuya Smart', 'https://www.tuya.com', 'sales@tuya.com'),
('Shelly Europe', 'https://www.shelly.com', 'info@shelly.com'),
('D-Link UK', 'https://eu.dlink.com/uk', 'support@dlink.co.uk'),
('IKEA TRÅDFRI', 'https://www.ikea.com/gb/en', 'iot@ikea.co.uk');

SELECT * FROM Supplier;


INSERT INTO StockItem (SupplierID, ItemType, QuantityAvailable, LastCheckedDate)
VALUES
(1, 'Sensor', 130, '2024-03-01'),
(2, 'Sensor', 85, '2024-03-05'),
(3, 'Sensor', 100, '2024-03-06'),
(4, 'Sensor', 60, '2024-03-03'),
(5, 'Controller', 40, '2024-03-04'),
(6, 'Controller', 75, '2024-03-05'),
(7, 'Controller', 50, '2024-03-02'),
(8, 'Sensor', 90, '2024-02-28'),
(9, 'SpecialDevice', 30, '2024-03-05'),
(10, 'Controller', 80, '2024-03-01'),
(11, 'Controller', 100, '2024-03-06'),
(12, 'Controller', 45, '2024-03-04'),
(13, 'Sensor', 70, '2024-03-03'),
(14, 'Sensor', 55, '2024-02-27'),
(15, 'Controller', 65, '2024-03-06'),
(16, 'SpecialDevice', 22, '2024-03-01'),
(17, 'SpecialDevice', 18, '2024-03-02'),
(18, 'SpecialDevice', 35, '2024-03-06'),
(19, 'Sensor', 105, '2024-03-05'),
(20, 'SpecialDevice', 28, '2024-03-03');

SELECT * FROM StockItem;


INSERT INTO StockDevice (StockItemID, SensorID, ControllerID, SpecialDeviceID)
VALUES
(1, 1, NULL, NULL),   -- Temp sensor from Libelium
(2, 2, NULL, NULL),   -- Humidity sensor from Shenzhen
(3, 3, NULL, NULL),   -- Smoke detector from Bosch
(4, 4, NULL, NULL),   -- Motion sensor from Aqara
(5, NULL, 1, NULL),   -- Controller from Fibaro
(6, NULL, 2, NULL),   -- Philips Hue Zigbee Bridge
(7, NULL, 3, NULL),   -- SmartThings hub
(8, 5, NULL, NULL),   -- Door/window sensor from Aqara
(9, NULL, NULL, 1),   -- CCTV Camera from Arlo
(10, NULL, 4, NULL),  -- Cisco Edge Gateway
(11, NULL, 5, NULL),  -- Amazon Echo Hub
(12, NULL, 6, NULL),  -- Fibaro Home Center
(13, 6, NULL, NULL),  -- Leak sensor from Fibaro
(14, 7, NULL, NULL),  -- Air Quality sensor from Netatmo
(15, NULL, 7, NULL),  -- Google Nest Hub
(16, NULL, NULL, 2),  -- Smart Door Lock from August
(17, NULL, NULL, 3),  -- Nest Thermostat
(18, NULL, NULL, 4),  -- Smart Plug TP-Link
(19, 8, NULL, NULL),  -- Light sensor Aeotec
(20, NULL, NULL, 5);  -- Light switch from Lutron

SELECT * FROM StockDevice;


INSERT INTO Design (BuildingID, DateCreated, ImplementedByLSBU)
VALUES
(1, '2023-04-01', 1),
(1, '2023-09-15', 0),
(2, '2023-05-10', 1),
(3, '2023-07-05', 1),
(4, '2023-08-20', 0),
(5, '2023-03-18', 1),
(6, '2023-11-02', 1),
(7, '2023-06-12', 0),
(8, '2023-02-22', 1),
(9, '2023-12-01', 1),
(10, '2023-01-17', 0),
(11, '2023-05-25', 1),
(12, '2023-07-30', 1),
(13, '2023-09-11', 0),
(14, '2023-04-19', 1),
(15, '2023-10-07', 1),
(16, '2023-06-03', 0),
(17, '2023-08-15', 1),
(18, '2023-03-29', 1),
(19, '2023-11-22', 0);

SELECT * FROM Design;


INSERT INTO DesignComponent (DesignID, SensorID, ControllerID, SpecialDeviceID, LocationInBuilding)
VALUES
(1, 1, NULL, NULL, 'Living Room'),
(1, NULL, 1, NULL, 'Main Hallway'),
(2, NULL, NULL, 1, 'Front Door'),
(3, 2, NULL, NULL, 'Kitchen'),
(4, NULL, 2, NULL, 'Central Control Cabinet'),
(5, 3, NULL, NULL, 'Upstairs Hall'),
(6, NULL, NULL, 2, 'Garage'),
(7, 4, NULL, NULL, 'Master Bedroom'),
(8, NULL, 3, NULL, 'Data Rack'),
(9, NULL, NULL, 3, 'Backyard'),
(10, 5, NULL, NULL, 'Utility Room'),
(11, NULL, 4, NULL, 'Living Area Panel'),
(12, 6, NULL, NULL, 'Bathroom'),
(13, NULL, NULL, 4, 'Attic Entrance'),
(14, 7, NULL, NULL, 'Nursery'),
(15, NULL, 5, NULL, 'Wall Mount Cabinet'),
(16, NULL, NULL, 5, 'Driveway'),
(17, 8, NULL, NULL, 'Office Window'),
(18, NULL, 6, NULL, 'Smart Cabinet'),
(19, NULL, NULL, 6, 'Entrance Hall'),
(20, 1, NULL, NULL, 'Ground Floor Living Room');

SELECT * FROM DesignComponent;



INSERT INTO SensorControllerCompatibility (SensorID, ControllerID)
VALUES
(1, 1),   -- Temperature sensor with SmartThings
(1, 2),   -- Temperature sensor with Hue Bridge
(2, 1),   -- Humidity sensor with SmartThings
(2, 3),   -- With Aeotec Z-Wave
(3, 4),   -- Smoke sensor with Cisco Edge Gateway
(4, 1),   -- Motion with SmartThings
(4, 5),   -- Motion with Echo Hub
(5, 6),   -- Door/Window with Fibaro
(6, 3),   -- Leak with Aeotec
(6, 6),   -- Leak with Fibaro
(7, 4),   -- Air quality with Cisco IoT
(8, 1),   -- Light sensor with SmartThings
(8, 2),   -- Light with Philips Hue
(9, 5),   -- Vibration with Echo
(10, 3),  -- CO2 with Aeotec
(10, 4),  -- CO2 with Cisco
(11, 6),  -- Occupancy with Fibaro
(12, 1),  -- Glass break with SmartThings
(13, 2),  -- UV with Hue Bridge
(14, 4);  -- Sound sensor with Cisco

SELECT * FROM SensorControllerCompatibility;



INSERT INTO Staff (FirstName, LastName, PhoneNumber, Email, AvailabilityStatus, AreaOfExpertise)
VALUES
('James', 'Walker', '07300111223', 'james.walker@lsbu-smarthome.co.uk', 'Available', 'Sensor Installation'),
('Amelia', 'Scott', '07400987651', 'amelia.scott@lsbu-smarthome.co.uk', 'On Leave', 'Electrical Engineering'),
('Liam', 'Thompson', '07500123987', 'liam.thompson@lsbu-smarthome.co.uk', 'Available', 'System Integration'),
('Olivia', 'White', '07600456789', 'olivia.white@lsbu-smarthome.co.uk', 'On Site', 'CCTV Installation'),
('Noah', 'Morris', '07344556677', 'noah.morris@lsbu-smarthome.co.uk', 'Available', 'Controller Configuration'),
('Isla', 'Evans', '07588990011', 'isla.evans@lsbu-smarthome.co.uk', 'On Site', 'HVAC Integration'),
('William', 'Baker', '07776543210', 'william.baker@lsbu-smarthome.co.uk', 'Available', 'Data Networking'),
('Ava', 'Cooper', '07333445566', 'ava.cooper@lsbu-smarthome.co.uk', 'On Leave', 'Fire Safety Systems'),
('Lucas', 'Hall', '07455443322', 'lucas.hall@lsbu-smarthome.co.uk', 'Available', 'Smart Device Pairing'),
('Freya', 'Morgan', '07312233445', 'freya.morgan@lsbu-smarthome.co.uk', 'On Site', 'Mobile App Testing'),
('Henry', 'Ward', '07599887766', 'henry.ward@lsbu-smarthome.co.uk', 'Available', 'Lighting Automation'),
('Mia', 'Young', '07422113344', 'mia.young@lsbu-smarthome.co.uk', 'Available', 'Customer Support'),
('George', 'Turner', '07333557788', 'george.turner@lsbu-smarthome.co.uk', 'On Leave', 'Sensor Tuning'),
('Lily', 'Parker', '07477889900', 'lily.parker@lsbu-smarthome.co.uk', 'Available', 'Energy Systems'),
('Charlie', 'Reed', '07600011234', 'charlie.reed@lsbu-smarthome.co.uk', 'On Site', 'Wiring & Cabling'),
('Grace', 'James', '07522334455', 'grace.james@lsbu-smarthome.co.uk', 'Available', 'Client Training'),
('Leo', 'Bennett', '07388776655', 'leo.bennett@lsbu-smarthome.co.uk', 'On Site', 'Diagnostics & Repairs'),
('Sophie', 'Murray', '07466554433', 'sophie.murray@lsbu-smarthome.co.uk', 'Available', 'IoT Firmware'),
('Jacob', 'Ross', '07544433221', 'jacob.ross@lsbu-smarthome.co.uk', 'Available', 'Automation Configuration'),
('Emily', 'Campbell', '07322119988', 'emily.campbell@lsbu-smarthome.co.uk', 'On Leave', 'Security Systems');

SELECT * FROM Staff;

--create the Installation Teams and assign staff to them using the InstallationTeam and TeamMember tables--

INSERT INTO InstallationTeam (TeamName)
VALUES
('Team Alpha'),
('Team Beta'),
('Team Gamma'),
('Team Delta'),
('Team Epsilon'),
('Team Zeta'),
('Team Theta'),
('Team Omega'),
('Team Sigma'),
('Team Nova');

SELECT * FROM InstallationTeam;

------------assign 2–3 members per team from the Staff table ------

INSERT INTO TeamMember (TeamID, StaffID)
VALUES
(1, 1), (1, 2),
(2, 3), (2, 4),
(3, 5), (3, 6),
(4, 7), (4, 8),
(5, 9), (5, 10), (5, 11),
(6, 12), (6, 13),
(7, 14), (7, 15),
(8, 16), (8, 17),
(9, 18), (9, 19),
(10, 20), (10, 1);  -- Staff 1 is in two teams (for flexibility)

SELECT * FROM TeamMember;

INSERT INTO ComponentInstallationLog (ComponentID, StaffID, InstallDate, Notes)
VALUES
(1, 1, '2023-04-03', 'Installed temp sensor in Living Room'),
(2, 3, '2023-04-03', 'Smart controller mounted to main hallway'),
(3, 4, '2023-09-17', 'CCTV positioned for entry view'),
(4, 5, '2023-05-11', 'Humidity sensor calibrated'),
(5, 6, '2023-08-22', 'Controller installed in cabinet'),
(6, 2, '2023-03-20', 'Smoke sensor checked with client'),
(7, 7, '2023-11-03', 'Garage special device mounted'),
(8, 8, '2023-06-13', 'Motion sensor setup complete'),
(9, 9, '2023-02-23', 'Network controller activated'),
(10, 10, '2023-12-02', 'Outdoor camera aligned'),
(11, 11, '2023-01-18', 'Leak sensor placed near pipes'),
(12, 12, '2023-05-26', 'Living area controller synced'),
(13, 13, '2023-07-31', 'Bathroom sensor verified'),
(14, 14, '2023-09-12', 'Attic alarm connected'),
(15, 15, '2023-04-20', 'Nursery sensor integrated'),
(16, 16, '2023-10-08', 'Driveway device bolted to wall'),
(17, 17, '2023-06-04', 'Window sensor confirmed active'),
(18, 18, '2023-08-16', 'Cabinet hub tested'),
(19, 19, '2023-03-30', 'Entrance camera synced'),
(20, 20, '2023-01-20', 'Living room sensor tested');

SELECT * FROM ComponentInstallationLog;


INSERT INTO Invoice (ClientID, IssueDate, DueDate, Amount, InvoiceType)
VALUES
(1, '2023-04-05', '2023-05-03', 850.00, 'Design'),
(2, '2023-05-12', '2023-06-09', 1200.00, 'Installation'),
(3, '2023-07-08', '2023-08-05', 300.00, 'Maintenance'),
(4, '2023-09-02', '2023-09-30', 975.00, 'Design'),
(5, '2023-03-20', '2023-04-17', 1500.00, 'Installation'),
(6, '2023-11-15', '2023-12-13', 400.00, 'Maintenance'),
(7, '2023-06-10', '2023-07-08', 2100.00, 'Installation'),
(8, '2023-02-14', '2023-03-13', 750.00, 'Design'),
(9, '2023-12-01', '2023-12-29', 1300.00, 'Installation'),
(10, '2023-01-10', '2023-02-07', 250.00, 'Maintenance'),
(11, '2023-05-26', '2023-06-23', 990.00, 'Design'),
(12, '2023-07-31', '2023-08-28', 2200.00, 'Installation'),
(13, '2023-09-12', '2023-10-10', 315.00, 'Maintenance'),
(14, '2023-04-22', '2023-05-20', 1050.00, 'Design'),
(15, '2023-10-09', '2023-11-06', 1800.00, 'Installation'),
(16, '2023-06-04', '2023-07-02', 390.00, 'Maintenance'),
(17, '2023-08-17', '2023-09-14', 950.00, 'Design'),
(18, '2023-03-31', '2023-04-28', 1600.00, 'Installation'),
(19, '2023-12-03', '2023-12-31', 275.00, 'Maintenance'),
(20, '2023-01-21', '2023-02-18', 1100.00, 'Design');

SELECT * FROM Invoice;



INSERT INTO PaymentMethod (MethodName)
VALUES
('Credit Card'),
('Debit Card'),
('PayPal'),
('Google Pay'),
('Apple Pay');

SELECT * FROM PaymentMethod;

INSERT INTO Payment (InvoiceID, PaymentMethodID, PaymentDate)
VALUES
(1, 1, '2023-04-20'),
(2, 2, '2023-05-25'),
(3, 3, '2023-07-25'),
(4, 4, '2023-09-25'),
(5, 1, '2023-04-12'),
(6, 2, '2023-11-30'),
(7, 5, '2023-06-25'),
(8, 3, '2023-03-02'),
(9, 1, '2023-12-15'),
(10, 4, '2023-01-25'),
(11, 2, '2023-06-10'),
(12, 1, '2023-08-12'),
(13, 5, '2023-09-27'),
(14, 3, '2023-05-01'),
(15, 2, '2023-10-20'),
(16, 1, '2023-06-25'),
(17, 4, '2023-09-02'),
(18, 1, '2023-04-15'),
(19, 5, '2023-12-20'),
(20, 3, '2023-02-10');

SELECT * FROM Payment;



INSERT INTO StockCheckLog (StockItemID, CheckedDate, QuantityAvailable)
VALUES
(1, '2024-03-01', 130),
(2, '2024-03-01', 82),
(3, '2024-03-02', 99),
(4, '2024-03-03', 60),
(5, '2024-03-04', 39),
(6, '2024-03-04', 74),
(7, '2024-03-05', 50),
(8, '2024-03-05', 90),
(9, '2024-03-05', 29),
(10, '2024-03-06', 78),
(11, '2024-03-06', 100),
(12, '2024-03-06', 45),
(13, '2024-03-06', 68),
(14, '2024-03-06', 54),
(15, '2024-03-06', 64),
(16, '2024-03-06', 22),
(17, '2024-03-06', 17),
(18, '2024-03-06', 35),
(19, '2024-03-06', 102),
(20, '2024-03-06', 28);

SELECT * FROM StockCheckLog;



----------TESTING THE DATABASE---------

SELECT 
    i.InvoiceID,
    CONCAT(c.FirstName, ' ', c.LastName) AS ClientName,
    i.Amount,
    i.InvoiceType,
    i.IssueDate,
    p.PaymentDate,
    pm.MethodName AS PaymentMethod
FROM Invoice i
JOIN Client c ON i.ClientID = c.ClientID
LEFT JOIN Payment p ON i.InvoiceID = p.InvoiceID
LEFT JOIN PaymentMethod pm ON p.PaymentMethodID = pm.PaymentMethodID
ORDER BY i.IssueDate DESC;




------issue----


SELECT TOP 10 *
FROM Client c
JOIN ClientBuilding cb ON c.ClientID = cb.ClientID;


SELECT * FROM ClientBuilding

/*The issue with the ClientBuilding table was that the ClientID values didn’t match the ones in the Client table. 
This meant that when trying to join both tables, no data appeared because there were no matching IDs. 
Once we deleted the incorrect records and reinserted them using valid ClientIDs, the join worked correctly and the relationships were restored.*/

DELETE FROM ClientBuilding;

INSERT INTO ClientBuilding (ClientID, BuildingID, OwnershipType, AccessLevel, ContractStartDate, ContractEndDate, Notes)
VALUES
(1, 1, 'Owner', 'Full', '2023-01-16', NULL, 'Primary residence'),
(1, 2, 'Tenant', 'Read-Only', '2023-03-01', '2024-03-01', 'Temporary access for testing'),
(2, 3, 'Owner', 'Full', '2023-02-11', NULL, 'Full office access'),
(3, 4, 'Owner', 'Full', '2022-12-01', NULL, ''),
(3, 5, 'Owner', 'Full', '2022-12-15', NULL, ''),
(4, 6, 'Tenant', 'Read-Only', '2023-03-05', '2024-03-05', ''),
(5, 7, 'Owner', 'Full', '2023-01-01', NULL, 'Main office'),
(6, 8, 'Owner', 'Full', '2023-02-01', NULL, 'Private residence'),
(7, 9, 'Owner', 'Full', '2023-03-13', NULL, ''),
(8, 10, 'Tenant', 'Limited', '2023-01-19', '2024-01-19', ''),
(9, 11, 'Owner', 'Full', '2022-10-30', NULL, ''),
(10, 12, 'Owner', 'Full', '2023-02-15', NULL, ''),
(11, 13, 'Owner', 'Full', '2023-01-08', NULL, ''),
(11, 14, 'Tenant', 'Read-Only', '2023-03-01', '2023-09-01', 'Shared test site'),
(12, 15, 'Owner', 'Full', '2023-03-04', NULL, ''),
(13, 16, 'Tenant', 'Read-Only', '2022-09-19', '2023-09-19', ''),
(14, 17, 'Owner', 'Full', '2023-03-11', NULL, 'Smart project site'),
(15, 18, 'Owner', 'Full', '2023-02-01', NULL, ''),
(16, 19, 'Owner', 'Full', '2023-03-10', NULL, ''),
(17, 20, 'Tenant', 'Limited', '2022-11-26', '2023-11-26', 'Trial project');


SELECT TOP 10 *
FROM Client c
JOIN ClientBuilding cb ON c.ClientID = cb.ClientID;



SELECT 
    c.ClientID,
    CONCAT(c.FirstName, ' ', c.LastName) AS ClientName,
    COUNT(cb.BuildingID) AS NumberOfBuildings
FROM Client c
JOIN ClientBuilding cb ON c.ClientID = cb.ClientID
GROUP BY c.ClientID, c.FirstName, c.LastName
ORDER BY NumberOfBuildings DESC;



SELECT 
    InvoiceType,
    COUNT(*) AS InvoiceCount,
    SUM(Amount) AS TotalBilled
FROM Invoice
GROUP BY InvoiceType;



-----------------------QUERIES-----------

/* 4a. Show details of clients, their property location(s), and the total value of Smart Home designs installed. 
Limit to clients with the most and least total values. */

WITH Totals AS (
    SELECT 
        c.ClientID,
        CONCAT(c.FirstName, ' ', c.LastName) AS ClientName,
        SUM(i.Amount) AS TotalDesignValue
    FROM Client c
    JOIN Invoice i ON c.ClientID = i.ClientID AND i.InvoiceType = 'Design'
    GROUP BY c.ClientID, c.FirstName, c.LastName
),
MinMax AS (
    SELECT 
        MIN(TotalDesignValue) AS MinVal,
        MAX(TotalDesignValue) AS MaxVal
    FROM Totals
),
WithAddress AS (
    SELECT 
        t.ClientID,
        t.ClientName,
        MIN(b.Address) AS Address,
        t.TotalDesignValue
    FROM Totals t
    LEFT JOIN ClientBuilding cb ON t.ClientID = cb.ClientID
    LEFT JOIN Building b ON cb.BuildingID = b.BuildingID
    GROUP BY t.ClientID, t.ClientName, t.TotalDesignValue
)
SELECT *
FROM WithAddress
WHERE TotalDesignValue = (SELECT MinVal FROM MinMax)
   OR TotalDesignValue = (SELECT MaxVal FROM MinMax)
ORDER BY TotalDesignValue DESC;


 

/*  4b. Query to calculate totals for complete, incomplete, and cancelled WiFi product orders from each supplier. */

--QUERY4.B--
SELECT 
    s.SupplierID,
    s.Name AS SupplierName,
    si.OrderStatus,
    COUNT(*) AS TotalOrders
FROM Supplier s
JOIN StockItem si ON s.SupplierID = si.SupplierID
WHERE si.ItemType LIKE '%WiFi%'
GROUP BY s.SupplierID, s.Name, si.OrderStatus
ORDER BY s.Name, si.OrderStatus;




/* 4c – Query to find available specialist staff for installation jobs this week*/

SELECT 
    StaffID,
    CONCAT(FirstName, ' ', LastName) AS StaffName,
    PhoneNumber,
    Email,
    AreaOfExpertise,
    AvailabilityStatus
FROM Staff
WHERE AvailabilityStatus = 'Available'
  AND AreaOfExpertise IS NOT NULL
ORDER BY AreaOfExpertise, LastName;



/*4.D d
Implement using triggers and/or stored procedures automatic prevention of double-booking of
specialist staff during the installation booking process.*/

CREATE TRIGGER trg_PreventDoubleBooking
ON ComponentInstallationLog
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM ComponentInstallationLog c
        JOIN inserted i ON c.StaffID = i.StaffID AND c.InstallDate = i.InstallDate
    )
    BEGIN
        RAISERROR ('Staff member is already booked for an installation on this date.', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        INSERT INTO ComponentInstallationLog (ComponentID, StaffID, InstallDate, Notes)
        SELECT ComponentID, StaffID, InstallDate, Notes FROM inserted;
    END
END;


---testing--
INSERT INTO ComponentInstallationLog (ComponentID, StaffID, InstallDate, Notes)
VALUES (5, 1, '2025-03-28', 'Initial install for Zone A');

INSERT INTO ComponentInstallationLog (ComponentID, StaffID, InstallDate, Notes)
VALUES (6, 1, '2025-03-28', 'Second install attempt (should fail)');





/*4.E Write a Stored Procedure that can generate a complete costed device list and total cost for any installation (s) 
in a specified time related period. The output must also include client and device details. 
The procedure should be able to accept appropriate parameter values to enable dynamic search by week, month or 
quarter (3 months) Include appropriate attributes and totals in your report*/


CREATE PROCEDURE sp_GetCostedInstallationsByPeriod
    @PeriodType NVARCHAR(10)
AS
BEGIN
    DECLARE @StartDate DATE

    SET @StartDate = 
        CASE 
            WHEN @PeriodType = 'week' THEN DATEADD(DAY, -7, GETDATE())
            WHEN @PeriodType = 'month' THEN DATEADD(MONTH, -1, GETDATE())
            WHEN @PeriodType = 'quarter' THEN DATEADD(MONTH, -3, GETDATE())
            ELSE NULL
        END;

    IF @StartDate IS NULL
    BEGIN
        RAISERROR('Invalid period type. Use ''week'', ''month'' or ''quarter''.', 16, 1);
        RETURN;
    END

    SELECT 
        c.ClientID,
        CONCAT(c.FirstName, ' ', c.LastName) AS ClientName,
        b.Address,
        dc.ComponentID,
        cl.InstallDate,
        MAX(i.Amount) AS InstallationCost
    FROM Client c
    JOIN ClientBuilding cb ON c.ClientID = cb.ClientID
    JOIN Building b ON cb.BuildingID = b.BuildingID
    JOIN Design d ON b.BuildingID = d.BuildingID
    JOIN DesignComponent dc ON d.DesignID = dc.DesignID
    JOIN ComponentInstallationLog cl ON dc.ComponentID = cl.ComponentID
    JOIN Invoice i ON c.ClientID = i.ClientID AND i.InvoiceType = 'Installation'
    WHERE cl.InstallDate BETWEEN @StartDate AND GETDATE()
    GROUP BY 
        c.ClientID, c.FirstName, c.LastName,
        b.Address, dc.ComponentID, cl.InstallDate
    ORDER BY cl.InstallDate DESC;
END;

SELECT * FROM ComponentInstallationLog
---testing---

EXEC sp_GetCostedInstallationsByPeriod @PeriodType = 'month';



