const express = require('express');
const router = express.Router();
const Note = require('../models/note_model');
const Video = require('../models/video_model');

router.get('/:videoId', async (req, res) => {
    try {
        const notes = await Note.find({ videoId: req.params.videoId });
        res.json(notes);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

router.post('/', async (req, res) => {
    const note = new Note({
        videoId: req.body.videoId,
        timestamp: req.body.timestamp,
        content: req.body.content,
        title: req.body.title,
    });

    try {
        const newNote = await note.save();
        await Video.findByIdAndUpdate(req.body.videoId, { $inc: { noteCount: 1 } });
        res.status(201).json(newNote);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
});

module.exports = router;