-- Create the Movie_Ticket_Booking_System database
CREATE DATABASE Movie_Ticket_Booking_System;
go
-- Use the Movie_Ticket_Booking_System database
USE Movie_Ticket_Booking_System;
go

-- Create the Movies table
CREATE TABLE Movies (
    movie_id INT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    genre VARCHAR(50),
    rating DECIMAL(3, 1),
    synopsis TEXT,
    duration INT, -- duration in minutes
    cast TEXT
);
go

-- Create the Theaters table
CREATE TABLE Theaters (
    theater_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address TEXT,
    contact_info VARCHAR(255)
);
go

-- Create the Showtimes table
CREATE TABLE Showtimes (
    showtime_id INT PRIMARY KEY,
    movie_id INT,
    theater_id INT,
    show_date DATE,
    show_time TIME,
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id),
    FOREIGN KEY (theater_id) REFERENCES Theaters(theater_id)
);
go

-- Create the Seats table
CREATE TABLE Seats (
    seat_id INT PRIMARY KEY,
    theater_id INT,
    seat_number VARCHAR(10),
    FOREIGN KEY (theater_id) REFERENCES Theaters(theater_id)
);
go

-- Create the Bookings table
CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY,
    user_id INT,
    showtime_id INT,
    booking_date DATE,
    total_price DECIMAL(10, 2),
    FOREIGN KEY (showtime_id) REFERENCES Showtimes(showtime_id)
);
go

-- Create the Booking_Seats table
CREATE TABLE Booking_Seats (
    booking_seat_id INT PRIMARY KEY,
    booking_id INT,
    seat_id INT,
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id),
    FOREIGN KEY (seat_id) REFERENCES Seats(seat_id)
);
go

-- Create the Users table
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255) UNIQUE,
    password_hash VARCHAR(255),
    phone_number VARCHAR(20)
);
go

-- Create the Admins table
CREATE TABLE Admins (
    admin_id INT PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255) UNIQUE,
    password_hash VARCHAR(255)
);
go

-- Create the Reviews table (Optional)
CREATE TABLE Reviews (
    review_id INT PRIMARY KEY,
    user_id INT,
    movie_id INT,
    rating DECIMAL(3, 1),
    review_text TEXT,
    review_date DATE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id)
);
go



INSERT INTO Movies VALUES (1, 'The Conjuring', 'Horror', 7.5, 'Paranormal investigators work on a haunting case.', 112, 'Vera Farmiga, Patrick Wilson');
INSERT INTO Movies VALUES (2, 'Sijjin', 'Horror', 6.8, 'A terrifying story based on dark rituals.', 95, 'Merve Ates, Pinar Caglar Genct�rk');
INSERT INTO Movies VALUES (3, 'Titanic', 'Romance', 9.0, 'A love story set on the ill-fated Titanic.', 195, 'Leonardo DiCaprio, Kate Winslet');
INSERT INTO Movies VALUES (4, 'The Dark Knight', 'Action', 9.0, 'Batman faces the Joker in Gotham City.', 152, 'Christian Bale, Heath Ledger');
INSERT INTO Movies VALUES (5, 'Interstellar', 'Sci-Fi', 8.6, 'Astronauts explore space to save humanity.', 169, 'Matthew McConaughey, Anne Hathaway');
INSERT INTO Movies VALUES (6, 'Joker', 'Drama', 8.4, 'A failed comedian turns into Gotham�s criminal mastermind.', 122, 'Joaquin Phoenix, Robert De Niro');

INSERT INTO Theaters VALUES (1, 'UNIVERSAL CINEMA', '789 Central Blvd', '555-9999');
INSERT INTO Theaters VALUES (2, 'CUE CINEMA', '101 Hollywood St', '555-8888');

INSERT INTO Seats VALUES (1, 1, 'C1');
INSERT INTO Seats VALUES (2, 1, 'C2');
INSERT INTO Seats VALUES (3, 2, 'D1');
INSERT INTO Seats VALUES (4, 2, 'D2');

INSERT INTO Showtimes VALUES (1, 1, 1, '2024-04-10', '18:00');
INSERT INTO Showtimes VALUES (2, 2, 2, '2024-04-10', '20:00');
INSERT INTO Showtimes VALUES (3, 3, 1, '2024-04-11', '15:30');
INSERT INTO Showtimes VALUES (4, 4, 2, '2024-04-11', '21:00');


INSERT INTO Users VALUES (1, 'Alice Brown', 'alice@example.com', 'hash789', '555-3333');
INSERT INTO Users VALUES (2, 'Bob Wilson', 'bob@example.com', 'hash101', '555-4444');


INSERT INTO Bookings VALUES (1, 1, 1, '2024-04-09', 15.00);
INSERT INTO Bookings VALUES (2, 2, 2, '2024-04-09', 18.00);


INSERT INTO Booking_Seats VALUES (1, 1, 1);
INSERT INTO Booking_Seats VALUES (2, 2, 3);


INSERT INTO Admins VALUES (1, 'Super Admin', 'admin@movies.com', 'secureadmin');

INSERT INTO Reviews VALUES (1, 1, 1, 8.0, 'Very scary and thrilling!', '2024-04-12');
INSERT INTO Reviews VALUES (2, 2, 3, 9.5, 'A heartbreaking masterpiece.', '2024-04-12');


-- View all data in each table
SELECT * FROM Movies;
SELECT * FROM Theaters;
SELECT * FROM Seats;
SELECT * FROM Showtimes;
SELECT * FROM Users;
SELECT * FROM Bookings;
SELECT * FROM Booking_Seats;
SELECT * FROM Admins;
SELECT * FROM Reviews;

