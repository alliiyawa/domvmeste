abstract class LostEvent {}

class LostLoadEvent extends LostEvent {}

class LostAddEvent extends LostEvent {
  final String title;
  final String description;
  final String authorName;
  final String phone;
  final String imageUrl;
  final String category;

  LostAddEvent({
    required this.title,
    required this.description,
    required this.authorName,
    required this.phone,
    required this.imageUrl,
    required this.category,
  });
}

class LostDeleteEvent extends LostEvent {
  final String id;
  LostDeleteEvent({required this.id});
}