import 'package:dom_vmeste/data/models/repair_models.dart';

abstract class RepairState {}

class RepairInitialState extends RepairState {}
class RepairLoadingState extends RepairState {}
class RepairLoadedState extends RepairState {
  final List<RepairRequestModel> requests;

  RepairLoadedState({required this.requests});
}
class RepairErrorState extends RepairState {
  final String message;

  RepairErrorState({required this.message});}