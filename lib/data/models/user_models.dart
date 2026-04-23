import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String id;
  final String uid; // ← для Firebase Auth
  final String name;
  final String email; // ← для Firebase Auth
  final String phone;
  final String apartment;
  final String entrance;
  final String address;
  final String photoUrl; // ← фото из Google
  final List<String> interests;

  UserModel({
    required this.id,
    String? uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.apartment,
    required this.entrance,
    required this.address,
    required this.photoUrl,
    required this.interests,
  }) : uid = uid ?? id;

  static final UserModel empty = UserModel(
    id: '',
    name: '',
    email: '',
    phone: '',
    apartment: '',
    entrance: '',
    address: '',
    photoUrl: '',
    interests: [],
  );

  bool get isEmpty => id.isEmpty;
  bool get isNotEmpty => id.isNotEmpty;

  // Создать из Firebase Auth пользователя
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      id: user.uid,
      uid: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      phone: user.phoneNumber ?? '',
      apartment: '',
      entrance: '',
      address: '',
      photoUrl: user.photoURL ?? '',
      interests: [],
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      uid: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      apartment: map['apartment'] ?? '',
      entrance: map['entrance'] ?? '',
      address: map['address'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      interests: List<String>.from(map['interests'] ?? []),
    );
  }

  // toJson — для AuthRepository
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'apartment': apartment,
      'entrance': entrance,
      'address': address,
      'photoUrl': photoUrl,
      'interests': interests,
    };
  }

  // toMap — для UserRepository
  Map<String, dynamic> toMap() => toJson();
}