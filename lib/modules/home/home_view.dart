import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_notes_app/modules/home/home_controller.dart';
import 'package:video_notes_app/theme_changer.dart';
import '../../../widgets/video_grid.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    return Scaffold(
      appBar: AppBar(
        title: Text('My Videos'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
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
          return Center(child: CircularProgressIndicator());
        } else {
          return VideoGrid(videos: controller.videos);
        }
      }),
    );
  }
}
