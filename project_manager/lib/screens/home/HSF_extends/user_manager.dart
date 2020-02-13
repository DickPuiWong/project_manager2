// Name : user_manager.dart
// Purpose : Enable user to view the users in the app
// Function : To display the users and their roles(manager or supervisor)

import 'package:flutter/material.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/screens/home/HSF_extends/UM_extend/user_list.dart';
import 'package:project_manager/services/database.dart';
import 'package:provider/provider.dart';

//UserManager class will return a stream provider of list of usersData from UserData class
class UserManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UserData>>.value(
      value: UsersDatabaseService().usersData,
      //The Scaffold widget here will display the app bar and UsersList class as its body
      child: Scaffold(
        backgroundColor: Colors.indigo[50],
        appBar: AppBar(
          backgroundColor: Colors.indigo[900],
          title: Text('User Manager'),
          actions: <Widget>[],
        ),
        body: UsersList(),
      ),
    );
  }
}
