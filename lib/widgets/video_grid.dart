// file: app/widgets/video_grid.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/video_data.dart';
import '../routes/app_pages.dart';

class VideoGrid extends StatelessWidget {
  final List<VideoData> videos;

  VideoGrid({required this.videos});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 16 / 9,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        return VideoThumbnail(video: videos[index]);
      },
    );
  }
}

class VideoThumbnail extends StatelessWidget {
  final VideoData video;

  VideoThumbnail({required this.video});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.VIDEO_PLAYER, arguments: video),
      child: Card(
        child: Column(
          children: [
            Expanded(
              child: Image.network(video.thumbnailUrl, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(video.title, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Last watched: ${video.lastWatched.toString().split(' ')[0]}'),
                  Text('Notes: ${video.noteCount}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



