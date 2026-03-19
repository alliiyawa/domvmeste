import 'package:equatable/equatable.dart';

class AnnouncementModel extends Equatable {
  final String id;

  final String title;

  final String description;

  final String authorId;

  final String authorName;

  final DateTime createdAt;

  const AnnouncementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
  });

  static final AnnouncementModel empty = AnnouncementModel(
    id: '',
    title: '',
    description: '',
    authorId: '',
    authorName: '',
    createdAt: DateTime(0),
  );

  bool get isEmpty => id.isEmpty;
  bool get isNotEmpty => id.isNotEmpty;

  factory AnnouncementModel.fromJson(Map<String, dynamic> json, String id) {
    return AnnouncementModel(
      id: id,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      authorId: json['authorId'] as String? ?? '',
      authorName: json['authorName'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as dynamic).toDate()
          : DateTime(0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'authorId': authorId,
      'authorName': authorName,
      'createdAt': createdAt,
    };
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    authorId,
    authorName,
    createdAt,
  ];
}
