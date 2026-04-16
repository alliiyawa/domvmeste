import 'package:equatable/equatable.dart';

/// Модель потеряшки.
/// category: 'lost' — потеряно, 'found' — найдено
class LostModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String authorName;
  final String phone;
  final String imageUrl;
  final String category; 
  final DateTime createdAt;

  const LostModel({
    required this.id,
    required this.title,
    required this.description,
    required this.authorName,
    required this.phone,
    required this.imageUrl,
    required this.category,
    required this.createdAt,
  });

  factory LostModel.fromJson(Map<String, dynamic> json, String id) {
    return LostModel(
      id: id,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      authorName: json['authorName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      category: json['category'] as String? ?? 'lost',
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as dynamic).toDate()
          : DateTime(0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'authorName': authorName,
      'phone': phone,
      'imageUrl': imageUrl,
      'category': category,
      'createdAt': createdAt,
    };
  }

  @override
  List<Object?> get props => [
    id, title, description, authorName,
    phone, imageUrl, category, createdAt,
  ];
}