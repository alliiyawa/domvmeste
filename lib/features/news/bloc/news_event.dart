abstract class NewsEvent {}

class NewsLoadEvent extends NewsEvent {}

class NewsAddEvent extends NewsEvent {
  final String title;
  final String description;

  NewsAddEvent({required this.title, required this.description});
}

class NewsDeleteEvent extends NewsEvent {
  final String id;
  NewsDeleteEvent({required this.id});
}
