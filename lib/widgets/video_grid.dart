import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/video_data.dart';
import '../routes/app_pages.dart';

class VideoGrid extends StatelessWidget {
  final List<VideoData> videos;

  VideoGrid({required this.videos});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 16 / 9,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return VideoThumbnail(video: videos[index]);
        },
      ),
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
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  video.thumbnailUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Last watched: ${video.lastWatched.toString().split(' ')[0]}',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Notes: ${video.noteCount}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
