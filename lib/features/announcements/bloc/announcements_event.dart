abstract class AnnouncementsEvent {}

class AnnouncementLoadEvent extends AnnouncementsEvent {}

class AnnouncementsAddEvent extends AnnouncementsEvent {
  final String title;
  final String description;

AnnouncementsAddEvent({required this.title, required this.description});
}

class AnnouncementsDeleteEvent extends AnnouncementsEvent {
  final String id;
  AnnouncementsDeleteEvent({required this.id});
}