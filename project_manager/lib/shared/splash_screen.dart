// Name : splash_screen.dart
// Purpose : to show the splash screen
// Function : show the company logo with a blue background for 3 seconds

import 'package:flutter/material.dart';
import 'package:project_manager/screens/startup.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override

  //initState function which calls loadData() function
  void initState() {
    super.initState();

    loadData();
  }

  //loadData() function which set the duration to display the splash screen and then go to onDoneLoading() function
  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 3), onDoneLoading);
  }

  //onDoneLoading() function which will navigate to StartUp() function
  onDoneLoading() async {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => StartUp()));
  }

  //the content in SplashScreen() stateful widget
  //return a png image that will be display in the screen
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[900],
      ),
      child: Center(
        child: Image(
          image: AssetImage('assets/waterworthlogowhite.png'),
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
