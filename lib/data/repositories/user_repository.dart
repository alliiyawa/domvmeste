import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_models.dart';

class UserRepository {
  final _collection = FirebaseFirestore.instance.collection('users');

  Future<UserModel> getUser(String id) async {
    final doc = await _collection.doc(id).get();

    // Если документа нет — создаём пустой профиль из Firebase Auth
    if (!doc.exists || doc.data() == null) {
      final authUser = FirebaseAuth.instance.currentUser;
      return UserModel(
        id: id,
        name: authUser?.displayName ?? '',
        phone: '',
        apartment: '',
        entrance: '',
        address: '',
        interests: [], email: '', photoUrl: '',
      );
    }

    return UserModel.fromMap(doc.data()!, doc.id);
  }

  Future<void> updateUser(UserModel user) async {
    await _collection.doc(user.id).set(user.toMap());
  }
}