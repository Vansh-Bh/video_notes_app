import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:video_notes_app/api_service.dart';
import '../models/video_data.dart';

class VideoThumbnail extends StatelessWidget {
  final VideoData video;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final VoidCallback onRename;

  const VideoThumbnail({
    super.key,
    required this.video,
    required this.onDelete,
    required this.onTap,
    required this.onRename,
  });

  // Method to delete the video and asks user for conformation 
  Future<void> _deleteVideo(BuildContext context) async {
    bool confirmed = await _showConfirmationDialog(context);
    if (confirmed) {
      try {
        await specific.deleteVideo(video.id);
        Get.snackbar('Success', 'Video deleted successfully.',
            snackPosition: SnackPosition.BOTTOM);
        onDelete();
      } catch (error) {
        Get.snackbar('Error', 'Failed to delete video.',
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  // Opens a dialog to rename the vid
  Future<void> _renameVideo(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    bool confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Rename Video'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'New name'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Rename'),
              ),
            ],
          ),
        ) ??
        false;

    if (confirmed && controller.text.isNotEmpty) {
      try {
        video.title = controller.text;
        await specific.updateVideo(video);
        Get.snackbar('Success', 'Video renamed successfully.',
            snackPosition: SnackPosition.BOTTOM);
        onRename();
      } catch (error) {
        Get.snackbar('Error', 'Failed to rename video.',
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  // Shows a confirmation dialog before deletion
  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Video'),
            content: const Text('Are you sure you want to delete this video?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }

  // Builds the thumbnail image for the video, handling both local and external URLs
  Widget _buildThumbnailImage() {
    const String baseUrl = 'http://localhost:3000';

    if (video.thumbnailUrl.startsWith('http://') ||
        video.thumbnailUrl.startsWith('https://')) {
      return Image.network(
        video.thumbnailUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: const Icon(Icons.error, color: Colors.red),
          );
        },
      );
    } else {
      final String fullUrl = '$baseUrl${video.thumbnailUrl}';
      return Image.network(
        fullUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: const Icon(Icons.error, color: Colors.red),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('dd-MM-yyyy').format(video.lastWatched.toLocal());
    String formattedTime =
        DateFormat('HH:mm:ss').format(video.lastWatched.toLocal());

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: _buildThumbnailImage(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Last watched: $formattedDate at $formattedTime',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Notes: ${video.noteCount}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'Delete') {
                    _deleteVideo(context);
                  } else if (value == 'Rename') {
                    _renameVideo(context);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'Delete',
                    child: Text('Delete'),
                  ),
                  const PopupMenuItem(
                    value: 'Rename',
                    child: Text('Rename'),
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
