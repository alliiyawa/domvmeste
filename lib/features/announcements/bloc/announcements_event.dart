abstract class AnnouncementsEvent {}

class AnnouncementLoadEvent extends AnnouncementsEvent {}

class AnnouncementsAddEvent extends AnnouncementsEvent {
  final String title;
  final String description;
  final String phone;
  final String price;
  final String? imageUrl;

AnnouncementsAddEvent({required this.title, required this.description,  required this.phone, required this.price, this.imageUrl, });
}

class AnnouncementsDeleteEvent extends AnnouncementsEvent {
  final String id;
  AnnouncementsDeleteEvent({required this.id});
}