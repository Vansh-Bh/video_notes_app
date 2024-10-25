class Note {
  final String? id;
  final String videoId;
  final Duration timestamp;
  final String content;
  final String title;

  Note({
    this.id,
    required this.videoId,
    required this.timestamp,
    required this.content,
    required this.title,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['_id'],
      videoId: json['videoId'],
      timestamp: Duration(milliseconds: json['timestamp']),
      content: json['content'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      'timestamp': timestamp.inMilliseconds,
      'content': content,
      'title': title,
    };
  }
}