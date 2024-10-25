import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:video_notes_app/modules/video_player/video_player_controller.dart';
import '../../../widgets/custom_seek_bar.dart';
import '../../../widgets/note_editor.dart';

class VideoPlayerView extends GetView<VideoPlayerController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.video.value.title)),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Video(controller: controller.videoController),
                  ),
                  SizedBox(
                    height: 40,
                    child: CustomSeekBar(
                      player: controller.player,
                      notes: controller.notes,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: controller.goToPreviousNote,
                          child: Text('Previous Note'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: controller.goToNextNote,
                          child: Text('Next Note'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: NoteEditor(
                onNoteAdded: controller.addNote,
              ),
            ),
          ],
        );
      }),
    );
  }
}