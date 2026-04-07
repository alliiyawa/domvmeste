import 'package:equatable/equatable.dart';

class RepairRequestModel extends Equatable {
  final String id;
  final String repairType;
  final String description;
  final String date;
  final String timeFrom;
  final String timeTo;
  final String address;
  final List<String> imageUrls;
  final DateTime createdAt;

  const RepairRequestModel({
    required this.id,
    required this.repairType,
    required this.description,
    required this.date,
    required this.timeFrom,
    required this.timeTo,
    required this.address,
    required this.imageUrls,
    required this.createdAt,
  });

  factory RepairRequestModel.fromJson(Map<String, dynamic> json, String id) {
    return RepairRequestModel(
      id: id,
      repairType: json['repairType'] as String? ?? '',
      description: json['description'] as String? ?? '',
      date: json['date'] as String? ?? '',
      timeFrom: json['timeFrom'] as String? ?? '',
      timeTo: json['timeTo'] as String? ?? '',
      address: json['address'] as String? ?? '',
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as dynamic).toDate()
          : DateTime(0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'repairType': repairType,
      'description': description,
      'date': date,
      'timeFrom': timeFrom,
      'timeTo': timeTo,
      'address': address,
      'imageUrls': imageUrls,
      'createdAt': createdAt,
    };
  }

  @override
  List<Object?> get props => [
    id, repairType, description, date,
    timeFrom, timeTo, address, imageUrls, createdAt,
  ];
}