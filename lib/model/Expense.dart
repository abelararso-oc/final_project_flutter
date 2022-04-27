import 'package:decimal/decimal.dart';
import 'package:uuid/uuid.dart';

class Expanse {
  String id;
  double amount;
  String expanseCategory;
  bool isCompleted;
  DateTime? date;

  Expanse(
      {this.id = "",
      this.date,
      required this.amount,
      required this.expanseCategory})
      : isCompleted = false;

  Map<String, dynamic> toMap() =>
      {"id": id, "amount": amount, "expanse_category": expanseCategory, "date": date};

  factory Expanse.fromMap(Map<String, dynamic> json) => Expanse(
      id: json["id"],
      amount: json["amount"],
      expanseCategory: json["expanse_category"]);
}
