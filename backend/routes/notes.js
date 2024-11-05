const express = require('express');
const router = express.Router();
const Note = require('../models/note_model');
const Video = require('../models/video_model');

// Get all notes
router.get('/', async (req, res) => {
    try {
        const notes = await Note.find();
        res.json(notes);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

// Get notes by video ID
router.get('/:videoId', async (req, res) => {
    try {
        const notes = await Note.find({ videoId: req.params.videoId });
        res.json(notes);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

// Create a new note
router.post('/', async (req, res) => {
    const note = new Note({
        videoId: req.body.videoId,
        videoTitle: req.body.videoTitle,
        timestamp: req.body.timestamp,
        content: req.body.content,
        title: req.body.title,
    });

    try {
        const newNote = await note.save();
        await Video.findByIdAndUpdate(req.body.videoId);
        res.status(201).json(newNote);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
});

// Delete a note by ID
router.delete('/:id', async (req, res) => {
    try {
        const note = await Note.findByIdAndDelete(req.params.id);
        if (!note) return res.status(404).json({ message: 'Note not found' });
        await Video.findByIdAndUpdate(note.videoId);
        res.json({ message: 'Note deleted successfully' });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

// Get the count of notes for a specific video
router.get('/count/:videoId', async (req, res) => {
    try {
        const count = await Note.countDocuments({ videoId: req.params.videoId });
        res.json({ count });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

// Update a note by ID
router.put('/:id', async (req, res) => {
    try {
        const updatedNote = await Note.findByIdAndUpdate(req.params.id, {
            title: req.body.title,
            content: req.body.content,
            timestamp: req.body.timestamp
        }, { new: true });

        if (!updatedNote) return res.status(404).json({ message: 'Note not found' });
        res.json(updatedNote);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
});

module.exports = router;