Create Database HotelDW
GO

USE HotelDW;
GO
CREATE TABLE Dim_Guests(
    GuestID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    FullName VARCHAR(60) NOT NULL,
    Gender VARCHAR(10) NOT NULL,
    Nationality VARCHAR(20) NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    Email VARCHAR(50) NOT NULL
);

CREATE TABLE Dim_Dates(
    DateID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    FullDate DATE NOT NULL,
    Day INT NOT NULL,
    Month INT NOT NULL,
    Year INT NOT NULL,
    WeekDay VARCHAR(10) NOT NULL
);

CREATE TABLE Dim_Rooms(
    RoomID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    RoomNumber INT NOT NULL,
    RoomTypeID INT NOT NULL,
    PricePerNight DECIMAL(8, 2) NOT NULL,
    RoomStatus VARCHAR(20) NOT NULL
);

CREATE TABLE Dim_Employees(
    EmployeeID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    EmployeeName VARCHAR(50) NOT NULL,
    Position VARCHAR(30) NOT NULL,
    Department VARCHAR(30) NOT NULL,
    Phone VARCHAR(15) NOT NULL
);

CREATE TABLE Dim_PaymentMethods(
    PaymentMethodID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    PaymentMethodName VARCHAR(30) NOT NULL
);

CREATE TABLE Dim_Services(
    ServiceID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    ServiceName VARCHAR(50) NOT NULL,
    ServiceCost DECIMAL(8, 2) NOT NULL
);

CREATE TABLE Dim_Branches(
    BranchID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    BranchName VARCHAR(50) NOT NULL,
    City VARCHAR(30) NOT NULL,
    Country VARCHAR(30) NOT NULL
);

CREATE TABLE Dim_BookingChannels(
    ChannelID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    ChannelName VARCHAR(30) NOT NULL
);

CREATE TABLE Dim_roomTypes(
    RoomTypeID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    RoomTypeName VARCHAR(50) NOT NULL,
    Capacity INT NOT NULL,
    Description VARCHAR(255) NOT NULL
);

CREATE TABLE Fact_Bookings(
    BookingID INT NOT NULL IDENTITY(1, 1)  Primary key ,
    GuestID INT NOT NULL,
    RoomID INT NOT NULL,
    EmployeeID INT NOT NULL,
    BranchID INT NOT NULL,
    ChannelID INT NOT NULL,
    CheckInDate INT NOT NULL,
    CheckOutDate INT NOT NULL,
    NumberOfGuests INT NOT NULL,
    TotalAmount DECIMAL(8, 2) NOT NULL,
    BookingStatus VARCHAR(20) NOT NULL
);

CREATE TABLE Fact_Payments(
    PaymentID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    BookingID INT NOT NULL,
    PaymentMethodID INT NOT NULL,
    AmountPaid DECIMAL(8, 2) NOT NULL,
    PaymentDate INT NOT NULL
);

CREATE TABLE Fact_HotelServices(
    ServiceTransactionID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    BookingID INT NOT NULL,
    ServiceID INT NOT NULL,
    Quantity INT NOT NULL,
    TotalServiceCost DECIMAL(10, 2) NOT NULL
);

CREATE TABLE Fact_RoomMaintenance(
    MaintenanceID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    RoomID INT NOT NULL,
    EmployeeID INT NOT NULL,
    MaintenanceDate INT NOT NULL,
    MaintenanceType VARCHAR(50) NOT NULL,
    MaintenanceCost DECIMAL(10, 2) NOT NULL
);

CREATE TABLE Fact_EmployeeShifts(
    ShiftID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    EmployeeID INT NOT NULL,
    BranchID INT NOT NULL,
    DateID INT NOT NULL,
    ShiftStart TIME NOT NULL,
    ShiftEnd TIME NOT NULL
);

CREATE TABLE Fact_Reviews(
    ReviewID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    GuestID INT NOT NULL,
    BookingID INT NOT NULL,
    Rating INT NOT NULL,
    ReviewComment VARCHAR(255) NOT NULL,
    ReviewDateID INT NOT NULL
);

ALTER TABLE Fact_Reviews
ADD CONSTRAINT Reviews_Dates_FK FOREIGN KEY(ReviewDateID)
REFERENCES Dim_Dates(DateID);

