const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
require('dotenv').config();
const path = require('path');

const app = express();

app.use(cors());
app.use(express.json());

// Connect to MongoDB using environment variable for URI
mongoose.connect(process.env.MONGODB_URI);

const db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function () {
  console.log('Connected to MongoDB');
});

// Serve static files from the "thumbnails" directory
app.use('/thumbnails', express.static(path.join(__dirname, 'thumbnails')));

// Define routes for videos and notes
const videosRouter = require('./routes/video');
const notesRouter = require('./routes/notes');
app.use('/api/videos', videosRouter);
app.use('/api/notes', notesRouter);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});