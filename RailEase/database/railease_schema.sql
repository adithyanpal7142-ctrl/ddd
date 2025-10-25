-- Create Database
CREATE DATABASE railease;
GO

USE railease;
GO

-- Users Table
CREATE TABLE users (
    id INT PRIMARY KEY IDENTITY(1,1),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    password VARCHAR(255) NOT NULL,
    user_type VARCHAR(10) DEFAULT 'user' CHECK (user_type IN ('admin', 'user')),
    is_active BIT DEFAULT 1,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE()
);
GO

-- Trains Table
CREATE TABLE trains (
    train_number VARCHAR(10) PRIMARY KEY,
    train_name VARCHAR(100) NOT NULL,
    from_station VARCHAR(50) NOT NULL,
    to_station VARCHAR(50) NOT NULL,
    departure_time TIME NOT NULL,
    arrival_time TIME NOT NULL,
    total_seats INT NOT NULL,
    is_active BIT DEFAULT 1,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE()
);
GO

-- Train Classes Table
CREATE TABLE train_classes (
    id INT PRIMARY KEY IDENTITY(1,1),
    train_number VARCHAR(10),
    class_name VARCHAR(20) NOT NULL,
    total_seats INT NOT NULL,
    available_seats INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (train_number) REFERENCES trains(train_number) ON DELETE CASCADE
);
GO

-- Bookings Table
CREATE TABLE bookings (
    id VARCHAR(20) PRIMARY KEY,
    pnr_number VARCHAR(10) UNIQUE NOT NULL,
    user_id INT NOT NULL,
    train_number VARCHAR(10) NOT NULL,
    from_station VARCHAR(50) NOT NULL,
    to_station VARCHAR(50) NOT NULL,
    journey_date DATE NOT NULL,
    booking_date DATETIME2 DEFAULT GETDATE(),
    total_passengers INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    booking_status VARCHAR(20) DEFAULT 'confirmed' CHECK (booking_status IN ('confirmed', 'waiting', 'cancelled')),
    payment_status VARCHAR(20) DEFAULT 'pending' CHECK (payment_status IN ('pending', 'completed', 'failed')),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (train_number) REFERENCES trains(train_number)
);
GO

-- Passengers Table
CREATE TABLE passengers (
    id INT PRIMARY KEY IDENTITY(1,1),
    booking_id VARCHAR(20) NOT NULL,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    gender VARCHAR(10) NOT NULL CHECK (gender IN ('male', 'female', 'other')),
    seat_number VARCHAR(10),
    status VARCHAR(20) DEFAULT 'confirmed' CHECK (status IN ('confirmed', 'waiting')),
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE
);
GO

-- Payments Table
CREATE TABLE payments (
    id VARCHAR(50) PRIMARY KEY,
    booking_id VARCHAR(20) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(20) NOT NULL,
    transaction_id VARCHAR(100),
    payment_date DATETIME2 DEFAULT GETDATE(),
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('success', 'failed', 'pending')),
    FOREIGN KEY (booking_id) REFERENCES bookings(id)
);
GO

-- Stations Table
CREATE TABLE stations (
    code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL
);
GO

-- Insert Admin User
INSERT INTO users (first_name, last_name, email, password, user_type) 
VALUES ('System', 'Admin', 'admin@railease.com', 'admin123', 'admin');
GO

-- Insert Sample Stations
INSERT INTO stations (code, name, city, state) VALUES
('NDLS', 'New Delhi', 'Delhi', 'Delhi'),
('MUMBAI', 'Mumbai Central', 'Mumbai', 'Maharashtra'),
('CNB', 'Kanpur Central', 'Kanpur', 'Uttar Pradesh'),
('LKO', 'Lucknow', 'Lucknow', 'Uttar Pradesh'),
('BLR', 'Bengaluru', 'Bengaluru', 'Karnataka'),
('MAS', 'Chennai Central', 'Chennai', 'Tamil Nadu'),
('HYB', 'Hyderabad', 'Hyderabad', 'Telangana'),
('ADI', 'Ahmedabad', 'Ahmedabad', 'Gujarat');
GO

-- Insert Sample Trains
INSERT INTO trains (train_number, train_name, from_station, to_station, departure_time, arrival_time, total_seats) VALUES
('12301', 'Rajdhani Express', 'NDLS', 'MUMBAI', '16:25:00', '08:45:00', 500),
('12302', 'Rajdhani Express', 'MUMBAI', 'NDLS', '16:55:00', '09:15:00', 500),
('12431', 'Duronto Express', 'NDLS', 'LKO', '22:50:00', '07:00:00', 400),
('12432', 'Duronto Express', 'LKO', 'NDLS', '23:30:00', '08:00:00', 400),
('12627', 'Karnataka Express', 'NDLS', 'BLR', '20:45:00', '06:30:00', 450);
GO

-- Insert Train Classes
INSERT INTO train_classes (train_number, class_name, total_seats, available_seats, price) VALUES
('12301', 'First AC', 50, 50, 4500.00),
('12301', 'Second AC', 100, 100, 3200.00),
('12301', 'Third AC', 150, 150, 2200.00),
('12301', 'Sleeper', 200, 200, 1200.00),
('12302', 'First AC', 50, 50, 4500.00),
('12302', 'Second AC', 100, 100, 3200.00),
('12302', 'Third AC', 150, 150, 2200.00),
('12302', 'Sleeper', 200, 200, 1200.00);
GO

-- Create Indexes for better performance
CREATE INDEX idx_bookings_pnr ON bookings(pnr_number);
CREATE INDEX idx_bookings_user ON bookings(user_id);
CREATE INDEX idx_bookings_train ON bookings(train_number);
CREATE INDEX idx_trains_route ON trains(from_station, to_station);
CREATE INDEX idx_users_email ON users(email);
GO