import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

DateTime? toDateTime(dynamic data) {
  if (data == null || !(data is Timestamp)) {
    return null;
  }
  final Timestamp ts = data;
  return DateTime.fromMillisecondsSinceEpoch(ts.millisecondsSinceEpoch);
}

String? dateToString({required DateTime? dateTime}) {
  return dateTime == null ? null : DateFormat.yMd().format(dateTime);
}

