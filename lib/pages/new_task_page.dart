import 'package:flutter/material.dart';

import '../model/task.dart';
import '../utils/date_converter.dart';

class NewTaskPage extends StatefulWidget {
  @override
  State<NewTaskPage> createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  final TextEditingController _controller = TextEditingController();
  DateTime today = DateTime.now();
  late DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Task')),
      body: ListView(
        children: [
          TextFormField(
            controller: _controller,
            minLines: 3,
            maxLines: null,
            decoration: const InputDecoration(hintText: "New task"),
          ),
          ElevatedButton(
            onPressed: () => showDatePicker(
              context: context,
              initialDate: today.add(const Duration(days: 3)),
              firstDate: today,
              lastDate: today.add(const Duration(days: 1000)),
            ).then((DateTime? value) => setState(() => _selectedDate = value!)),
            child: Text(
                dateToString(dateTime: _selectedDate) ?? 'Select Due Date'),
          ),
          ElevatedButton(
            child: const Text("Save"),
            onPressed: () => Navigator.of(context).pop<Task>(Task(id: "", description: _controller.text, dueDate: _selectedDate)),
          ),
        ],
      ),
    );
  }
}