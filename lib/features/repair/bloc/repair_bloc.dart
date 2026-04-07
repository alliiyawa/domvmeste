import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dom_vmeste/data/models/repair_models.dart';
import 'package:dom_vmeste/features/repair/bloc/repair_event.dart';
import 'package:dom_vmeste/features/repair/bloc/repair_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RepairBloc extends Bloc<RepairEvent, RepairState>{
  final _repairrequestsCollection = FirebaseFirestore.instance.collection('requests');

  StreamSubscription<QuerySnapshot>? _requestsSubscription;
  RepairBloc() : super(RepairInitialState()) {
    on<RepairLoadEvent>(_onLoad);
    on<RepairAddEvent>(_onAdd);
    on<RepairDeleteEvent>(_onDelete);
    on<_RepairUpdatedEvent>((event, emit) => emit(RepairLoadedState(requests: event.requests)));
    on<_RepairErrorEvent>((event, emit) => emit(RepairErrorState(message: event.message)),);
  }
  
  

  void _onLoad(RepairLoadEvent event, Emitter<RepairState> emit) {
    emit(RepairLoadingState());
    _requestsSubscription?.cancel();
    _requestsSubscription = _repairrequestsCollection
    .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
          (snapshot) 

          {
            final requests = snapshot.docs.map((doc) {
              return RepairRequestModel.fromJson(doc.data(), doc.id);
            }).toList();

            add(_RepairUpdatedEvent(requests: requests));
          },
          onError: (error) {
            add(_RepairErrorEvent(message: error.toString()));
          },
        );
  }

  FutureOr<void> _onAdd(RepairAddEvent event, Emitter<RepairState> emit) async {
    try {
      await _repairrequestsCollection.add({
        'repairType': event.repairType, 
        'description' : event.description,
   'date': event.date,
  'timeFrom' : event.timeFrom,
  'timeTo': event.timeTo,
  'address': event.address,
  'imageUrls': event.imageUrls ?? '',
  'createdAt' : FieldValue.serverTimestamp(),

      });
    } catch (e) {
      emit(RepairErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _onDelete(RepairDeleteEvent event, Emitter<RepairState> emit) async {
    try {
      await _repairrequestsCollection.doc(event.id).delete();
    } catch (e) {
      emit(RepairErrorState(message: e.toString()));
    }
  }
}

class _RepairErrorEvent extends RepairEvent{
  final String message;
  _RepairErrorEvent({required this.message});
}

class _RepairUpdatedEvent extends RepairEvent{
  final List<RepairRequestModel> requests;
_RepairUpdatedEvent({required this.requests});
}