import 'package:flutter/material.dart';
import '../models/video_data.dart';
import 'video_thumbnail.dart';

class VideoGrid extends StatefulWidget {
  final List<VideoData> videos;
  final Function(VideoData) onVideoTap;

  VideoGrid({required this.videos, required this.onVideoTap});

  @override
  _VideoGridState createState() => _VideoGridState();
}

class _VideoGridState extends State<VideoGrid> {
  late List<VideoData> _videos;

  @override
  void initState() {
    super.initState();
    _videos = widget.videos;
  }

  // Method to delete the video
  void _removeVideo(String videoId) {
    setState(() {
      _videos.removeWhere((video) => video.id == videoId);
    });
  }

  // Method to rename the video
  void _renameVideo(VideoData updatedVideo) {
    setState(() {
      int index = _videos.indexWhere((video) => video.id == updatedVideo.id);
      if (index != -1) {
        _videos[index] = updatedVideo;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const double cardWidth = 300;
          const double spacing = 16;
          int crossAxisCount =
              (constraints.maxWidth / (cardWidth + spacing)).floor();
          crossAxisCount = crossAxisCount < 1 ? 1 : crossAxisCount;

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 4 / 3,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
            ),
            itemCount: _videos.length,
            itemBuilder: (context, index) {
              return VideoThumbnail(
                video: _videos[index],
                onDelete: () => _removeVideo(_videos[index].id),
                onTap: () => widget.onVideoTap(_videos[index]),
                onRename: () => _renameVideo(_videos[index]),
              );
            },
          );
        },
      ),
    );
  }
}
