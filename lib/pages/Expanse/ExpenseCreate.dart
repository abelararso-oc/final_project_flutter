import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../model/Expense.dart';
import '../../services/ExpanseService.dart';
import '../../utils/date_converter.dart';
import '../../utils/string_validator.dart';
import '../HomePage.dart';

class ExpenseCreatePage extends StatefulWidget {
  const ExpenseCreatePage({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _ExpenseCreatePageState createState() => _ExpenseCreatePageState();
}

class _ExpenseCreatePageState extends State<ExpenseCreatePage> {
  late User _user;
  final _formKey = GlobalKey<FormState>();
  DateTime today = DateTime.now();
  late DateTime _selectedDate = DateTime.now();

  final _amount = TextEditingController();
  String selectedValue = 'Food';
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expense Account')),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage, style: const TextStyle(color: Colors.red)),
            TextFormField(
              controller: _amount,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (input) => validateNonEmptyMessage(input),
              decoration: const InputDecoration(hintText: "Amount"),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
            ),
            ElevatedButton(
              onPressed: () => showDatePicker(
                context: context,
                initialDate: today.add(const Duration(days: 3)),
                firstDate: today,
                lastDate: today.add(const Duration(days: 1000)),
              ).then(
                  (DateTime? value) => setState(() => _selectedDate = value!)),
              child: Text(
                  dateToString(dateTime: _selectedDate) ?? 'Select Due Date'),
            ),
            DropdownButtonFormField(
                validator: (value) => value == null ? "Select a country" : null,
                dropdownColor: Colors.grey,
                value: selectedValue,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue!;
                  });
                },
                items: dropdownItems),
            ElevatedButton(
                child: const Text('Add Expense'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    var a = double.parse(_amount.text);

                    Navigator.of(context).pop<Expanse>(Expanse(
                        amount: a,
                        date: _selectedDate,
                        expanseCategory: selectedValue));
                  }
                }),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(child: Text("Gas"), value: "Gas"),
      const DropdownMenuItem(child: Text("Food"), value: "Food")
    ];
    return menuItems;
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _user = widget._user;
    super.initState();
  }
}
