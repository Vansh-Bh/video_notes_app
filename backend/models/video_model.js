const mongoose = require('mongoose');

const VideoSchema = new mongoose.Schema({
  title: { type: String, required: true },
  path: { type: String, required: true },
  isLocal: { type: Boolean, required: true },
  thumbnailUrl: { type: String, required: true },
  lastWatched: { type: Date, default: Date.now },
  noteCount: { type: Number, default: 0 },
});

module.exports = mongoose.model('Video', VideoSchema);