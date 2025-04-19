const express = require('express');
const combinedController = require('../controllers/combinedController');

const router = express.Router();

// --- Booking Routes ---
router.get('/booking-history/:user_id', combinedController.getBookingHistory);
router.post('/book-ticket', combinedController.bookTicket);

// --- Movie Routes ---
router.get('/test', (req, res) => {
    res.send('Test route is working!');
});
router.get('/browse-movies', combinedController.getAllMovies);
router.get('/movie-details/:movie_id', combinedController.getMovieDetails);

// --- Showtime Routes ---
router.get('/showtimes/:movie_id', combinedController.getShowtimes);
router.get('/showtime/:showtime_id', combinedController.getShowtimeDetails);
router.get('/available-seats/:showtime_id', combinedController.getAvailableSeats);
router.get('/available-seats-count/:showtime_id', combinedController.getAvailableSeatsCount);
router.get('/booking-confirmation/:booking_id', combinedController.getBookingConfirmation);

// --- Theater Routes ---
router.get('/theaters', combinedController.getTheaterLocations);
router.get('/theater-seating-layout/:theater_id', combinedController.getTheaterSeatingLayout);


module.exports = router;
