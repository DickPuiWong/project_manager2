// Name : user_list.dart
// Purpose : To create a list of users
// Function : This class will build the project provider and then return UserTiles class

import 'package:flutter/material.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/screens/home/HSF_extends/UM_extend/userTiles.dart';
import 'package:provider/provider.dart';

class UsersList extends StatefulWidget {
  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  @override
  Widget build(BuildContext context) {
    //creation of the users object and assigned it to provider of List of the UserData class
    final users = Provider.of<List<UserData>>(context);

    //return the ListView builder widget and return the UserTiles class
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return UserTiles(
          currUser: users[index],
          index: index,
        );
      },
    );
  }
}
