// Name : wrapper2.dart
// Purpose : to check the user's permission type such as admin or worker
// Function :

import 'package:flutter/material.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/screens/home/home.dart';
import 'package:project_manager/screens/home2/home2.dart';
import 'package:provider/provider.dart';

class Wrapper2 extends StatefulWidget {
  @override
  _Wrapper2State createState() => _Wrapper2State();
}

class _Wrapper2State extends State<Wrapper2> {
  int type;
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    type = userData.permissionType;

    if (type == null) {
      type = 2;
    }
    if (type == 1) {
      return Home();
    } else if (type == 2) {
      return Home2();
    }
  }
}
