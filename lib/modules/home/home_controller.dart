import 'package:get/get.dart';
import 'package:video_notes_app/api_service.dart';
import 'package:video_notes_app/models/video_data.dart';
import 'package:video_notes_app/modules/add_video.dart';
import 'package:video_notes_app/routes/app_pages.dart';

class HomeController extends GetxController {
  final RxList<VideoData> videos = <VideoData>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVideos(); // Fetch videos when the controller is initialized
  }

  // Method to fetch videos from the API
  Future<void> fetchVideos() async {
    try {
      isLoading.value = true;
      final fetchedVideos = await specific.fetchVideos();
      videos.assignAll(fetchedVideos);
    } catch (e) {
      print('Error fetching videos: $e');
      Get.snackbar('Error', 'Failed to fetch videos');
    } finally {
      isLoading.value = false;
    }
  }

  // Method to navigate to add video screen and refresh videos list if a new video is added
  void addVideo() async {
    final result = await Get.to(() => const AddVideoView());
    if (result == true) {
      fetchVideos();
    }
  }

  // Method to navigate to the video player screen with the selected video data
  void navigateToVideoPlayer(VideoData video) {
    Get.toNamed(
      Routes.VIDEO_PLAYER,
      arguments: video,
      preventDuplicates: false,
    )?.then((_) => fetchVideos()); // Refresh videos list when returning from the player
  }
}
