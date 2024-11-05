import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:video_notes_app/models/note.dart';
import 'package:video_notes_app/models/video_data.dart';

// A service class for handling api requests related to videos and notes
class specific {
  static const String baseUrl = 'http://localhost:3000/api';

  // Fetches a list of all videos from the server
  static Future<List<VideoData>> fetchVideos() async {
    final response = await http.get(Uri.parse('$baseUrl/videos'));
    if (response.statusCode == 200) {
      List<dynamic> videosJson = json.decode(response.body);
      return videosJson.map((json) => VideoData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load videos');
    }
  }

  // Fetches notes associated with a specific video by its videoId
  static Future<List<Note>> fetchNotes(String videoId) async {
    final response = await http.get(Uri.parse('$baseUrl/notes/$videoId'));
    if (response.statusCode == 200) {
      List<dynamic> notesJson = json.decode(response.body);
      return notesJson.map((json) => Note.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load notes');
    }
  }

  // Fetches all notes across all videos
  static Future<List<Note>> fetchAllNotes() async {
    final response = await http.get(Uri.parse('$baseUrl/notes'));
    if (response.statusCode == 200) {
      List<dynamic> notesJson = json.decode(response.body);
      return notesJson.map((json) => Note.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load notes');
    }
  }

  // Adds a new note
  static Future<Note> addNote(Note note) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/notes'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(note.toJson()),
      );

      if (response.statusCode == 201) {
        return Note.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to add note: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to add note: $e');
    }
  }

  // Deletes a specific note 
  static Future<void> deleteNote(String notesId) async {
    final response = await http.delete(Uri.parse('$baseUrl/notes/$notesId'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete note');
    }
  }

  // Fetch note count using specific videoId
  static Future<int> fetchNoteCount(String videoId) async {
    final response = await http.get(Uri.parse('$baseUrl/notes/count/$videoId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['count'] as int;
    } else {
      throw Exception('Failed to fetch note count');
    }
  }

  // Update a specific note using its id
  static Future<void> updateNote(
      String id, String title, String content) async {
    final response = await http.put(
      Uri.parse('$baseUrl/notes/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'content': content,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update note');
    }
  }

  // Update a specific note using videoId
  static Future<void> updateVideo(VideoData video) async {
    final response = await http.put(
      Uri.parse('$baseUrl/videos/${video.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(video.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update video');
    }
  }

  // Adds a new video
  static Future<void> addVideo(VideoData video) async {
    final response = await http.post(
      Uri.parse('$baseUrl/videos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(video.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception(
          'Failed to add video: ${jsonDecode(response.body)['message']}');
    }
  }

  // Deletes a specific video by its VideoId
  static Future<void> deleteVideo(String videoId) async {
    final response = await http.delete(Uri.parse('$baseUrl/videos/$videoId'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete video');
    }
  }
}
