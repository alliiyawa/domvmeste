import 'package:dom_vmeste/data/models/notification_model.dart';

abstract class NotificationsState {}

class NotificationsInitialState extends NotificationsState {}

class NotificationsLoadingState extends NotificationsState {}

class NotificationsLoadedState extends NotificationsState {
  final List<NotificationModel> notifications;

  NotificationsLoadedState({required this.notifications});

  /// Непрочитанные уведомления
  List<NotificationModel> get unread =>
      notifications.where((n) => !n.isRead).toList();

  /// Важные уведомления
  List<NotificationModel> get important =>
      notifications.where((n) => n.isImportant).toList();

  /// Количество непрочитанных
  int get unreadCount => unread.length;
}

class NotificationsErrorState extends NotificationsState {
  final String message;
  NotificationsErrorState({required this.message});
}