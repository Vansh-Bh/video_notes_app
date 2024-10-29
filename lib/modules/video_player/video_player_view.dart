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
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          final Set<int> expandedNotes = {};

                          return StatefulBuilder(
                            builder: (context, setState) => ListView.builder(
                              itemCount: controller.notes.length,
                              itemBuilder: (context, index) {
                                final note = controller.notes[index];
                                final timestamp = note.timestamp;
                                final formattedTime =
                                    "${timestamp.inHours.toString().padLeft(2, '0')}:${(timestamp.inMinutes % 60).toString().padLeft(2, '0')}:${(timestamp.inSeconds % 60).toString().padLeft(2, '0')}";
                                bool isExpanded = expandedNotes.contains(index);

                                return Column(
                                  children: [
                                    ListTile(
                                      title: Text(note.title),
                                      subtitle: Text(formattedTime),
                                      trailing: IconButton(
                                        icon: Icon(
                                          isExpanded
                                              ? Icons.expand_less
                                              : Icons.expand_more,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (isExpanded) {
                                              expandedNotes.remove(index);
                                            } else {
                                              expandedNotes.add(index);
                                            }
                                          });
                                        },
                                      ),
                                      onTap: () {
                                        controller.seekTo(note.timestamp);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    if (isExpanded)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0,
                                          vertical: 8.0,
                                        ),
                                        child: Text(note
                                            .content),
                                      ),
                                    Divider(),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                    child: Text("Show Notes"),
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
