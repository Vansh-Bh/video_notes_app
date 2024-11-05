import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_notes_app/modules/home/home_controller.dart';
import 'package:video_notes_app/theme_changer.dart';
import '../../../widgets/video_grid.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<
        ThemeService>(); // Retrieves ThemeService instance for theme switching
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Videos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Video',
            onPressed: controller.addVideo,
          ),
          Obx(() => IconButton(
                icon: Icon(themeService.isDarkMode.value
                    ? Icons.light_mode
                    : Icons.dark_mode),
                tooltip: themeService.isDarkMode.value
                    ? 'Switch to Light Mode'
                    : 'Switch to Dark Mode',
                onPressed: themeService.switchTheme,
              )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.videos.isEmpty) {
          return const Center(child: Text('No videos found'));
        } else {
          return VideoGrid(
            videos: controller.videos,
            onVideoTap: controller.navigateToVideoPlayer,
          );
        }
      }),
    );
  }
}
