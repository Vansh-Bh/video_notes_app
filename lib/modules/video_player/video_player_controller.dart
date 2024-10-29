import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:video_notes_app/api_service.dart';
import 'package:video_notes_app/models/note.dart';

import 'package:video_notes_app/models/video_data.dart';

class VideoPlayerController extends GetxController {
  final Rx<VideoData> video = VideoData(
    id: '',
    title: '',
    path: '',
    isLocal: false,
    thumbnailUrl: '',
    lastWatched: DateTime.now(),
    noteCount: 0,
  ).obs;
  final RxBool isLoading = true.obs;
  late final Player player;
  late final VideoController videoController;
  final RxList<Note> notes = <Note>[].obs;

  @override
  void onInit() {
    super.onInit();
    video.value = Get.arguments as VideoData;
    _initializePlayer();
  }

  void _initializePlayer() async {
    player = Player();
    videoController = VideoController(player);

    try {
      if (video.value.isLocal) {
        await player.open(Media(video.value.path));
      } else {
        await player.open(Media(video.value.path));
      }
      await fetchNotes();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load video: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchNotes() async {
    try {
      final fetchedNotes = await ApiService.fetchNotes(video.value.id);
      notes.assignAll(fetchedNotes);
    } catch (e) {
      print('Error fetching notes: $e');
      Get.snackbar('Error', 'Failed to fetch notes: $e');
    }
  }

  void addNote(String title,String content) async {
    final currentPosition = player.state.position;
    final note = Note(
      videoId: video.value.id,
      timestamp: currentPosition,
      content: content,
      title: title,
    );
    try {
      await ApiService.addNote(note);
      notes.add(note);
      video.update((val) {
        val?.noteCount++;
      });
      await ApiService.updateVideo(video.value);
    } catch (e) {
      print('Error adding note: $e');
      Get.snackbar('Error', 'Failed to add note: $e');
    }
  }

  void goToNextNote() {
    final currentPosition = player.state.position;
    final nextNote = notes.firstWhere(
      (note) => note.timestamp > currentPosition,
      orElse: () => notes.first,
    );
    player.seek(nextNote.timestamp);
  }

  void seekTo(Duration timestamp) {
    player.seek(timestamp);
  }

  void goToPreviousNote() {
    final currentPosition = player.state.position;
    final previousNote = notes.lastWhere(
      (note) => note.timestamp < currentPosition,
      orElse: () => notes.last,
    );
    player.seek(previousNote.timestamp);
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}
