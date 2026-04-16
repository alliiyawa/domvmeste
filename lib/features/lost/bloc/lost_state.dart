import 'package:dom_vmeste/data/models/lost_model.dart';

abstract class LostState {}

class LostInitialState extends LostState {}

class LostLoadingState extends LostState {}

class LostLoadedState extends LostState {
  final List<LostModel> items;

  LostLoadedState({required this.items});
}

class LostErrorState extends LostState {
  final String message;

  LostErrorState({required this.message});
}