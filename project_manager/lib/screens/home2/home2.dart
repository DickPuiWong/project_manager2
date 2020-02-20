// Name : home2.dart
// Purpose : to enable the user(supervisor) to see the homepage of the app based on their permission type
// Function : This page will display the project lists that is ongoing

import 'package:flutter/material.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/models/Project.dart';
import 'package:project_manager/screens/home2/Project_List2.dart';
import 'package:project_manager/services/database.dart';
import 'package:project_manager/services/auth.dart';
import 'package:provider/provider.dart';

//Home2 class is the same with Home class but limited functionality because of the permission type of normal supervisor
class Home2 extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    //Creation of userData object by assigning to the provider from UserData class

    //Home2 class return a stream provider of the list of projects from Project class
    return StreamProvider<List<Project>>.value(
      value: DatabaseService().projects,
      child: Scaffold(
        backgroundColor: Colors.blue[50],

        //The app bar will be displaying the name of the page and logout button
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text('Project List'),
          actions: <Widget>[
            FlatButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              label: Text('logout', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
        //The body of the page will be from the class ProjList2()
        body: ProjList2(),
      ),
    );
  }
}
