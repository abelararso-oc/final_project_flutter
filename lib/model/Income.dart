import 'package:final_project_flutter/services/storage.dart';
import 'package:uuid/uuid.dart';

class Income {
  String id;
  double amount;
  String expanseCategory;
  bool isCompleted;
  DateTime? date;

  Income(
      {this.id = "",
      this.date,
      required this.amount,
      required this.expanseCategory})
      : isCompleted = false;

  Map<String, dynamic> toMap() => {
        "id": id,
        "amount": amount,
        "expanse_category": expanseCategory,
        "date": date
      };

  factory Income.fromMap(Map<String, dynamic> json) => Income(
      id: json["id"],
      amount: json["amount"],
      expanseCategory: json["expanse_category"],
      date: json["date"]);
}
