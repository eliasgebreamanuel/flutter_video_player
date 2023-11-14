class Video {
  final String videoTitle;
  final String? videoThumbnail;
  final String videoUrl;
  final String? videoDescription;

  Video({
    required this.videoTitle,
    this.videoThumbnail,
    required this.videoUrl,
    this.videoDescription,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      videoTitle: json['videoTitle'] as String,
      videoThumbnail: json['videoThumbnail'] as String?,
      videoUrl: json['videoUrl'] as String,
      videoDescription: json['videoDescription'] as String?,
    );
  }
}