ALTER TABLE Fact_Reviews
ADD CONSTRAINT Reviews_Bookings_FK
FOREIGN KEY(BookingID)
REFERENCES Fact_Bookings(BookingID);

ALTER TABLE Fact_Reviews
ADD CONSTRAINT Reviews_Guests_FK FOREIGN KEY(GuestID) 
REFERENCES Dim_Guests(GuestID);

ALTER TABLE Fact_Reviews
ADD CONSTRAINT chk_rating
CHECK (Rating BETWEEN 1 AND 5);

ALTER TABLE Fact_HotelServices
ADD CONSTRAINT Hotelservices_Bookings_FK FOREIGN KEY(BookingID)
REFERENCES Fact_Bookings(BookingID);

ALTER TABLE Fact_EmployeeShifts 
ADD CONSTRAINT Employeeshifts_Branches_FK FOREIGN KEY(BranchID) 
REFERENCES Dim_Branches(BranchID);

ALTER TABLE Fact_EmployeeShifts 
ADD CONSTRAINT Employeeshifts_Dates_FK FOREIGN KEY(DateID)
REFERENCES Dim_Dates(DateID);

ALTER TABLE Fact_EmployeeShifts
ADD CONSTRAINT Employeeshifts_Employees_FK FOREIGN KEY(EmployeeID) 
REFERENCES Dim_Employees(EmployeeID);

ALTER TABLE Fact_Bookings
ADD CONSTRAINT bookings_Branches_FK FOREIGN KEY(BranchID) 
REFERENCES Dim_Branches(BranchID);

ALTER TABLE Fact_Bookings 
ADD CONSTRAINT Bookings_Employees_FK FOREIGN KEY(EmployeeID) 
REFERENCES Dim_Employees(EmployeeID);

ALTER TABLE Fact_Bookings 
ADD CONSTRAINT Bookings_Rooms_FK FOREIGN KEY(RoomID) 
REFERENCES Dim_Rooms(RoomID);

ALTER TABLE Fact_Bookings 
ADD CONSTRAINT Bookings_Channels_FK FOREIGN KEY(ChannelID) 
REFERENCES Dim_BookingChannels(ChannelID);

ALTER TABLE Fact_HotelServices
ADD CONSTRAINT Hotelservices_Services_FK FOREIGN KEY(ServiceID) 
REFERENCES Dim_Services(ServiceID);

ALTER TABLE Fact_Payments 
ADD CONSTRAINT Payments_Paymentmethods_FK FOREIGN KEY(PaymentMethodID) 
REFERENCES Dim_PaymentMethods(PaymentMethodID);

ALTER TABLE Fact_Payments 
ADD CONSTRAINT Payments_Bookings_FK FOREIGN KEY(BookingID) 
REFERENCES Fact_Bookings(BookingID);

ALTER TABLE Fact_Bookings 
ADD CONSTRAINT Bookings_Dates_FK FOREIGN KEY(CheckInDate) 
REFERENCES Dim_Dates(DateID);

ALTER TABLE Fact_Bookings 
ADD CONSTRAINT bookings_checkoutdate_FK FOREIGN KEY(CheckOutDate) 
REFERENCES Dim_Dates(DateID);

ALTER TABLE Fact_Bookings 
ADD CONSTRAINT Bookings_Guest_FK FOREIGN KEY(GuestID) 
REFERENCES Dim_Guests(GuestID);

ALTER TABLE Dim_Rooms
ADD CONSTRAINT Roomtypes_Rooms_FK FOREIGN KEY(RoomTypeID)
REFERENCES Dim_RoomTypes(RoomTypeID);

ALTER TABLE Fact_RoomMaintenance 
ADD CONSTRAINT Roommaintenance_Employee_FK FOREIGN KEY(EmployeeID) 
REFERENCES Dim_Employees(EmployeeID);

ALTER TABLE Fact_RoomMaintenance
ADD CONSTRAINT Roommaintenance_Dates_FK FOREIGN KEY(MaintenanceDate)
REFERENCES Dim_Dates(DateID);

ALTER TABLE Fact_RoomMaintenance 
ADD CONSTRAINT Roommaintenance_Rooms_FK FOREIGN KEY(RoomID)
REFERENCES Dim_Rooms(RoomID);

-- =========================================
-- Dim_Guests
-- =========================================

