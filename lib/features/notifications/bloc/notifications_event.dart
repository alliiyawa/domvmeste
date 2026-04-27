abstract class NotificationsEvent {}


class NotificationsLoadEvent extends NotificationsEvent {}

class NotificationsMarkAsReadEvent extends NotificationsEvent {
  final String notificationId;
  NotificationsMarkAsReadEvent({required this.notificationId});
}

class NotificationsMarkAllAsReadEvent extends NotificationsEvent {}