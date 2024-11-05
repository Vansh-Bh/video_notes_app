import 'package:get/get.dart';
import 'package:video_notes_app/modules/video_player/video_player_controller.dart';

// Binding class to manage VideoPlayerController dependency injection
class VideoPlayerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VideoPlayerController>(
      () => VideoPlayerController(),
    );
  }
}
