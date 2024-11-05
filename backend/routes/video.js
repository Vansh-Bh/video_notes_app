const express = require('express');
const path = require('path');
const fs = require('fs');
const router = express.Router();
const ffmpeg = require('fluent-ffmpeg');
const Video = require('../models/video_model');

// Get all videos, filtering out missing local files
router.get('/', async (req, res) => {
  try {
    const videos = await Video.find();
    const filteredVideos = videos.filter(video => {
      if (video.isLocal) {
        const fullPath = path.resolve(video.path.replace('file:///', ''));
        return fs.existsSync(fullPath);
      }
      return true;
    });
    res.json(filteredVideos);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Add a new video with optional thumbnail generation
router.post('/', async (req, res) => {
  const { title, path: videoPath, isLocal, thumbnailUrl } = req.body;

  if (isLocal) {
    const fullPath = path.resolve(videoPath.replace('file:///', ''));
    if (!fs.existsSync(fullPath)) {
      return res.status(400).json({ message: 'Local file does not exist' });
    }
  }

  if (thumbnailUrl) {
    try {
      const response = await axios.head(thumbnailUrl);
      if (response.status !== 200) {
        return res.status(400).json({ message: 'Invalid thumbnail URL' });
      }
    } catch (error) {
      return res.status(400).json({ message: 'Invalid thumbnail URL' });
    }
  }

  const video = new Video({
    title,
    path: videoPath,
    isLocal,
    thumbnailUrl: thumbnailUrl || '',
  });

  // Generate a thumbnail if URL not provided
  try {
    if (!thumbnailUrl) {
      const fileName = `${Date.now()}_thumbnail.png`;

      ffmpeg(videoPath.replace('file:///', ''))
        .screenshots({
          count: 1,
          folder: path.join(__dirname, '../thumbnails'),
          filename: fileName,
          size: '320x240',
        })
        .on('end', async () => {
          video.thumbnailUrl = `/thumbnails/${fileName}`;
          const newVideo = await video.save();
          res.status(201).json(newVideo);
        })
        .on('error', (err) => {
          console.error('Failed to generate thumbnail:', err);
          res.status(500).json({ message: 'Failed to generate thumbnail' });
        });
    } else {
      const newVideo = await video.save();
      res.status(201).json(newVideo);
    }
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

// Update a video by ID
router.put('/:id', async (req, res) => {
  try {
    const video = await Video.findByIdAndUpdate(req.params.id, req.body, { new: true });
    res.json(video);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

// Delete a video by ID
router.delete('/:id', async (req, res) => {
  try {
    const video = await Video.findByIdAndDelete(req.params.id);
    if (!video) return res.status(404).json({ message: 'Video not found' });
    res.json({ message: 'Video deleted successfully' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
