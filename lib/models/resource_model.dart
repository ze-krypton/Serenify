import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum ResourceType {
  article,
  video,
  audio,
  exercise,
  link,
  pdf,
}

class Resource extends Equatable {
  final String id;
  final String title;
  final String description;
  final ResourceType type;
  final String url;
  final String? thumbnailUrl;
  final List<String> categories;
  final DateTime createdAt;
  final String? authorName;
  final int duration; // In seconds for audio/video, estimated reading time for articles
  final bool featured;
  final int viewCount;

  const Resource({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.url,
    this.thumbnailUrl,
    required this.categories,
    required this.createdAt,
    this.authorName,
    this.duration = 0,
    this.featured = false,
    this.viewCount = 0,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        type,
        url,
        thumbnailUrl,
        categories,
        createdAt,
        authorName,
        duration,
        featured,
        viewCount,
      ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.index,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
      'categories': categories,
      'createdAt': createdAt,
      'authorName': authorName,
      'duration': duration,
      'featured': featured,
      'viewCount': viewCount,
    };
  }

  factory Resource.fromMap(Map<String, dynamic> map) {
    return Resource(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      type: ResourceType.values[map['type'] ?? 0],
      url: map['url'] ?? '',
      thumbnailUrl: map['thumbnailUrl'],
      categories: List<String>.from(map['categories'] ?? []),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      authorName: map['authorName'],
      duration: map['duration'] ?? 0,
      featured: map['featured'] ?? false,
      viewCount: map['viewCount'] ?? 0,
    );
  }

  Resource copyWith({
    String? id,
    String? title,
    String? description,
    ResourceType? type,
    String? url,
    String? thumbnailUrl,
    List<String>? categories,
    DateTime? createdAt,
    String? authorName,
    int? duration,
    bool? featured,
    int? viewCount,
  }) {
    return Resource(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      categories: categories ?? this.categories,
      createdAt: createdAt ?? this.createdAt,
      authorName: authorName ?? this.authorName,
      duration: duration ?? this.duration,
      featured: featured ?? this.featured,
      viewCount: viewCount ?? this.viewCount,
    );
  }
}

// Extension to get icon and label for resource type
extension ResourceTypeExtension on ResourceType {
  String get label {
    switch (this) {
      case ResourceType.article:
        return 'Article';
      case ResourceType.video:
        return 'Video';
      case ResourceType.audio:
        return 'Audio';
      case ResourceType.exercise:
        return 'Exercise';
      case ResourceType.link:
        return 'Link';
      case ResourceType.pdf:
        return 'PDF';
      default:
        return 'Article';
    }
  }

  String get icon {
    switch (this) {
      case ResourceType.article:
        return 'article';
      case ResourceType.video:
        return 'video_library';
      case ResourceType.audio:
        return 'headphones';
      case ResourceType.exercise:
        return 'fitness_center';
      case ResourceType.link:
        return 'link';
      case ResourceType.pdf:
        return 'picture_as_pdf';
      default:
        return 'article';
    }
  }
} 