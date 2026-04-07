import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dom_vmeste/data/models/announcement_model.dart';
import 'package:dom_vmeste/features/announcements/bloc/announcements_event.dart';
import 'package:dom_vmeste/features/announcements/bloc/announcements_state.dart';

class AnnouncementsBloc extends Bloc<AnnouncementsEvent, AnnouncementsState> {
  final _announcementsCollection = FirebaseFirestore.instance.collection(
    'announcements',
  );

  StreamSubscription<QuerySnapshot>? _announcementsSubscription;
  AnnouncementsBloc() : super(AnnouncementInitialState()) {
    on<AnnouncementLoadEvent>(_onLoad);
    on<AnnouncementsAddEvent>(_onAdd);
    on<AnnouncementsDeleteEvent>(_onDelete);
    on<_AnnouncementUpdatedEvent>(
      (event, emit) =>
          emit(AnnouncementLoadedState(announcements: event.announcements)),
    );
    on<_AnnouncementsErrorEvent>(
      (event, emit) => emit(AnnouncementsErrorState(message: event.message)),
    );
  }

  void _onLoad(AnnouncementLoadEvent event, Emitter<AnnouncementsState> emit) {
    emit(AnnouncementLoadingState());

    _announcementsSubscription?.cancel();

    _announcementsSubscription = _announcementsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            final announcements = snapshot.docs.map((doc) {
              return AnnouncementModel.fromJson(doc.data(), doc.id);
            }).toList();

            add(_AnnouncementUpdatedEvent(announcements));
          },
          onError: (error) {
            add(_AnnouncementsErrorEvent(error.toString()));
          },
        );
  }

  FutureOr<void> _onAdd(
    AnnouncementsAddEvent event,
    Emitter<AnnouncementsState> emit,
  ) async {
    try {
      await _announcementsCollection.add({
        'title': event.title,
        'description': event.description,
        'imageUrl': event.imageUrl ?? '', 
        'price': event.price,
        'phone': event.phone,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      emit(AnnouncementsErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _onDelete(
    AnnouncementsDeleteEvent event,
    Emitter<AnnouncementsState> emit,
  ) async {
    try {
      await _announcementsCollection.doc(event.id).delete();
    } catch (e) {
      emit(AnnouncementsErrorState(message: e.toString()));
    }
  }
}

class _AnnouncementsErrorEvent extends AnnouncementsEvent {
  final String message;
  _AnnouncementsErrorEvent(this.message);
}

class _AnnouncementUpdatedEvent extends AnnouncementsEvent {
  final List<AnnouncementModel> announcements;
  _AnnouncementUpdatedEvent(this.announcements);
}
