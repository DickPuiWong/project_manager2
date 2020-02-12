//File name : main.dart
//Purpose : root of the app or to start the app
//Function : Display a splash screen on the phone when user open the app

import 'package:flutter/material.dart';
import 'package:project_manager/shared/splash_screen.dart';

//main function that will run the app by calling the MyApp function
void main() => runApp(MyApp());

//MyApp function will return a MaterialApp function which will display SplashScreen() widget when user first open the app
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}
