import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../services/Auth/Auth.dart';
import '../services/my_controller.dart';

class ProfilePictureNotifier extends ChangeNotifier {
  Uint8List? _data;
  bool _isLoading = true;
  bool _exists = false;

  Uint8List? get data => _data;

  bool get isLoading => _isLoading;

  bool get exists => _exists;

  ProfilePictureNotifier() {
    _reload(Auth.isSignedIn());

    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) => _reload(user == null));
  }

  void updateProfilePicture(Uint8List data) {
    _data = data;
    _exists = true;
    _isLoading = false;
    notifyListeners();

    MyController.setProfilePicture(data);
  }

  void _reload(bool isLoggedIn) async {
    if (isLoggedIn) {
      _isLoading = true;
      notifyListeners();

      final profilePic = await MyController.getProfilePicture();
      _exists = profilePic != null;
      _data = profilePic;
      notifyListeners();
    } else {
      _data = null;
      _isLoading = false;
      _exists = false;
      notifyListeners();
    }
  }
}
