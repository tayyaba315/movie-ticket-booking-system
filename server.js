
process.on('unhandledRejection', (reason, promise) => {
  console.error('Unhandled Rejection at:', promise, 'reason:', reason);
});
const express = require('express');
const app = express();
const combinedRoutes = require('./routes/combinedRoutes'); // Correct path to routes


app.use(express.json()); // Middleware to parse JSON

 app.get('/', (req, res) => {
    res.send("Hello world");
  });
// Combine all routes with the '/api' prefix
app.use('/api', combinedRoutes); 

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(` Server running on port ${PORT}`);
});