INSERT INTO Dim_Guests
(FullName, Gender, Nationality, Phone, Email)
VALUES
('Ahmed Mohamed', 'M', 'Egyptian', '01011111111', 'ahmed@gmail.com'),
('Sara Ali', 'F', 'Saudi', '01022222222', 'sara@gmail.com'),
('John Smith', 'M', 'American', '01033333333', 'john@gmail.com');

-- =========================================
-- Dim_RoomTypes
-- =========================================

INSERT INTO Dim_RoomTypes 
(RoomTypeName, Capacity, Description)
VALUES
('Single', 1, 'Single Bed Room'),
('Double', 2, 'Double Bed Room'),
('Suite', 4, 'Luxury Suite');

-- =========================================
-- Dim_Rooms
-- =========================================

INSERT INTO Dim_Rooms
(RoomNumber, RoomTypeID, PricePerNight, RoomStatus)
VALUES
('101', 1, 500, 'Available'),
('102', 2, 850, 'Occupied'),
('201', 3, 2000, 'Available');

-- =========================================
-- Dim_Branches
-- =========================================

INSERT INTO Dim_Branches
(BranchName, City, Country)
VALUES
('Cairo Branch', 'Cairo', 'Egypt'),
('Dubai Branch', 'Dubai', 'UAE');

-- =========================================
-- Dim_BookingChannels
-- =========================================

INSERT INTO Dim_BookingChannels
(ChannelName)
VALUES
('Booking.com'),
('Expedia'),
('Hotel Website');

-- =========================================
-- Dim_PaymentMethods
-- =========================================

INSERT INTO Dim_PaymentMethods
(PaymentMethodName)
VALUES
('Cash'),
('Visa'),
('MasterCard');

-- =========================================
-- Dim_Services
-- =========================================

INSERT INTO Dim_Services
(ServiceName, ServiceCost)
VALUES
('Laundry', 100),
('Spa', 300),
('Room Service', 150);

-- =========================================
-- Dim_Dates
-- =========================================

INSERT INTO Dim_Dates
(FullDate, Day, Month, Year, WeekDay)
VALUES
('2026-05-01', 1, 5, 2026, 'Friday'),
('2026-05-02', 2, 5, 2026, 'Saturday'),
('2026-05-03', 3, 5, 2026, 'Sunday');

-- =========================================
-- Dim_Employees
-- =========================================

INSERT INTO Dim_Employees
(EmployeeName, Position, Department, Phone)
VALUES
('Mohamed Hassan', 'Receptionist', 'Front Office', '01055555555'),
('Sara Ahmed', 'Manager', 'Management', '01066666666'),
('Ali Mahmoud', 'Technician', 'Maintenance', '01077777777');

-- =========================================
-- Fact_Bookings
-- =========================================

INSERT INTO Fact_Bookings
(
GuestID,
RoomID,
EmployeeID,
BranchID,
ChannelID,
CheckInDate,
CheckOutDate,
NumberOfGuests,
TotalAmount,
BookingStatus
)
VALUES
(1, 1, 1, 1, 1, 1, 2, 1, 1000, 'Confirmed'),
(2, 2, 1, 1, 2, 2, 3, 2, 1700, 'Completed');

-- =========================================
-- Fact_Payments
-- =========================================

INSERT INTO Fact_Payments
(BookingID, PaymentMethodID, AmountPaid, PaymentDate)
VALUES
(1, 2, 1000, 1),
(2, 1, 1700, 2);

-- =========================================
-- Fact_Reviews
-- =========================================

INSERT INTO Fact_Reviews
(GuestID, BookingID, Rating, ReviewComment, ReviewDateID)
VALUES
(1, 1, 5, 'Excellent service', 2),
(2, 2, 4, 'Very clean rooms', 3);

-- =========================================
-- Fact_RoomMaintenance
-- =========================================

INSERT INTO Fact_RoomMaintenance
(RoomID, EmployeeID, MaintenanceDate, MaintenanceType, MaintenanceCost)
VALUES
(1, 3, 1, 'Air Conditioner Repair', 500),
(2, 3, 2, 'Bathroom Maintenance', 300);

-- =========================================
-- Fact_HotelServices
-- =========================================

INSERT INTO Fact_HotelServices
(BookingID, ServiceID, Quantity, TotalServiceCost)
VALUES
(1, 1, 2, 200),
(1, 3, 1, 150),
(2, 2, 1, 300);