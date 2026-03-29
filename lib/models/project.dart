class Project {
  final int projectId;
  final String userId;
  final String projectName;
  final String? description;
  final String aspectRatio;
  final int frameRate;
  final String resolution;
  final double? totalDuration;
  final String? thumbnailUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Project({
    required this.projectId,
    required this.userId,
    required this.projectName,
    this.description,
    this.aspectRatio = '16:9',
    this.frameRate = 30,
    this.resolution = '1920x1080',
    this.totalDuration,
    this.thumbnailUrl,
    required this.createdAt,
    this.updatedAt,
  });

  // JSON se object banane ke liye (Supabase se data aane par)
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      projectId: json['project_id'],
      userId: json['user_id'],
      projectName: json['project_name'],
      description: json['description'],
      aspectRatio: json['aspect_ratio'] ?? '16:9',
      frameRate: json['frame_rate'] ?? 30,
      resolution: json['resolution'] ?? '1920x1080',
      totalDuration: json['total_duration']?.toDouble(),
      thumbnailUrl: json['thumbnail_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  // Object ko JSON mein convert karne ke liye (agar zaroori ho)
  Map<String, dynamic> toJson() {
    return {
      'project_id': projectId,
      'user_id': userId,
      'project_name': projectName,
      'description': description,
      'aspect_ratio': aspectRatio,
      'frame_rate': frameRate,
      'resolution': resolution,
      'total_duration': totalDuration,
      'thumbnail_url': thumbnailUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
