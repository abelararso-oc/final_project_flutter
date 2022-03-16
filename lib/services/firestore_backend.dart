import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../model/task.dart';
import '../utils/date_converter.dart';
import 'my_controller.dart';
import 'storage.dart';

class FirestoreBackend implements Storage {
  static const _users = 'user';
  static const _tasks = 'tasks';
  static const _description = 'description';
  static const _dueDate = 'dueDate';

  @override
  Future<List<Task>> getTasks() async {
    final userId = MyController.getUserId();
    if (userId == null) throw StateError('Not logged in');
    final result = await FirebaseFirestore.instance
        .collection(_users)
        .doc(userId)
        .collection(_tasks)
        .get();
    final listOfTasks = result.docs
        .map<Task>((e) => Task(
            description: e.data()[_description],
            dueDate: toDateTime(e.data()[_dueDate]),
            id: e.id.toString()))
        .toList();
    print('List of task for $userId :  $listOfTasks');
    return listOfTasks;
  }

  @override
  Future<Task> insertTask(Task task) async {
    final userId = MyController.getUserId();
    if (userId == null) throw StateError('Not logged in');

    FirebaseFirestore.instance
        .collection(_users)
        .doc(userId)
        .collection(_tasks)
        .add({'description': task.description, 'dueDate': task.dueDate})
        .then(
            (value) => print('Task Added new description: ${task.description}'))
        .catchError((error) => print("Failed to add task: $error"));

    final result = await FirebaseFirestore.instance
        .collection(_users)
        .doc(userId)
        .collection(_tasks)
        .get();
    var newTask = result.docs
        .map<Task>((e) => Task(
            description: e.data()[_description],
            dueDate: toDateTime(e.data()[_dueDate]),
            id: e.id.toString()))
        .firstWhere((element) => element.description == task.description);

    return Task(
        id: newTask.id,
        dueDate: newTask.dueDate,
        description: newTask.description);
  }

  @override
  Future<void> removeTask(Task task) async {
    final userId = MyController.getUserId();
    if (userId == null) throw StateError('Not logged in');

    FirebaseFirestore.instance
        .collection(_users)
        .doc(userId)
        .collection(_tasks)
        .doc(task.id.toString())
        .delete()
        .then((value) => print("Delete task: ${task.id}"))
        .catchError((error) => print("Failed to delete task: $error"));
    return Future.sync(() => null);
  }
}
