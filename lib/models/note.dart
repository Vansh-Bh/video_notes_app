class Note {
  final String? id;
  final String videoId;
  final String videoTitle;
  final Duration timestamp;
  final String content;
  final String title;
  String? password;

  Note({
    this.id,
    required this.videoId,
    required this.videoTitle,
    required this.timestamp,
    required this.content,
    required this.title,
    this.password,
  });

  // Factory constructor to create a Note instance from JSON
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['_id'],
      videoId: json['videoId'],
      videoTitle: json['videoTitle'],
      timestamp: Duration(milliseconds: json['timestamp']),
      content: json['content'],
      title: json['title'],
      password: json['password'],
    );
  }

  // Convert a Note instance to JSON format
  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      'videoTitle': videoTitle,
      'timestamp': timestamp.inMilliseconds,
      'content': content,
      'title': title,
      'password': password,
    };
  }
}