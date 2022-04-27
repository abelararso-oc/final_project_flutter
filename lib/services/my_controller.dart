import 'dart:typed_data';

import '../model/Dashbord.dart';
import 'IncomeService.dart';
import 'firebase_storage.dart';


class MyController {

  static final _firebaseStorage = FirebaseStorage();
  static final incom = IncomeService();

  static Future<Uint8List?> getProfilePicture() {
    return _firebaseStorage.getProfilePicture();
  }

  static void setProfilePicture(Uint8List data) {
    return _firebaseStorage.setProfilePicture(data);
  }


}
