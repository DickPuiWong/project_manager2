import 'package:flutter/material.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/screens/wrapper.dart';
import 'package:project_manager/services/auth.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}