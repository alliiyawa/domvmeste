import 'package:dom_vmeste/data/models/announcement_model.dart';

abstract class AnnouncementsState {}

class AnnouncementInitialState extends AnnouncementsState {}
class AnnouncementLoadingState extends AnnouncementsState {}
class AnnouncementLoadedState extends AnnouncementsState {
  final List<AnnouncementModel> announcements;

  AnnouncementLoadedState({required this.announcements});
}
class AnnouncementsErrorState extends AnnouncementsState {
  final String message;

  AnnouncementsErrorState({required this.message});}