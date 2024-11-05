class VideoData {
  final String id;
  String title;
  final String path;
  final bool isLocal;
  final String thumbnailUrl;
  late DateTime lastWatched;
  int noteCount;

  VideoData({
    required this.id,
    required this.title,
    required this.path,
    required this.isLocal,
    required this.thumbnailUrl,
    required this.lastWatched,
    this.noteCount = 0,
  });

  // Factory constructor to create a VideoData instance from JSON
  factory VideoData.fromJson(Map<String, dynamic> json) {
    return VideoData(
      id: json['_id'],
      title: json['title'],
      path: json['path'],
      isLocal: json['isLocal'],
      thumbnailUrl: json['thumbnailUrl'],
      lastWatched: DateTime.parse(json['lastWatched']),
      noteCount: json['noteCount'],
    );
  }

  // Convert a VideoData instance to JSON format
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'path': path,
      'isLocal': isLocal,
      'thumbnailUrl': thumbnailUrl,
      'lastWatched': lastWatched.toIso8601String(),
      'noteCount': noteCount,
    };
  }
}
