const express = require('express');
const router = express.Router();
const Video = require('../models/video_model');

router.get('/', async (req, res) => {
  try {
    const videos = await Video.find();
    res.json(videos);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

router.post('/', async (req, res) => {
  const { title, path: videoPath, isLocal, thumbnailUrl } = req.body;

  if (isLocal) {
    const fullPath = path.resolve(videoPath);
    if (!fs.existsSync(fullPath)) {
      return res.status(400).json({ message: 'Local file does not exist' });
    }
  }

  const video = new Video({
    title,
    path: videoPath,
    isLocal,
    thumbnailUrl,
  });

  try {
    const newVideo = await video.save();
    res.status(201).json(newVideo);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

router.put('/:id', async (req, res) => {
  try {
    const video = await Video.findByIdAndUpdate(req.params.id, req.body, { new: true });
    res.json(video);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

module.exports = router;

