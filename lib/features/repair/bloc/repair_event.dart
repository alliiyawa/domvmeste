abstract class RepairEvent {}

class RepairLoadEvent extends RepairEvent {}

class RepairAddEvent extends RepairEvent {

  final String repairType;
  final String description;
  final String date;
  final String timeFrom;
  final String timeTo;
  final String address;
  final String? imageUrls;

  RepairAddEvent({required this.repairType, required this.description, required this.date, required this.timeFrom, required this.timeTo, required this.address, required this.imageUrls});
}
class RepairDeleteEvent extends RepairEvent {
  final String id;
  RepairDeleteEvent({ required this.id});
}