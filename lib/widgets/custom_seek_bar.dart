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
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.blue
                              : Theme.of(context).primaryColor,
                      inactiveTrackColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.blue.withOpacity(0.3)
                              : Colors.grey[300],
                      thumbColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.blue
                              : Theme.of(context).primaryColor,
                      overlayColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.blue.withAlpha(32)
                              : Theme.of(context).primaryColor.withAlpha(32),
                      trackHeight: 4.0,
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 8.0),
                      overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 16.0),
                    ),
                    child: Slider(
                      value: position.inSeconds.toDouble(),
                      max: duration.inSeconds.toDouble(),
                      onChanged: (value) {
                        player.seek(Duration(seconds: value.toInt()));
                      },
                    ),
                  ),
                  Obx(() {
                    return Stack(
                      children: notes.map((note) {
                        final notePosition =
                            (note.timestamp.inSeconds / duration.inSeconds) *
                                seekBarWidth;

                        return Positioned(
                          left: notePosition - 4,
                          top: 15,
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
