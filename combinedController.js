// combinedController.js

const { connectToDatabase, sql } = require('../db/sqlConfig');

// --- Booking Controller Functions ---
exports.getBookingHistory = async (req, res) => {
    const { user_id } = req.params;
    try {
        const pool = await connectToDatabase();
        const result = await pool.request()
            .input('user_id', sql.Int, user_id)
            .query('EXEC Get_Booking_History @user_id');
        res.json(result.recordset);
    } catch (err) {
        res.status(500).send('Error fetching booking history');
    }
};

exports.bookTicket = async (req, res) => {
    const { BookingID, UserID, ShowtimeID, TotalPrice } = req.body;
    try {
        const pool = await connectToDatabase();
        await pool.request()
            .input('BookingID', sql.Int, BookingID)
            .input('UserID', sql.Int, UserID)
            .input('ShowtimeID', sql.Int, ShowtimeID)
            .input('TotalPrice', sql.Decimal(10, 2), TotalPrice)
            .query('EXEC BookTicket @BookingID, @UserID, @ShowtimeID, @TotalPrice');
        res.send('Ticket booked successfully');
    } catch (err) {
        res.status(500).send('Error booking ticket');
    }
};

// --- Movie Controller Functions ---
exports.getAllMovies = async (req, res) => {
    try {
        const pool = await connectToDatabase();
        const result = await pool.request().query('EXEC Browse_Movies');
        res.json(result.recordset);
    } catch (err) {
        res.status(500).send('Error fetching movies');
    }
};

exports.getMovieDetails = async (req, res) => {
    const { movie_id } = req.params;
    try {
        const pool = await connectToDatabase();
        const result = await pool.request()
            .input('movie_id', sql.Int, movie_id)
            .query('EXEC Get_Movie_Details @movie_id');
        res.json(result.recordset);
    } catch (err) {
        res.status(500).send('Error fetching movie details');
    }
};

// --- Showtime Controller Functions ---
exports.getShowtimes = async (req, res) => {
    const { movie_id } = req.params;
    try {
        const pool = await connectToDatabase();
        const result = await pool.request()
            .input('movie_id', sql.Int, movie_id)
            .query('EXEC Get_Show_times @movie_id');
        res.json(result.recordset);
    } catch (err) {
        res.status(500).send('Error fetching showtimes');
    }
};

exports.getShowtimeDetails = async (req, res) => {
    const { showtime_id } = req.params;
    try {
        const pool = await connectToDatabase();
        const result = await pool.request()
            .input('showtime_id', sql.Int, showtime_id)
            .query('EXEC Select_Show_time @showtime_id');
        res.json(result.recordset);
    } catch (err) {
        res.status(500).send('Error fetching showtime details');
    }
};

exports.getAvailableSeats = async (req, res) => {
    const { showtime_id } = req.params;
    try {
        const pool = await connectToDatabase();
        const result = await pool.request()
            .input('ShowtimeID', sql.Int, showtime_id)
            .query('EXEC GetAvailableSeats @ShowtimeID');
        res.json(result.recordset);
    } catch (err) {
        res.status(500).send('Error fetching available seats');
    }
};

exports.getAvailableSeatsCount = async (req, res) => {
    const { showtime_id } = req.params;
    try {
        const pool = await connectToDatabase();
        const result = await pool.request()
            .input('ShowtimeID', sql.Int, showtime_id)
            .query('EXEC GetAvailableSeatsCount @ShowtimeID');
        res.json(result.recordset);
    } catch (err) {
        res.status(500).send('Error fetching available seats count');
    }
};

exports.getBookingConfirmation = async (req, res) => {
    const { booking_id } = req.params;
    try {
        const pool = await connectToDatabase();
        const result = await pool.request()
            .input('BookingID', sql.Int, booking_id)
            .query('EXEC GetBookingConfirmation @BookingID');
        res.json(result.recordset);
    } catch (err) {
        res.status(500).send('Error fetching booking confirmation');
    }
};

// --- Theater Controller Functions ---
exports.getTheaterLocations = async (req, res) => {
    try {
        const pool = await connectToDatabase();
        const result = await pool.request().query('SELECT name, address FROM Theaters');
        res.json(result.recordset);
    } catch (err) {
        res.status(500).send('Error fetching theater locations');
    }
};

exports.getTheaterSeatingLayout = async (req, res) => {
    const { theater_id } = req.params;
    try {
        const pool = await connectToDatabase();
        const result = await pool.request()
            .input('TheaterID', sql.Int, theater_id)
            .query('EXEC GetTheaterSeatingLayout @TheaterID');
        res.json(result.recordset);
    } catch (err) {
        res.status(500).send('Error fetching theater seating layout');
    }
};
