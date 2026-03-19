import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dom_vmeste/data/models/news_models.dart';
import 'package:dom_vmeste/features/news/bloc/news_event.dart';
import 'package:dom_vmeste/features/news/bloc/news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final _newsCollection = FirebaseFirestore.instance.collection('news');

  StreamSubscription<QuerySnapshot>? _newsSubscription;

  NewsBloc() : super(NewsInitialState()) {
    on<NewsLoadEvent>(_onLoad);
    on<NewsAddEvent>(_onAdd);
    on<NewsDeleteEvent>(_onDelete);
    on<_NewsUpdatedEvent>((event, emit) => emit(NewsLoadedState(news: event.news)));
  }

  void _onLoad(NewsLoadEvent event, Emitter<NewsState> emit) {
    emit(NewsLoadingState());

    _newsSubscription?.cancel();

    _newsSubscription = _newsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
      (snapshot) {
        final news = snapshot.docs.map((doc) {
          return NewsModels.fromJson(doc.data(), doc.id);
        }).toList();

        add(_NewsUpdatedEvent(news));
      },
      onError: (error) {
        add(_NewsErrorEvent(error.toString()));
      },
    );
  }

  Future<void> _onAdd(NewsAddEvent event, Emitter<NewsState> emit) async {
    try {
      await _newsCollection.add({
        'title': event.title,
        'description': event.description,
        'imageUrl': '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      emit(NewsErrorState(message: e.toString()));
    }
  }

  Future<void> _onDelete(NewsDeleteEvent event, Emitter<NewsState> emit) async {
    try {
      await _newsCollection.doc(event.id).delete();
    } catch (e) {
      emit(NewsErrorState(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _newsSubscription?.cancel();
    return super.close();
  }
}

// Внутренние события — используются только внутри BLoC.
class _NewsUpdatedEvent extends NewsEvent {
  final List<NewsModels> news;
  _NewsUpdatedEvent(this.news);
}

class _NewsErrorEvent extends NewsEvent {
  final String message;
  _NewsErrorEvent(this.message);
}