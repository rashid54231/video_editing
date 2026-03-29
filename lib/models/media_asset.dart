class MediaAsset {
  final int assetId;
  final int? projectId;
  final String userId;
  final String originalFilename;
  final String fileUrl;
  final String fileType; // 'video', 'audio', 'image'
  final double? duration;
  final int? fileSize;
  final int? width;
  final int? height;
  final String? thumbnailUrl;
  final DateTime importedAt;

  MediaAsset({
    required this.assetId,
    this.projectId,
    required this.userId,
    required this.originalFilename,
    required this.fileUrl,
    required this.fileType,
    this.duration,
    this.fileSize,
    this.width,
    this.height,
    this.thumbnailUrl,
    required this.importedAt,
  });

  factory MediaAsset.fromJson(Map<String, dynamic> json) {
    return MediaAsset(
      assetId: json['asset_id'],
      projectId: json['project_id'],
      userId: json['user_id'],
      originalFilename: json['original_filename'],
      fileUrl: json['file_url'],
      fileType: json['file_type'],
      duration: json['duration']?.toDouble(),
      fileSize: json['file_size'],
      width: json['width'],
      height: json['height'],
      thumbnailUrl: json['thumbnail_url'],
      importedAt: DateTime.parse(json['imported_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'asset_id': assetId,
      'project_id': projectId,
      'user_id': userId,
      'original_filename': originalFilename,
      'file_url': fileUrl,
      'file_type': fileType,
      'duration': duration,
      'file_size': fileSize,
      'width': width,
      'height': height,
      'thumbnail_url': thumbnailUrl,
      'imported_at': importedAt.toIso8601String(),
    };
  }
}
