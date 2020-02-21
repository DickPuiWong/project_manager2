// Name : home.dart
// Purpose : to enable the user(admin) to see the homepage of the app based on their permission type
// Function : This page will display the project lists that is ongoing and enable the admin to add/delete the project, edit the details and test

import 'package:flutter/material.dart';
import 'package:project_manager/models/Project.dart';
import 'package:project_manager/screens/home/Project_List.dart';
import 'package:project_manager/screens/home/home_setting_form.dart';
import 'package:project_manager/services/auth.dart';
import 'package:project_manager/services/database.dart';
import 'package:provider/provider.dart';

//This Home class will be the class that display the home page for the user with the permission type of an admin
class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    //This function is to show the bottom sheet of the page where it calls HSF() that contains all the structures in it
    void _showHSFPanel() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return HSFWrapper();
        },
      );
    }

    //Home class will return a stream provider where it needs the list projects from Project class
    return StreamProvider<List<Project>>.value(
      value: DatabaseService().projects,
      child: Scaffold(
        backgroundColor: Colors.blue[50],

        //The appbar will be displaying the name of the page and also has a logout button
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text(
            'Project List (Admin)',
            style: TextStyle(fontSize: 19, color: Colors.white),
          ),
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
            ),
          ],
        ),

        //This floating action button will return the function _showHSFPanel where the modal bottom sheet will appear
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            return _showHSFPanel();
          },
          tooltip: 'Settings',
          child: Icon(
            Icons.menu,
            color: Colors.blue[900],
          ),
          backgroundColor: Colors.white,
        ),
        body: ProjList(),
//        Column(
//          children: <Widget>[
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Container(
//                color: Colors.white,
//                child: Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget>[
//                      Row(
//                        children: <Widget>[
//                          Container(
//                            color: Colors.lightGreenAccent,
//                            height: 17,
//                            width: 17,
//                          ),
//                          Text(
//                            ' Within Budget',
//                            style: TextStyle(color: Colors.black),
//                          ),
//                        ],
//                      ),
//                      SizedBox(height: 5),
//                      Row(
//                        children: <Widget>[
//                          Container(
//                            color: Colors.amberAccent,
//                            height: 17,
//                            width: 17,
//                          ),
//                          Text(
//                            ' Reaching Limit',
//                            style: TextStyle(color: Colors.black),
//                          ),
//                        ],
//                      ),
//                      SizedBox(height: 5),
//                      Row(
//                        children: <Widget>[
//                          Container(
//                            color: Colors.redAccent,
//                            height: 17,
//                            width: 17,
//                          ),
//                          Text(
//                            ' Over Limit',
//                            style: TextStyle(color: Colors.black),
//                          ),
//                        ],
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//            ),
//            Flexible(
//              child: ProjList(),
//            ),
//          ],
//        ),
      ),
    );
  }
}
