import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:video_notes_app/models/note.dart';
import 'package:video_notes_app/models/video_data.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';

  static Future<List<VideoData>> fetchVideos() async {
    final response = await http.get(Uri.parse('$baseUrl/videos'));
    if (response.statusCode == 200) {
      List<dynamic> videosJson = json.decode(response.body);
      return videosJson.map((json) => VideoData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load videos');
    }
  }

  static Future<List<Note>> fetchNotes(String videoId) async {
    final response = await http.get(Uri.parse('$baseUrl/notes/$videoId'));
    if (response.statusCode == 200) {
      List<dynamic> notesJson = json.decode(response.body);
      return notesJson.map((json) => Note.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load notes');
    }
  }

  static Future<void> addNote(Note note) async {
    final response = await http.post(
      Uri.parse('$baseUrl/notes'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(note.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add note');
    }
  }

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

  static Future<void> addVideo(VideoData video) async {
    final response = await http.post(
      Uri.parse('$baseUrl/videos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(video.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add video');
    }
  }
}