const mongoose = require('mongoose');

const NoteSchema = new mongoose.Schema({
  videoId: { type: mongoose.Schema.Types.ObjectId, ref: 'Video', required: true },
  timestamp: { type: Number, required: true },
  content: { type: String, required: true },
  title: { type: String, required: true },
  videoTitle: { type: String, required: true }
});

module.exports = mongoose.model('Note', NoteSchema);