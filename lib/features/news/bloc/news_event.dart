abstract class NewsEvent {}

class NewsLoadEvent extends NewsEvent {}

class NewsAddEvent extends NewsEvent {
  final String title;
  final String description;
  final String? imageUrl;

  NewsAddEvent({required this.title, required this.description, this.imageUrl});
}

class NewsDeleteEvent extends NewsEvent {
  final String id;
  NewsDeleteEvent({required this.id});
}
