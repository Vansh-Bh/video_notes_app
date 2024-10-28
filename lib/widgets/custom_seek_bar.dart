import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:video_notes_app/models/note.dart';

class CustomSeekBar extends StatelessWidget {
  final Player player;
  final RxList<Note> notes;

  CustomSeekBar({required this.player, required this.notes});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: player.streams.position,
      builder: (context, snapshot) {
        final position = snapshot.data ?? Duration.zero;
        final duration = player.state.duration;

        return LayoutBuilder(
          builder: (context, constraints) {
            final seekBarWidth =
                constraints.maxWidth; // Get total width of seek bar

            return Container(
              height: 40,
              child: Stack(
                children: [
                  Slider(
                    value: position.inSeconds.toDouble(),
                    max: duration.inSeconds.toDouble(),
                    onChanged: (value) {
                      player.seek(Duration(seconds: value.toInt()));
                    },
                  ),
                  Obx(() {
                    return Stack(
                      children: notes.map((note) {
                        // Calculate the position of each note on the seek bar based on timestamp
                        final notePosition =
                            (note.timestamp.inSeconds / duration.inSeconds) *
                                seekBarWidth;

                        return Positioned(
                          left:
                              notePosition, // Position of the note based on seek bar width
                          child: Tooltip(
                            message: note.title,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
