// Name : userTiles.dart
// Purpose : To enable user delete any project that has been created
// Function : This file contains all the structure that will ask for confirmation from the user if they want to delete the project or not

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_manager/models/user.dart';

//UserTiles class will run a function call _showBottomPanel that will
class UserTiles extends StatelessWidget {
  final UserData currUser;
  final int index;
  UserTiles({this.currUser, this.index});

  @override
  Widget build(BuildContext context) {
    //Function _showBottomPanel which will display a modal bottom sheet and return PrivilegeSheet function
    void _showBottomPanel() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return PrivilegeSheet(
            user: currUser,
          );
        },
      );
    }

    //This Card widget will display all the user name and their permission type
    return Padding(
      padding: EdgeInsets.all(5),
      child: Card(
        elevation: 0.0,
        child: Container(
          child: ListTile(
            dense: true,
            onTap: () {},
            onLongPress: () {
              return _showBottomPanel();
            },
            leading: Container(
              height: 60,
              width: 60,
              child: CircleAvatar(
                backgroundColor: Colors.blueGrey,
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  currUser.userName,
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            subtitle: Text(
              currUser.permissionType.toString(),
            ),
            trailing: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  }
}

//PrivilegeSheet class will show the buttons and slider for the bottom sheet part when user long pressed the user card
class PrivilegeSheet extends StatefulWidget {
  final UserData user;
  PrivilegeSheet({this.user});
  @override
  _PrivilegeSheetState createState() => _PrivilegeSheetState();
}

class _PrivilegeSheetState extends State<PrivilegeSheet> {
  final _formKey = GlobalKey<FormState>();
  int _newPermissionType;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Text(
              'User Privilage Setup',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 25),
            Flexible(
              child: ListView(
                children: <Widget>[
                  Center(
                      child: Text('Privilage Type',
                          style: TextStyle(fontSize: 17))),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Manager'),
                      Text('Supervisor'),
                    ],
                  ),
                  Slider(
                    value: (_newPermissionType ?? widget.user.permissionType)
                        .toDouble(),
                    activeColor: Colors.indigo[300],
                    inactiveColor: Colors.indigo[900],
                    min: 1,
                    max: 2,
                    divisions: 1,
                    onChanged: (val) {
                      setState(() => (_newPermissionType = val.round()));
                    },
                  ),
                ],
              ),
            ),
            Container(
              child: FlatButton(
                onPressed: () {
                  Firestore.instance
                      .collection('UserData')
                      .document(widget.user.uid)
                      .setData({
                    'ID': widget.user.uid,
                    'Username': widget.user.userName,
                    'permissionType': _newPermissionType,
                    'projList': widget.user.projList,
                  });
                },
                child: Text('Confirm Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
