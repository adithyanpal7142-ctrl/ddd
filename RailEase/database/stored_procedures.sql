-- Stored Procedures for RailEase

DELIMITER //

-- Procedure to book tickets
CREATE PROCEDURE BookTickets(
    IN p_user_id VARCHAR(50),
    IN p_train_number VARCHAR(10),
    IN p_from_station VARCHAR(50),
    IN p_to_station VARCHAR(50),
    IN p_journey_date DATE,
    IN p_passenger_count INT,
    IN p_total_amount DECIMAL(10,2),
    IN p_train_class VARCHAR(20)
)
BEGIN
    DECLARE v_available_seats INT;
    DECLARE v_pnr VARCHAR(10);
    DECLARE v_booking_id VARCHAR(20);
    
    -- Check seat availability
    SELECT available_seats INTO v_available_seats 
    FROM train_classes 
    WHERE train_number = p_train_number AND class_name = p_train_class;
    
    IF v_available_seats >= p_passenger_count THEN
        -- Generate PNR and booking ID
        SET v_pnr = UPPER(SUBSTRING(MD5(RAND()), 1, 10));
        SET v_booking_id = CONCAT('BOOK_', UNIX_TIMESTAMP());
        
        -- Create booking
        INSERT INTO bookings (id, pnr_number, user_id, train_number, from_station, to_station, journey_date, total_passengers, total_amount, booking_status)
        VALUES (v_booking_id, v_pnr, p_user_id, p_train_number, p_from_station, p_to_station, p_journey_date, p_passenger_count, p_total_amount, 'confirmed');
        
        -- Update available seats
        UPDATE train_classes 
        SET available_seats = available_seats - p_passenger_count
        WHERE train_number = p_train_number AND class_name = p_train_class;
        
        SELECT v_pnr as pnr_number, v_booking_id as booking_id, 'success' as status;
    ELSE
        -- Add to waiting list
        SET v_pnr = UPPER(SUBSTRING(MD5(RAND()), 1, 10));
        SET v_booking_id = CONCAT('BOOK_', UNIX_TIMESTAMP());
        
        INSERT INTO bookings (id, pnr_number, user_id, train_number, from_station, to_station, journey_date, total_passengers, total_amount, booking_status)
        VALUES (v_booking_id, v_pnr, p_user_id, p_train_number, p_from_station, p_to_station, p_journey_date, p_passenger_count, p_total_amount, 'waiting');
        
        SELECT v_pnr as pnr_number, v_booking_id as booking_id, 'waiting' as status;
    END IF;
END //

-- Procedure to check PNR status
CREATE PROCEDURE CheckPNRStatus(IN p_pnr_number VARCHAR(10))
BEGIN
    SELECT 
        b.pnr_number,
        b.booking_status,
        t.train_number,
        t.train_name,
        t.from_station,
        t.to_station,
        t.departure_time,
        t.arrival_time,
        b.journey_date,
        b.total_passengers,
        b.total_amount,
        GROUP_CONCAT(CONCAT(p.name, ' (', p.age, ', ', p.gender, ') - ', COALESCE(p.seat_number, 'Not assigned'), ' - ', p.status) SEPARATOR '; ') as passenger_details
    FROM bookings b
    JOIN trains t ON b.train_number = t.train_number
    LEFT JOIN passengers p ON b.id = p.booking_id
    WHERE b.pnr_number = p_pnr_number
    GROUP BY b.id;
END //

-- Procedure to get seat availability
CREATE PROCEDURE GetSeatAvailability(
    IN p_train_number VARCHAR(10),
    IN p_from_station VARCHAR(50),
    IN p_to_station VARCHAR(50),
    IN p_journey_date DATE,
    IN p_train_class VARCHAR(20)
)
BEGIN
    DECLARE v_available_seats INT;
    DECLARE v_total_seats INT;
    DECLARE v_waiting_count INT;
    
    SELECT available_seats, total_seats INTO v_available_seats, v_total_seats
    FROM train_classes 
    WHERE train_number = p_train_number AND class_name = p_train_class;
    
    SELECT COUNT(*) INTO v_waiting_count
    FROM bookings 
    WHERE train_number = p_train_number 
    AND journey_date = p_journey_date
    AND booking_status = 'waiting';
    
    SELECT 
        v_available_seats as available_seats,
        v_total_seats as total_seats,
        v_waiting_count as waiting_list,
        CASE 
            WHEN v_available_seats > 0 THEN 'Available'
            WHEN v_waiting_count < 10 THEN 'WL' 
            ELSE 'Not Available'
        END as status;
END //

-- Procedure to cancel booking
CREATE PROCEDURE CancelBooking(IN p_pnr_number VARCHAR(10))
BEGIN
    DECLARE v_booking_id VARCHAR(20);
    DECLARE v_train_number VARCHAR(10);
    DECLARE v_passenger_count INT;
    DECLARE v_booking_status VARCHAR(20);
    
    SELECT id, train_number, total_passengers, booking_status 
    INTO v_booking_id, v_train_number, v_passenger_count, v_booking_status
    FROM bookings 
    WHERE pnr_number = p_pnr_number;
    
    IF v_booking_status = 'confirmed' THEN
        -- Update booking status
        UPDATE bookings 
        SET booking_status = 'cancelled' 
        WHERE pnr_number = p_pnr_number;
        
        -- Free up seats
        UPDATE train_classes 
        SET available_seats = available_seats + v_passenger_count
        WHERE train_number = v_train_number;
        
        SELECT 'Cancellation successful' as message;
    ELSE
        SELECT 'Booking already cancelled or in waiting list' as message;
    END IF;
END //

-- Procedure to get user booking history
CREATE PROCEDURE GetUserBookings(IN p_user_id VARCHAR(50))
BEGIN
    SELECT 
        b.pnr_number,
        b.booking_status,
        t.train_number,
        t.train_name,
        t.from_station,
        t.to_station,
        b.journey_date,
        t.departure_time,
        t.arrival_time,
        b.total_passengers,
        b.total_amount,
        b.booking_date
    FROM bookings b
    JOIN trains t ON b.train_number = t.train_number
    WHERE b.user_id = p_user_id
    ORDER BY b.booking_date DESC;
END //

-- Procedure to search trains between stations
CREATE PROCEDURE SearchTrains(
    IN p_from_station VARCHAR(50),
    IN p_to_station VARCHAR(50),
    IN p_journey_date DATE
)
BEGIN
    SELECT 
        t.train_number,
        t.train_name,
        t.from_station,
        t.to_station,
        t.departure_time,
        t.arrival_time,
        TIMEDIFF(t.arrival_time, t.departure_time) as duration,
        tc.class_name,
        tc.available_seats,
        tc.price
    FROM trains t
    JOIN train_classes tc ON t.train_number = tc.train_number
    WHERE t.from_station = p_from_station 
    AND t.to_station = p_to_station
    AND t.is_active = TRUE
    ORDER BY t.departure_time;
END //

DELIMITER ;