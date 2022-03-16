import 'package:flutter/material.dart';

import '../model/task.dart';
import '../services/my_controller.dart';
import '../utils/date_converter.dart';
import 'new_task_page.dart';
import 'opening_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Future<List<Task>> _tasksFuture = MyController.getTasks();
  List<Task>? _tasks;

  Widget _toWidget(Task t) {
    return CheckboxListTile(
      title: Text(t.description),
      subtitle: Text(
        dateToString(dateTime: t.dueDate) ?? '',
        style: TextStyle(color: _isExpired(t.dueDate) ? Colors.red : null),
      ),
      value: t.isCompleted,
      onChanged: (bool? newValue) {
        setState(() {
          t.isCompleted = newValue ?? false;
        });
      },
    );
  }

  bool _isExpired(DateTime? dateTime) {
    if (dateTime == null) return true;
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return dateTime.compareTo(yesterday) <= 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
      future: _tasksFuture,
      builder: (context, snapshot) {
        _tasks = snapshot.hasData ? snapshot.data! : [];
        return Scaffold(
          drawer: Drawer(
            child: SafeArea(
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Sign out'),
                    onTap: () {
                      MyController.signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => OpeningPage()),
                          (_) => false);
                    },
                  ),
                ],
              ),
            ),
          ),
          appBar: AppBar(
            title: const Text('Todo'),
            actions: _tasks!.any((element) => element.isCompleted == true)
                ? [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _tasks
                                ?.where((task) => task.isCompleted)
                                .forEach(MyController.deleteTask);
                            setState(() {
                              _tasks?.removeWhere((task) => task.isCompleted);
                            });
                          });
                        },
                        icon: const Icon(Icons.delete))
                  ]
                : [],
          ),
          body: ListView.separated(
            itemBuilder: (_, index) {
              return _toWidget(_tasks![index]);
            },
            separatorBuilder: (_, __) => const Divider(),
            itemCount: _tasks!.length,
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute<Task>(builder: (_) => NewTaskPage()))
                  .then((value) async {
                if (value != null && value is Task) {
                  final task = await MyController.addTask(value);
                  setState(() => _tasks?.add(task));
                }
              });
            },
          ),
        );
      },
    );
  }
}
