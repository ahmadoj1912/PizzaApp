import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:get/get.dart';
import './screens/add_pizza_screen.dart';
import './screens/auth_screen.dart';
import './screens/home.dart';

//import '../screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;

    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: AddPizzaScreen.routeName, page: () => AddPizzaScreen()),
      ],
      theme: ThemeData(
          textTheme: ThemeData.light().textTheme.copyWith(
              headline1: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
              headline2: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              headline3: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
              headline4: TextStyle(
                  color: Colors.orange,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          primarySwatch: Colors.orange,
          accentColor: Colors.redAccent[50]),
      home: StreamBuilder(
          stream: auth.authStateChanges(),
          builder: (context, userSnapShot) {
            if (userSnapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text('...Loading'),
              );
            }
            if (userSnapShot.hasData) {
              if (userSnapShot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Home();
            } else {
              return AuthScreen();
            }
          }),
    );
  }
}
