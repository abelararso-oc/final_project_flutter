import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  static final _auth = FirebaseAuth.instance;

  static Future<String?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print('Sign In result $result');
      return null;
    } on FirebaseAuthException catch (e) {
      print(e);
      return _parseSignInAuthException(e);
    }
  }

  static Future<String?> createAccountWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print('Create Account In result $result');
      return null;
    } on FirebaseAuthException catch (e) {
      return _parseCreateAccountAuthException(e);
    }
  }

  static String? getUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid.toString();
  }

  static bool isSignedIn() {
    return FirebaseAuth.instance.currentUser == null ? false : true;
  }

  static void signOut() {
    _auth.signOut();
  }

  static String _parseSignInAuthException(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return 'Email address is not formatted correctly';
      case 'user-not-found':
      case 'wrong-password':
      case 'user-disabled':
        print('this should be hit');
        return 'Invalid username or password';
      case 'too-many-requests':
      case 'operation-not-allowed':
      default:
        return 'An unknown error occurred';
    }
  }

  static String _parseCreateAccountAuthException(
      FirebaseAuthException exception) {
    switch (exception.code) {
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Email address is not formatted correctly';
      case 'email-already-in-use':
        return 'This email address already exists';
      default:
        return 'An unknown error occurred';
    }
  }
}
