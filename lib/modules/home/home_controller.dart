import 'package:get/get.dart';
import 'package:video_notes_app/api_service.dart';
import 'package:video_notes_app/models/video_data.dart';
import 'package:video_notes_app/modules/add_video.dart';

class HomeController extends GetxController {
  final RxList<VideoData> videos = <VideoData>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVideos();
  }

  void fetchVideos() async {
    try {
      isLoading.value = true;
      final fetchedVideos = await ApiService.fetchVideos();
      videos.assignAll(fetchedVideos);
    } catch (e) {
      print('Error fetching videos: $e');
      Get.snackbar('Error', 'Failed to fetch videos');
    } finally {
      isLoading.value = false;
    }
  }

  void addVideo() async {
    final result = await Get.to(() => AddVideoView());
    if (result == true) {
      fetchVideos();
    }
  }
}