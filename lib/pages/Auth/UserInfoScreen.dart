import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/Auth/Auth.dart';
import '../../viewModels/profile_picture_notifier.dart';
import 'SignInScreen.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  late User _user;
  bool _isSigningOut = false;

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
          return Scaffold(
            appBar: AppBar(title: const Text('User Account')),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(),
                    profilePictureNotifierVM.exists == true
                        ? CircleAvatar(
                            backgroundImage:
                                MemoryImage(profilePictureNotifierVM.data!),
                          )
                        // ? ClipOval(
                        //     child: Material(
                        //       color: Colors.grey,
                        //       child: Image.memory(
                        //         profilePictureNotifierVM.data!,
                        //         fit: BoxFit.fitHeight,
                        //       ),
                        //     ),
                        //   )
                        : ClipOval(
                            child: Material(
                              color: Colors.grey.withOpacity(0.3),
                              child: const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Hello',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      _user.displayName!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '( ${_user.email!} )',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    _isSigningOut
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Colors.redAccent,
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              setState(() {
                                _isSigningOut = true;
                              });
                              await Auth.signOut();
                              setState(() {
                                _isSigningOut = false;
                              });
                              Navigator.of(context)
                                  .pushReplacement(_routeToSignInScreen());
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Text(
                                'Sign Out',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
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
