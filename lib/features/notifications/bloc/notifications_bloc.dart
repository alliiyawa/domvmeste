import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dom_vmeste/core/services/notification_service.dart';
import 'package:dom_vmeste/data/models/notification_model.dart';
import 'notifications_event.dart';
import 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final String userId;
  StreamSubscription<QuerySnapshot>? _subscription;

  NotificationsBloc({required this.userId}) : super(NotificationsInitialState()) {
    on<NotificationsLoadEvent>(_onLoad);
    on<NotificationsMarkAsReadEvent>(_onMarkAsRead);
    on<NotificationsMarkAllAsReadEvent>(_onMarkAllAsRead);
    on<_NotificationsUpdatedEvent>((event, emit) =>
        emit(NotificationsLoadedState(notifications: event.notifications)));
    on<_NotificationsErrorEvent>((event, emit) =>
        emit(NotificationsErrorState(message: event.message)));
  }

  void _onLoad(NotificationsLoadEvent event, Emitter<NotificationsState> emit) {
    emit(NotificationsLoadingState());
    _subscription?.cancel();

    _subscription = NotificationService.instance
        .getNotificationsStream(userId)
        .listen(
      (snapshot) {
        final notifications = snapshot.docs.map((doc) {
          return NotificationModel.fromMap(
            doc.data() as Map<String, dynamic>,
            doc.id,
          );
        }).toList();
        add(_NotificationsUpdatedEvent(notifications: notifications));
      },
      onError: (error) {
        add(_NotificationsErrorEvent(message: error.toString()));
      },
    );
  }

  FutureOr<void> _onMarkAsRead(
    NotificationsMarkAsReadEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    await NotificationService.instance.markAsRead(userId, event.notificationId);
  }

  FutureOr<void> _onMarkAllAsRead(
    NotificationsMarkAllAsReadEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is NotificationsLoadedState) {
      final notifications = (state as NotificationsLoadedState).notifications;
      for (final n in notifications.where((n) => !n.isRead)) {
        await NotificationService.instance.markAsRead(userId, n.id);
      }
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

// ── Приватные события ─────────────────────────────────────────────

class _NotificationsUpdatedEvent extends NotificationsEvent {
  final List<NotificationModel> notifications;
  _NotificationsUpdatedEvent({required this.notifications});
}

class _NotificationsErrorEvent extends NotificationsEvent {
  final String message;
  _NotificationsErrorEvent({required this.message});
}