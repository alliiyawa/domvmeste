import 'package:equatable/equatable.dart';

class NewsModels extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime createdAt;
  const NewsModels({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
  });
  static final NewsModels empty = NewsModels(
    id: '',
    title: '',
    description: '',
    imageUrl: '',
    createdAt: DateTime(0),
  );
  bool get isEmpty => id.isEmpty;
  bool get isNotEmpty => id.isNotEmpty;

  factory NewsModels.fromJson(Map<String, dynamic> json, String id) {
    return NewsModels(
      id: id,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as dynamic).toDate()
          : DateTime(0),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
    };
  }

  @override
  List<Object?> get props => [id, title, description, imageUrl, createdAt];
}
