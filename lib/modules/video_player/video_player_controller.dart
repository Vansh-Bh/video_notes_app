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

  // Method to initialize the media player and fetch note
  void _initializePlayer() async {
    player = Player();
    videoController = VideoController(player);

    try {
      await player.open(Media(video.value.path));
      await fetchNotes();
      await fetchNoteCount();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load video: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Method to fetch notes associated with the video
  Future<void> fetchNotes() async {
    try {
      final fetchedNotes = await specific.fetchNotes(video.value.id);
      notes.assignAll(fetchedNotes);
      await fetchNoteCount();
    } catch (e) {
      print('Error fetching notes: $e');
      Get.snackbar('Error', 'Failed to fetch notes: $e');
    }
  }

  // Method to add a new note
  Future<void> addNote(String title, String content) async {
    final currentPosition = player.state.position;
    final newNote = Note(
      videoId: video.value.id,
      timestamp: currentPosition,
      title: title,
      content: content,
    );

    try {
      final createdNote = await specific.addNote(newNote);
      notes.add(createdNote);
      await fetchNoteCount();
      await specific.updateVideo(video.value);
    } catch (e) {
      print('Error adding note: $e');
      Get.snackbar('Error', 'Failed to add note');
    }
  }

  // Method to update an existing note
  Future<void> updateNote(String id, String newTitle, String newContent) async {
    try {
      await specific.updateNote(id, newTitle, newContent);
      final index = notes.indexWhere((note) => note.id == id);
      if (index != -1) {
        notes[index] = Note(
          id: id,
          videoId: notes[index].videoId,
          timestamp: notes[index].timestamp,
          title: newTitle,
          content: newContent,
        );
      }
    } catch (e) {
      print('Error updating note: $e');
      Get.snackbar('Error', 'Failed to update note');
    }
  }

  // Method to delete a note
  Future<void> deleteNote(String? noteId) async {
    if (noteId == null) {
      Get.snackbar('Error', 'Cannot delete note: Invalid note ID');
      return;
    }

    try {
      await specific.deleteNote(noteId);
      notes.removeWhere((note) => note.id == noteId);
      await fetchNoteCount();
      await specific.updateVideo(video.value);
    } catch (e) {
      print('Error deleting note: $e');
      Get.snackbar('Error', 'Failed to delete note');
    }
  }

  // Navigate to the next note based on the current position
  void goToNextNote() {
    if (notes.isEmpty) {
      Get.snackbar('No Notes', 'No notes exist to navigate to.');
      return;
    }
    try {
      final currentPosition = player.state.position;
      final nextNote = notes.firstWhere(
        (note) => note.timestamp > currentPosition,
        orElse: () => notes.first,
      );
      player.seek(nextNote.timestamp);
    } catch (e) {
      print('Error deleting note: $e');
      Get.snackbar('Error', 'Failed to navigate to next note');
    }
  }

  // Seek to a specific timestamp
  void seekTo(Duration timestamp) {
    player.seek(timestamp);
  }

  // Navigate to the previous note based on the current position
  void goToPreviousNote() {
    if (notes.isEmpty) {
      Get.snackbar('No Notes', 'No notes exist to navigate to.');
      return;
    }
    try {
      final currentPosition = player.state.position;
      final previousNote = notes.lastWhere(
        (note) => note.timestamp < currentPosition,
        orElse: () => notes.last,
      );
      player.seek(previousNote.timestamp);
    } catch (e) {
      print('Error deleting note: $e');
      Get.snackbar('Error', 'Failed to navigate to previous note');
    }
  }

  // Fetch the count of notes associated with the video
  Future<void> fetchNoteCount() async {
    try {
      final noteCount = await specific.fetchNoteCount(video.value.id);
      video.update((val) {
        val?.noteCount = noteCount;
      });
    } catch (e) {
      print('Error fetching note count: $e');
      Get.snackbar('Error', 'Failed to fetch note count');
    }
  }

  @override
  void onClose() {
    // Update last watched time when the controller is closed
    video.update((val) {
      val?.lastWatched = DateTime.now();
    });
    specific.updateVideo(video.value);
    player.dispose();
    Get.back(result: true);
    super.onClose();
  }
}
