import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final _users = FirebaseFirestore.instance.collection('users');

  Future<void> createUser(UserModel user) async {
    await _users.doc(user.uid).set(user.toMap(), SetOptions(merge: true));
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _users.doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(uid, doc.data()!);
    }
    return null;
  }

  Stream<UserModel?> streamUser(String uid) {
    return _users.doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromMap(uid, doc.data()!);
      }
      return null;
    });
  }

  Future<void> updateUserBio(String uid, String bio) async {
    await _users.doc(uid).set({'bio': bio}, SetOptions(merge: true));
  }

  Future<void> updateUserProfilePicture(String uid, String url) async {
    await _users.doc(uid).set({'profilePictureUrl': url}, SetOptions(merge: true));
  }

  Future<void> updateUserUsername(String uid, String username) async {
    await _users.doc(uid).set({'username': username}, SetOptions(merge: true));
  }
} 