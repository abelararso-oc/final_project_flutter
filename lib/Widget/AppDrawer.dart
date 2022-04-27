import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/Auth/SignInScreen.dart';
import '../pages/Auth/UserInfoScreen.dart';
import '../pages/Expanse/ExpanseView.dart';
import '../pages/HomePage.dart';
import '../pages/Income/IncomeView.dart';
import '../services/Auth/Auth.dart';
import '../viewModels/profile_picture_notifier.dart';
import 'image_select_dialog.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _AppDrawer createState() => _AppDrawer();
}

class _AppDrawer extends State<AppDrawer> {
  late User _user;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ProfilePictureNotifier(),
        builder: (context, _) {
          final profilePictureNotifierVM =
              Provider.of<ProfilePictureNotifier>(context);
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    child: Stack(children: const <Widget>[
                      Positioned(
                          bottom: 5.0,
                          left: 4.0,
                          child: Text("Personal Money Management ",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500))),
                    ])),
                ListTile(
                  leading: const Icon(Icons.dashboard),
                  title: const Text('Dashboard'),
                  onTap: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => HomePage(user: _user)));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.account_circle_sharp),
                  title: profilePictureNotifierVM.exists
                      ? const Text('Update profile picture')
                      : const Text('Add profile picture'),
                  onTap: () async {
                    var result = await showModalBottomSheet(
                        context: context,
                        builder: (builder) {
                          return ImageSelectDialog();
                        });

                    profilePictureNotifierVM.updateProfilePicture(result);
                  },
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                ),
                ListTile(
                  leading: const Icon(Icons.attach_money, color: Colors.green),
                  title: const Text('Income'),
                  onTap: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => IncomeViewPage(user: _user)));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.attach_money, color: Colors.red),
                  title: const Text('Expanse'),
                  onTap: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => ExpanseViewPage(user: _user)));
                  },
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                ),
                ListTile(
                  leading: const Icon(Icons.account_circle_sharp),
                  title: const Text('Account'),
                  onTap: () async {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => UserInfoScreen(
                                  user: _user,
                                )))
                        .then((value) async {});
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    _user = widget._user;
    super.initState();
  }
}
