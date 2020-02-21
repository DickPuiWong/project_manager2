// Name : delete_List.dart
// Purpose : To enable user delete any project that has been created
// Function : This class will build the project provider and then return DeleteTile class

import 'package:flutter/material.dart';
import 'package:project_manager/models/Project.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/screens/home/HSF_extends/delete_page/delete_tiles.dart';
import 'package:provider/provider.dart';

class DeleteList extends StatefulWidget {
  @override
  _DeleteListState createState() => _DeleteListState();
}

class _DeleteListState extends State<DeleteList> {
  @override
  Widget build(BuildContext context) {
    //creation of the projects object and assigned it to provider of List of the Project class
    final projects = Provider.of<List<Project>>(context);
    final users = Provider.of<List<UserData>>(context);
    List<Project> orderByDate = [];

    for (int i = 0; i < projects.length; i++) {
      orderByDate.add(projects[i]);
      for (int ii = 1; ii < orderByDate.length; ii++) {
        if (orderByDate[i].date < orderByDate[ii - 1].date) {
          Project temp = orderByDate[ii - 1];
          orderByDate[ii - 1] = orderByDate[i];
          orderByDate[i] = temp;
        }
      }
    }



    //return the ListView builder widget and return the DeleteTile class
    return ListView.builder(
      itemCount: orderByDate.length,
      itemBuilder: (context, index) {
        return DeleteTile(
          users: users,
          proj: orderByDate[index],
          num: index,
        );
      },
    );
  }
}
