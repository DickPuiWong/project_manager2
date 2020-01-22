import 'package:flutter/material.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/screens/authenticate/authenticate.dart';
import 'package:project_manager/screens/wrapper2.dart';
import 'package:project_manager/services/database.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return StreamProvider<UserData>.value(
        value: UserDataService(uid: user.uid).userData,
        child: Wrapper2(),
      );
    }
  }
}
