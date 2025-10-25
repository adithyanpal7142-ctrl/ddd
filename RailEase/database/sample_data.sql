-- Sample Data for RailEase Database

-- Insert more sample stations
INSERT INTO stations (code, name, city, state) VALUES
('BCT', 'Mumbai Central', 'Mumbai', 'Maharashtra'),
('CSTM', 'Mumbai CST', 'Mumbai', 'Maharashtra'),
('HWH', 'Howrah Junction', 'Kolkata', 'West Bengal'),
('SBC', 'Bengaluru City', 'Bengaluru', 'Karnataka'),
('MMCT', 'Mumbai Central', 'Mumbai', 'Maharashtra'),
('JP', 'Jaipur Junction', 'Jaipur', 'Rajasthan'),
('PNBE', 'Patna Junction', 'Patna', 'Bihar'),
('GKP', 'Gorakhpur Junction', 'Gorakhpur', 'Uttar Pradesh'),
('RNC', 'Ranchi Junction', 'Ranchi', 'Jharkhand'),
('JBP', 'Jabalpur Junction', 'Jabalpur', 'Madhya Pradesh');

-- Insert more sample trains
INSERT INTO trains (train_number, train_name, from_station, to_station, departure_time, arrival_time, total_seats) VALUES
('12951', 'Mumbai Rajdhani', 'NDLS', 'BCT', '16:55:00', '08:45:00', 450),
('12952', 'Mumbai Rajdhani', 'BCT', 'NDLS', '16:25:00', '08:15:00', 450),
('12259', 'YPR Hazrat Nizamuddin', 'YPR', 'NZM', '19:00:00', '05:30:00', 500),
('12260', 'Hazrat Nizamuddin YPR', 'NZM', 'YPR', '20:45:00', '07:15:00', 500),
('12675', 'Kovai Express', 'CBE', 'MAS', '06:15:00', '13:45:00', 400),
('12676', 'Kovai Express', 'MAS', 'CBE', '15:00:00', '22:30:00', 400);

-- Insert train classes for new trains
INSERT INTO train_classes (train_number, class_name, total_seats, available_seats, price) VALUES
('12951', 'First AC', 40, 40, 4800.00),
('12951', 'Second AC', 120, 120, 3400.00),
('12951', 'Third AC', 180, 180, 2400.00),
('12951', 'Sleeper', 110, 110, 1300.00),
('12952', 'First AC', 40, 40, 4800.00),
('12952', 'Second AC', 120, 120, 3400.00),
('12952', 'Third AC', 180, 180, 2400.00),
('12952', 'Sleeper', 110, 110, 1300.00);

-- Insert sample users
INSERT INTO users (id, first_name, last_name, email, phone, password, user_type) VALUES
('USER_001', 'Rahul', 'Sharma', 'rahul.sharma@email.com', '9876543210', 'password123', 'user'),
('USER_002', 'Priya', 'Patel', 'priya.patel@email.com', '9876543211', 'password123', 'user'),
('USER_003', 'Amit', 'Verma', 'amit.verma@email.com', '9876543212', 'password123', 'user'),
('USER_004', 'Sneha', 'Singh', 'sneha.singh@email.com', '9876543213', 'password123', 'user');

-- Insert sample bookings
INSERT INTO bookings (id, pnr_number, user_id, train_number, from_station, to_station, journey_date, total_passengers, total_amount, booking_status, payment_status) VALUES
('BOOK_001', 'PNR1234567', 'USER_001', '12301', 'NDLS', 'MUMBAI', '2024-02-15', 2, 6400.00, 'confirmed', 'completed'),
('BOOK_002', 'PNR1234568', 'USER_002', '12302', 'MUMBAI', 'NDLS', '2024-02-16', 1, 3200.00, 'confirmed', 'completed'),
('BOOK_003', 'PNR1234569', 'USER_003', '12431', 'NDLS', 'LKO', '2024-02-17', 3, 6600.00, 'waiting', 'completed');

-- Insert sample passengers
INSERT INTO passengers (booking_id, name, age, gender, seat_number, status) VALUES
('BOOK_001', 'Rahul Sharma', 28, 'male', 'B3-45', 'confirmed'),
('BOOK_001', 'Neha Sharma', 26, 'female', 'B3-46', 'confirmed'),
('BOOK_002', 'Priya Patel', 32, 'female', 'A2-12', 'confirmed'),
('BOOK_003', 'Amit Verma', 45, 'male', NULL, 'waiting'),
('BOOK_003', 'Rekha Verma', 42, 'female', NULL, 'waiting'),
('BOOK_003', 'Rohan Verma', 15, 'male', NULL, 'waiting');

-- Insert sample payments
INSERT INTO payments (id, booking_id, amount, payment_method, transaction_id, status) VALUES
('PAY_001', 'BOOK_001', 6400.00, 'credit_card', 'TXN001234', 'success'),
('PAY_002', 'BOOK_002', 3200.00, 'debit_card', 'TXN001235', 'success'),
('PAY_003', 'BOOK_003', 6600.00, 'upi', 'TXN001236', 'success');