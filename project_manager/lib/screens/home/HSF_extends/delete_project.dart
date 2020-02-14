// Name : delete_project.dart
// Purpose : Enable user to delete project
// Function : To delete the selected project

import 'package:flutter/material.dart';
import 'package:project_manager/models/Project.dart';
import 'package:project_manager/screens/home/HSF_extends/delete_page/delete_List.dart';
import 'package:project_manager/services/database.dart';
import 'package:provider/provider.dart';

//DeleteProject class will return a stream provider of list of projects from Project class
class DeleteProject extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //The Scaffold widget here will display the app bar and DeleteList class as its body
    return StreamProvider<List<Project>>.value(
      value: DatabaseService().projects,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.red[600],
          title: Text('Tap To Delete Project'),
        ),
        body: DeleteList(),
      ),
    );
  }
}
