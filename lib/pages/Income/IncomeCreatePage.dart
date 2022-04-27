import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../model/Income.dart';
import '../../utils/date_converter.dart';
import '../../utils/string_validator.dart';
import '../../viewModels/DashBoderViewModel.dart';

class IncomeCreatePage extends StatefulWidget {
  const IncomeCreatePage({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _IncomeCreatePageState createState() => _IncomeCreatePageState();
}

class _IncomeCreatePageState extends State<IncomeCreatePage> {
  late User _user;
  final _formKey = GlobalKey<FormState>();
  DateTime today = DateTime.now();
  late DateTime _selectedDate = DateTime.now();

  final _amount = TextEditingController();
  String selectedValue = 'Salary';
  final String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final viewViewModel = Provider.of<DashBordViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Income Account')),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage, style: const TextStyle(color: Colors.red)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: _amount,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (input) => validateNonEmptyMessage(input),
                decoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.blue),
                    hintText: "Amount"),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: DropdownButtonFormField(
                  decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Colors.blue)),
                  validator: (value) =>
                      value == null ? "Select a country" : null,
                  dropdownColor: Colors.grey,
                  value: selectedValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                    });
                  },
                  items: dropdownItems),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: ElevatedButton(
                onPressed: () => showDatePicker(
                  context: context,
                  initialDate: today.add(const Duration(days: 3)),
                  firstDate: today,
                  lastDate: today.add(const Duration(days: 1000)),
                ).then((DateTime? value) =>
                    setState(() => _selectedDate = value!)),
                child: Text(
                    dateToString(dateTime: _selectedDate) ?? 'Select Due Date'),
              ),
            ),
            ElevatedButton(
                child: const Text('Add Income'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    var a = double.parse(_amount.text);

                    Navigator.of(context).pop<Income>(Income(
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
      const DropdownMenuItem(child: Text("Salary"), value: "Salary"),
      const DropdownMenuItem(child: Text("Other"), value: "Other")
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
