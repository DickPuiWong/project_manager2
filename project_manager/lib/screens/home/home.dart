import 'package:flutter/material.dart';
import 'package:project_manager/models/Project.dart';
import 'package:project_manager/screens/home/Project_List.dart';
import 'package:project_manager/screens/home/home_setting_form.dart';
import 'package:project_manager/services/auth.dart';
import 'package:project_manager/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    void _showHSFPanel() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return HSF();
        },
      );
    }

    return StreamProvider<List<Project>>.value(
      value: DatabaseService().projects,
      child: Scaffold(
        backgroundColor: Colors.indigo[50],
        appBar: AppBar(
          backgroundColor: Colors.indigo[900],
          title: Text('Admin Project Manager'),
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
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            return _showHSFPanel();
          },
          tooltip: 'Settings Menu',
          child: Icon(Icons.menu),
          backgroundColor: Colors.indigo[900],
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        color: Colors.lightGreenAccent,
                        height: 17,
                        width: 17,
                      ),
                      Text(' Within Budget'),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Container(
                        color: Colors.amberAccent,
                        height: 17,
                        width: 17,
                      ),
                      Text(' Reaching Limit'),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Container(
                        color: Colors.redAccent,
                        height: 17,
                        width: 17,
                      ),
                      Text(' Over Limit'),
                    ],
                  ),
                ],
              ),
            ),
            Flexible(
              child: ProjList(),
            ),
          ],
        ),
      ),
    );
  }
}
