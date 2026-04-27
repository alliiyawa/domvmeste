class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String category; // 'news', 'announcements', 'repair', 'lost', 'rules'
  final bool isRead;
  final bool isImportant;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.isRead,
    required this.isImportant,
    required this.createdAt,
  });

  // Иконка в зависимости от категории
  String get categoryIcon {
    switch (category) {
      case 'news': return '📢';
      case 'announcements': return '📋';
      case 'repair': return '🔧';
      case 'lost': return '🔍';
      case 'rules': return '📜';
      default: return '🔔';
    }
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map, String id) {
    return NotificationModel(
      id: id,
      title: map['title'] as String? ?? '',
      body: map['body'] as String? ?? '',
      category: map['category'] as String? ?? '',
      isRead: map['isRead'] as bool? ?? false,
      isImportant: map['isImportant'] as bool? ?? false,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'category': category,
      'isRead': isRead,
      'isImportant': isImportant,
      'createdAt': createdAt,
    };
  }

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      body: body,
      category: category,
      isRead: isRead ?? this.isRead,
      isImportant: isImportant,
      createdAt: createdAt,
    );
  }
}