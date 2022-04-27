import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_flutter/services/Auth/Auth.dart';
import 'package:uuid/uuid.dart';

import '../model/Expense.dart';
import '../utils/date_converter.dart';

class ExpanseService {
  static const _users = 'user';
  static const _expanses = 'expanse';

  static Future<List<Expanse>> get() async {
    final userId = Auth.getUserId();
    if (userId == null) throw StateError('Not logged in');
    final result = await FirebaseFirestore.instance
        .collection(_users)
        .doc(userId)
        .collection(_expanses)
        .get();
    final listOfExpan = result.docs
        .map<Expanse>((e) => Expanse(
            amount: e.data()['amount'],
            expanseCategory: e.data()['expanse_category'],
            date: toDateTime(e.data()['date']),
            id: e.data()['id']))
        .toList();

    print(listOfExpan);
    return listOfExpan;
  }

  static Future<Expanse> insert({required Expanse expanse}) async {
    final userId = Auth.getUserId();
    if (userId == null) throw StateError('Not logged in');
    DocumentReference ref =
        FirebaseFirestore.instance.collection(_expanses).doc();
    expanse.id = ref.id.toString();
    FirebaseFirestore.instance
        .collection(_users)
        .doc(userId)
        .collection(_expanses)
        .doc(expanse.id)
        .set(expanse.toMap())
        .then((value) {
      print('Added new expanse: ${expanse}');
    }).catchError((error) => print("Failed to add expanse: $error"));

    return expanse;
  }

  static Future<void> remove(Expanse expanse) {
    final userId = Auth.getUserId();
    if (userId == null) throw StateError('Not logged in');

    FirebaseFirestore.instance
        .collection(_users)
        .doc(userId)
        .collection(_expanses)
        .doc(expanse.id.toString())
        .delete()
        .then((value) => print("Delete expanse: ${expanse.id}"))
        .catchError((error) => print("Failed to expanse task: $error"));
    return Future.sync(() => null);
  }
}
