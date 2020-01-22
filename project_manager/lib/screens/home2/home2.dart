import 'package:flutter/material.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/models/Project.dart';
import 'package:project_manager/screens/home2/Project_List2.dart';
import 'package:project_manager/services/database.dart';
import 'package:project_manager/services/auth.dart';
import 'package:provider/provider.dart';

class Home2 extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    return StreamProvider<List<Project>>.value(
      value: DatabaseService().projects,
      child: Scaffold(
        backgroundColor: Colors.indigo[50],
        appBar: AppBar(
          backgroundColor: Colors.indigo[900],
          title: Text('Project Manager'),
          actions: <Widget>[
            FlatButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(
                Icons.person_outline,
                color: Colors.white,
              ),
              label: Text('logout', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
        body: ProjList2(),
      ),
    );
  }
}
