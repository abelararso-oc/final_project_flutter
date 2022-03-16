import '../model/task.dart';
import 'auth.dart';
import 'firestore_backend.dart';
import 'storage.dart';

class MyController {
  static Storage storage = FirestoreBackend();

  // static List<Task> getTasks() {
  //   return FakeData.getTasks();
  // }

  static Future<List<Task>> getTasks() {
    return storage.getTasks();
  }

  static Future<void> deleteTask(Task task) {
    return storage.removeTask(task);
  }

  static Future<Task> addTask(Task task) {
    return storage.insertTask(task);
  }

  static Future<String?> createAccount({required String email, required String password}) {
    return Auth.createAccountWithEmailAndPassword(
        email: email, password: password);
  }

  static Future<String?> signIn({required String email, required String password}) {
    return Auth.signInWithEmailAndPassword(email: email, password: password);
  }

  static void signOut() {
    return Auth.signOut();
  }

  static String? getUserId() {
    return Auth.getUserId();
  }

  static bool isSignedIn() {
    return Auth.isSignedIn();
  }
}