--1(browse movie)
CREATE PROCEDURE Browse_Movies
AS
BEGIN
    SELECT movie_id, title, genre, rating
    FROM Movies;
END;

--2(movie details)
CREATE PROCEDURE Get_Movie_Details
    @movie_id INT
AS
BEGIN
    SELECT title, genre, rating, synopsis, duration, cast
    FROM Movies
    WHERE movie_id = @movie_id;
END;


--3(showtime selection)
CREATE PROCEDURE Get_Show_times
    @movie_id INT
AS
BEGIN
select Theaters.name as theatre_name,Theaters.address as theatre_address,Showtimes.show_date as showdate,Showtimes.show_time as show_time 
from Theaters
join Showtimes
on Theaters.theater_id=Showtimes.theater_id
 WHERE showtimes.movie_id = @movie_id;
END;

--4(Select showtimes)
CREATE PROCEDURE Select_Show_time
    @showtime_id INT
AS
BEGIN
    SELECT s.showtime_id, m.title AS movie_title, t.name AS theater_name, s.show_date, s.show_time
    FROM Showtimes s
    JOIN Movies m ON s.movie_id = m.movie_id
    JOIN Theaters t ON s.theater_id = t.theater_id
    WHERE s.showtime_id = @showtime_id;
END;

--5(Booking history)
CREATE PROCEDURE Get_Booking_History
    @user_id INT
AS
BEGIN
    SELECT 
        b.booking_id, 
        m.title AS movie_title, 
        t.name AS theater_name, 
        s.show_date, 
        s.show_time, 
        bs.seat_id, 
        b.total_price
    FROM Bookings b
    JOIN Showtimes s ON b.showtime_id = s.showtime_id
    JOIN Movies m ON s.movie_id = m.movie_id
    JOIN Theaters t ON s.theater_id = t.theater_id
    JOIN Booking_Seats bs ON b.booking_id = bs.booking_id
    WHERE b.user_id = @user_id;
END;


--6 (theater location)
SELECT name, address FROM Theaters;

--7( get theater sitting layout)
CREATE PROCEDURE GetTheaterSeatingLayout  
    @TheaterID INT  
AS  
BEGIN  
    SELECT seat_id, seat_number, theater_id  
    FROM Seats  
    WHERE theater_id = @TheaterID;  
END;

EXEC GetTheaterSeatingLayout @TheaterID = 1;


--8 (book a ticket )
CREATE PROCEDURE BookTicket  
    @BookingID INT,  
    @UserID INT,  
    @ShowtimeID INT,  
    @TotalPrice DECIMAL(10,2)  
AS  
BEGIN  
    -- Check if the Showtime ID exists
    IF NOT EXISTS (SELECT 1 FROM Showtimes WHERE showtime_id = @ShowtimeID)  
    BEGIN  
        PRINT 'Error: The provided showtime_id does not exist.'  
        RETURN;  
    END  

    -- Check if the User ID exists
    IF NOT EXISTS (SELECT 1 FROM Users WHERE user_id = @UserID)  
    BEGIN  
        PRINT 'Error: The provided user_id does not exist.'  
        RETURN;  
    END  

    -- Insert the booking
    INSERT INTO Bookings (booking_id, user_id, showtime_id, booking_date, total_price)  
    VALUES (@BookingID, @UserID, @ShowtimeID, GETDATE(), @TotalPrice);  
END;

EXEC BookTicket @BookingID = 5, @UserID = 2, @ShowtimeID = 2, @TotalPrice = 500.00;

--9 (seat selection)
CREATE PROCEDURE GetAvailableSeats  
    @ShowtimeID INT  
AS  
BEGIN  
    SELECT s.seat_id, s.seat_number  
    FROM Seats s  
    LEFT JOIN Booking_Seats bs ON s.seat_id = bs.seat_id  
    WHERE s.theater_id = (SELECT theater_id FROM Showtimes WHERE showtime_id = @ShowtimeID)  
    AND bs.seat_id IS NULL;  -- Only available seats
END;

EXEC GetAvailableSeats @ShowtimeID = 2;

--10 (ticket quantity)--available seats count 
CREATE PROCEDURE GetAvailableSeatsCount  
    @ShowtimeID INT  
AS  
BEGIN  
    SELECT COUNT(*) AS available_seats  
    FROM Seats s  
    LEFT JOIN Booking_Seats bs ON s.seat_id = bs.seat_id  
    WHERE s.theater_id = (SELECT theater_id FROM Showtimes WHERE showtime_id = @ShowtimeID)  
    AND bs.seat_id IS NULL;  
END;

EXEC GetAvailableSeatsCount @ShowtimeID = 1;

--11 (booking confirmation)
CREATE PROCEDURE GetBookingConfirmation  
    @BookingID INT  
AS  
BEGIN  
    SELECT b.booking_id, u.name AS customer_name, t.name AS theater_name,  
           m.title AS movie_title, s.show_date, s.show_time, b.total_price  
    FROM Bookings b  
    JOIN Users u ON b.user_id = u.user_id  
    JOIN Showtimes s ON b.showtime_id = s.showtime_id  
    JOIN Movies m ON s.movie_id = m.movie_id  
    JOIN Theaters t ON s.theater_id = t.theater_id  
    WHERE b.booking_id = @BookingID;  
END;

EXEC GetBookingConfirmation @BookingID = 2;







