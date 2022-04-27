import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../services/my_controller.dart';
import 'Auth/Auth.dart';

class FirebaseStorage {
  Future<Uint8List?> getProfilePicture() async {
    try {
      return await _getReference().getData();
    } on IOException {
    } on StateError {}
    return null;
  }

  void setProfilePicture(Uint8List data) {
    _getReference().putData(data);
  }

  firebase_storage.Reference _getReference() {
    final userId = Auth.getUserId();
    if (userId == null) throw StateError('not logged in');

    return firebase_storage.FirebaseStorage.instance.ref('images/$userId.png');
  }
}
