import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/Dashbord.dart';
import '../model/Expense.dart';
import '../model/Income.dart';
import '../utils/date_converter.dart';
import 'Auth/Auth.dart';

class IncomeService {
  static const _users = 'user';
  static const _incomes = 'income';

  static Future<List<Income>> get() async {
    final userId = Auth.getUserId();
    if (userId == null) throw StateError('Not logged in');
    final result = await FirebaseFirestore.instance
        .collection(_users)
        .doc(userId)
        .collection(_incomes)
        .get();
    final listIncom = result.docs
        .map<Income>((e) => Income(
            amount: e.data()['amount'],
            expanseCategory: e.data()['expanse_category'],
            date: toDateTime(e.data()['date']),
            id: e.data()['id']))
        .toList();

    print(listIncom);
    return listIncom;
  }

  static Future<Income> insert({required Income income}) async {
    final userId = Auth.getUserId();
    if (userId == null) throw StateError('Not logged in');

    DocumentReference ref =
        FirebaseFirestore.instance.collection(_incomes).doc();
    income.id = ref.id.toString();
    FirebaseFirestore.instance
        .collection(_users)
        .doc(userId)
        .collection(_incomes)
        .doc(income.id)
        .set(income.toMap())
        .then((value) {
      print('Added new income: ${income}');
    }).catchError((error) => print("Failed to add income: $error"));

    return income;
  }

  static Future<void> remove(Income income) {
    final userId = Auth.getUserId();
    if (userId == null) throw StateError('Not logged in');

    FirebaseFirestore.instance
        .collection(_users)
        .doc(userId)
        .collection(_incomes)
        .doc(income.id.toString())
        .delete()
        .then((value) => print("Delete income: ${income.id}"))
        .catchError((error) => print("Failed to income task: $error"));
    return Future.sync(() => null);
  }

  static Future<DashBord> AllData() async {
    final userId = Auth.getUserId();
    if (userId == null) throw StateError('Not logged in');
    final result = await FirebaseFirestore.instance
        .collection(_users)
        .doc(userId)
        .collection(_incomes)
        .get();
    final listIncom = result.docs
        .map<Income>((e) => Income(
            amount: e.data()['amount'],
            expanseCategory: e.data()['expanse_category'],
            date: toDateTime(e.data()['date']),
            id: e.data()['id']))
        .toList();


    var r = DashBord();
    r.amountI = 0;
    for (var e in listIncom) {
      r.amountI += e.amount;
    }
    print('amountI ${r.amountI}');


    final result2 = await FirebaseFirestore.instance
        .collection(_users)
        .doc(userId)
        .collection('expanse')
        .get();
    final listOfExpan = result2.docs
        .map<Expanse>((e) => Expanse(
        amount: e.data()['amount'],
        expanseCategory: e.data()['expanse_category'],
        date: toDateTime(e.data()['date']),
        id: e.data()['id']))
        .toList();

    r.amountE = 0;
    for (var e in listOfExpan) {
      r.amountE += e.amount;
    }

    print('amountE ${r.amountE}');

    r.amountS = r.amountI - r.amountE;

    print('amountS ${r.amountS}');

    return r;
  }
}
