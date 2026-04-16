import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dom_vmeste/data/models/lost_model.dart';
import 'lost_event.dart';
import 'lost_state.dart';

class LostBloc extends Bloc<LostEvent, LostState> {
  final _lostCollection = FirebaseFirestore.instance.collection('lost');

  StreamSubscription<QuerySnapshot>? _lostSubscription;

  LostBloc() : super(LostInitialState()) {
    on<LostLoadEvent>(_onLoad);
    on<LostAddEvent>(_onAdd);
    on<LostDeleteEvent>(_onDelete);
    on<_LostUpdatedEvent>((event, emit) =>
        emit(LostLoadedState(items: event.items)));
    on<_LostErrorEvent>((event, emit) =>
        emit(LostErrorState(message: event.message)));
  }

  void _onLoad(LostLoadEvent event, Emitter<LostState> emit) {
    emit(LostLoadingState());
    _lostSubscription?.cancel();

    _lostSubscription = _lostCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
      (snapshot) {
        final items = snapshot.docs.map((doc) {
          return LostModel.fromJson(doc.data(), doc.id);
        }).toList();
        add(_LostUpdatedEvent(items: items));
      },
      onError: (error) {
        add(_LostErrorEvent(message: error.toString()));
      },
    );
  }

  FutureOr<void> _onAdd(LostAddEvent event, Emitter<LostState> emit) async {
    try {
      await _lostCollection.add({
        'title': event.title,
        'description': event.description,
        'authorName': event.authorName,
        'phone': event.phone,
        'imageUrl': event.imageUrl,
        'category': event.category,

        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      emit(LostErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _onDelete(
      LostDeleteEvent event, Emitter<LostState> emit) async {
    try {
      await _lostCollection.doc(event.id).delete();
    } catch (e) {
      emit(LostErrorState(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _lostSubscription?.cancel();
    return super.close();
  }
}


class _LostUpdatedEvent extends LostEvent {
  final List<LostModel> items;
  _LostUpdatedEvent({required this.items});
}

class _LostErrorEvent extends LostEvent {
  final String message;
  _LostErrorEvent({required this.message});
}