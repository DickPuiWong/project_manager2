import 'package:flutter/material.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/screens/home/HSF_extends/UM_extend/user_list.dart';
import 'package:project_manager/services/database.dart';
import 'package:provider/provider.dart';

class UserManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UserData>>.value(
      value: UsersDatabaseService().usersData,
      child: Scaffold(
        backgroundColor: Colors.indigo[50],
        appBar: AppBar(
          backgroundColor: Colors.indigo[900],
          title: Text('User Manager'),
          actions: <Widget>[
          ],
        ),
        body: UsersList(),
      ),
    );
  }
}
