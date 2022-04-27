import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Widget/AppDrawer.dart';
import '../model/Dashbord.dart';
import '../services/IncomeService.dart';
import '../viewModels/profile_picture_notifier.dart';
import 'Expanse/ExpanseView.dart';
import 'Income/IncomeView.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User _user;
  final Future<DashBord> _lncomeFuture = IncomeService.AllData();
  late DashBord _dashBord;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ProfilePictureNotifier(),
        builder: (context, _) {
          final profilePictureNotifierVM =
              Provider.of<ProfilePictureNotifier>(context);
          return FutureBuilder<DashBord>(
            future: _lncomeFuture,
            builder: (context, snapshot) {
              _dashBord = snapshot.hasData ? snapshot.data! : DashBord();
              return Scaffold(
                  drawer: AppDrawer(user: _user),
                  appBar: AppBar(title: const Text('Dashboard'), actions: [
                    if (profilePictureNotifierVM.exists)
                      CircleAvatar(
                        backgroundImage:
                            MemoryImage(profilePictureNotifierVM.data!),
                      )
                  ]),
                  body: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 2.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      padding: const EdgeInsets.all(3.0),
                      children: <Widget>[
                        makeDashboardItem(
                            'Monthly \n \$ ${_dashBord.amountI.toString()}',
                            Icons.arrow_circle_up_outlined,
                            Colors.green,
                            incomeViewPage),
                        makeDashboardItem(
                            "Expanse \n \$ ${_dashBord.amountE.toString()}",
                            Icons.arrow_circle_down_sharp,
                            Colors.red,
                            expanseViewPage),
                        makeDashboardItem(
                            "Savings \n \$ ${_dashBord.amountS.toString()}",
                            Icons.save,
                            Colors.green,
                            savings)
                      ],
                    ),
                  ));
            },
          );
        });
  }

  void incomeViewPage() {
    Route route =
        MaterialPageRoute(builder: (context) => IncomeViewPage(user: _user));
    Navigator.push(context, route);
  }

  void expanseViewPage() {
    Route route =
        MaterialPageRoute(builder: (context) => ExpanseViewPage(user: _user));
    Navigator.push(context, route);
  }

  void savings() {}

  Card makeDashboardItem(
      String title, IconData icon, Color color, VoidCallback f) {
    return Card(
        elevation: 1.0,
        margin: const EdgeInsets.all(8.0),
        child: Container(
          decoration:
              const BoxDecoration(color: Color.fromRGBO(220, 220, 220, 1.0)),
          child: InkWell(
            onTap: f,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                const SizedBox(height: 50.0),
                Center(
                    child: Icon(
                  icon,
                  size: 40.0,
                  color: color,
                )),
                const SizedBox(height: 20.0),
                Center(
                  child:
                  Text( title,
                      style:
                          const TextStyle(fontSize: 28.0, color: Colors.black)),
                )
              ],
            ),
          ),
        ));
  }

  @override
  void initState() {
    _user = widget._user;
    super.initState();
  }
}
