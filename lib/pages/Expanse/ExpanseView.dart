import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../model/Expense.dart';
import '../../services/ExpanseService.dart';
import '../../utils/date_converter.dart';
import '../HomePage.dart';
import 'ExpenseCreate.dart';

class ExpanseViewPage extends StatefulWidget {
  const ExpanseViewPage({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _ExpanseViewPageState createState() => _ExpanseViewPageState();
}

class _ExpanseViewPageState extends State<ExpanseViewPage> {
  late User _user;
  final Future<List<Expanse>> _lncomeFuture = ExpanseService.get();
  List<Expanse>? _lncome;

  Widget _toWidget(Expanse t) {
    return CheckboxListTile(
      title: Text(t.amount.toString()),
      subtitle: Text('${t.expanseCategory} ${dateToString(dateTime: t.date)}'),
      secondary: const Icon(Icons.attach_money, color: Colors.red),
      activeColor: Colors.blue,
      checkColor: Colors.white,
      value: t.isCompleted,
      onChanged: (bool? newValue) {
        setState(() {
          t.isCompleted = newValue ?? false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Expanse>>(
      future: _lncomeFuture,
      builder: (context, snapshot) {
        _lncome = snapshot.hasData ? snapshot.data! : [];
        return Scaffold(
          appBar: AppBar(
            title: const Text('Expanse'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () =>  Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => HomePage(user: _user))),
            ),
            actions: _lncome!.any((element) => element.isCompleted == true)
                ? [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _lncome
                                ?.where((task) => task.isCompleted)
                                .forEach(ExpanseService.remove);
                            setState(() {
                              _lncome?.removeWhere((task) => task.isCompleted);
                            });
                          });
                        },
                        icon: const Icon(Icons.delete))
                  ]
                : [],
          ),
          body: ListView.separated(
            itemBuilder: (_, index) {
              return _toWidget(_lncome![index]);
            },
            separatorBuilder: (_, __) => const Divider(),
            itemCount: _lncome!.length,
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute<Expanse>(
                      builder: (_) => ExpenseCreatePage(
                            user: _user,
                          )))
                  .then((value) async {
                if (value != null && value is Expanse) {
                  final income = await ExpanseService.insert(expanse: value);
                  setState(() {
                    _lncome?.add(income);
                  });
                }
              });
            },
          ),
        );
      },
    );
  }

  @override
  void initState() {
    _user = widget._user;
    super.initState();
  }
}
