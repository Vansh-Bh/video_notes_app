import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:video_notes_app/models/note.dart';

class CustomSeekBar extends StatefulWidget {
  final Player player;
  final RxList<Note> notes;

  CustomSeekBar({required this.player, required this.notes});

  @override
  _CustomSeekBarState createState() => _CustomSeekBarState();
}

class _CustomSeekBarState extends State<CustomSeekBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Duration _lastPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller with a short duration for smoothness.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Updates the seek position smoothly when a new position is set.
  void _updateSeekPosition(Duration newPosition) {
    final duration = widget.player.state.duration;
    if (duration.inMilliseconds == 0) return;

    final lastValue = _lastPosition.inMilliseconds / duration.inMilliseconds;
    final newValue = newPosition.inMilliseconds / duration.inMilliseconds;

    // Update animation with new start and end points.
    _animation =
        Tween<double>(begin: lastValue, end: newValue).animate(_controller);
    _controller.forward(from: 0);

    _lastPosition = newPosition;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: widget.player.stream.position,
      builder: (context, snapshot) {
        final position = snapshot.data ?? Duration.zero;
        final duration = widget.player.state.duration;

        if (position != _lastPosition) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _updateSeekPosition(position);
          });
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final seekBarWidth = constraints.maxWidth;

            return SizedBox(
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
                          const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 16.0),
                    ),
                    child: Slider(
                      value: (_animation.value * duration.inSeconds.toDouble())
                          .clamp(0, duration.inSeconds.toDouble()),
                      max: duration.inSeconds.toDouble(),
                      onChanged: (value) {
                        widget.player.seek(Duration(seconds: value.toInt()));
                      },
                    ),
                  ),
                  // Display notes on the seek bar as red markers.
                  Obx(() {
                    return Stack(
                      children: widget.notes.map((note) {
                        final notePosition =
                            (note.timestamp.inSeconds / duration.inSeconds) *
                                seekBarWidth;

                        return Positioned(
                          left: notePosition - 4,
                          top: 15,
                          child: Tooltip(
                            message: note.title, // Tooltip with note title.
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
