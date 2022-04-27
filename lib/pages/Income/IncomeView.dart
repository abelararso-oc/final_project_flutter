import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../model/Income.dart';
import '../../services/IncomeService.dart';
import '../../utils/date_converter.dart';
import '../HomePage.dart';
import 'IncomeCreatePage.dart';

class IncomeViewPage extends StatefulWidget {
  const IncomeViewPage({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _IncomeViewPageState createState() => _IncomeViewPageState();
}

class _IncomeViewPageState extends State<IncomeViewPage> {
  late User _user;
  final Future<List<Income>> _lncomeFuture = IncomeService.get();
  List<Income>? _lncome;

  Widget _toWidget(Income t) {
    return CheckboxListTile(
      title: Text(t.amount.toString()),
      subtitle: Text('${t.expanseCategory} ${dateToString(dateTime: t.date)}'),
      secondary: const Icon(Icons.attach_money, color: Colors.green),
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
    return FutureBuilder<List<Income>>(
      future: _lncomeFuture,
      builder: (context, snapshot) {
        _lncome = snapshot.hasData ? snapshot.data! : [];
        return Scaffold(
          appBar: AppBar(
            title: const Text('Income'),
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
                                .forEach(IncomeService.remove);
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
                  .push(MaterialPageRoute<Income>(
                      builder: (_) => IncomeCreatePage(
                            user: _user,
                          )))
                  .then((value) async {
                if (value != null && value is Income) {
                  final income = await IncomeService.insert(income: value);
                  setState(() => _lncome?.add(income));
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
