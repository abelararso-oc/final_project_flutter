import 'package:final_project_flutter/pages/Auth/SignInScreen.dart';
import 'package:final_project_flutter/pages/HomePage.dart';
import 'package:final_project_flutter/services/Auth/Auth.dart';
import 'package:final_project_flutter/viewModels/DashBoderViewModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  //_initAdMob();
  runApp(ChangeNotifierProvider(create: (context) => DashBordViewModel(), child: const MyApp()));
}

Future<void> _initAdMob() {
  return MobileAds.instance.initialize();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PRM',
      //debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueGrey,
          actionsIconTheme: IconThemeData(color: Colors.red),
        ),
        dividerColor: Colors.black,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(primary: Colors.lightBlueAccent)),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.orangeAccent,
            foregroundColor: Colors.black),
        inputDecorationTheme: const InputDecorationTheme(
          focusColor: Colors.black,
        ),
        listTileTheme: const ListTileThemeData(iconColor: Colors.greenAccent),
        primaryColor: Colors.red,
        scaffoldBackgroundColor: Colors.grey[50],
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.teal),
          textStyle: MaterialStateProperty.all(
              const TextStyle(fontWeight: FontWeight.bold)),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          minimumSize: MaterialStateProperty.all(const Size(400, 60)),
          foregroundColor: MaterialStateProperty.all(Colors.white),
        )),
        textTheme: const TextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        toggleableActiveColor: Colors.redAccent,
        unselectedWidgetColor: Colors.black,
        errorColor: Colors.red,
      ),
      home: const SignInScreen(),
    );
  }
}
