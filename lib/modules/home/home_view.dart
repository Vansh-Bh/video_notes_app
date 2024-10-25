import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_notes_app/modules/home/home_controller.dart';
import '../../../widgets/video_grid.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Videos'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: controller.addVideo,
          ),
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