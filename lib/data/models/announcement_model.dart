import 'package:equatable/equatable.dart';

class AnnouncementModel extends Equatable {
  final String id;

  final String title;

  final String description;

  final String authorId;
  final String phone;
  final String price;
  final String authorName;
  final String imageUrl;
  final DateTime createdAt;

  const AnnouncementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.authorId,
    required this.phone,
    required this.price,
    required this.authorName,
    required this.createdAt,
    required this.imageUrl,
  });

  static final AnnouncementModel empty = AnnouncementModel(
    id: '',
    title: '',
    description: '',
    authorId: '',
    phone: '',
    price: '',
    authorName: '',
    createdAt: DateTime(0),
    imageUrl: '',
  );

  bool get isEmpty => id.isEmpty;
  bool get isNotEmpty => id.isNotEmpty;

  factory AnnouncementModel.fromJson(Map<String, dynamic> json, String id) {
    return AnnouncementModel(
      id: id,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      authorId: json['authorId']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      price: json['price']?.toString() ?? '',
      authorName: json['authorName']?.toString() ?? '',
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
      'phone': phone,
      'price': price,
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
    phone,
    price,
    authorName,
    createdAt,
  ];
}
