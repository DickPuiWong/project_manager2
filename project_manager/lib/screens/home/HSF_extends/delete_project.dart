import 'package:flutter/material.dart';
import 'package:project_manager/models/Project.dart';
import 'package:project_manager/screens/home/HSF_extends/delete_page/delete_List.dart';
import 'package:project_manager/services/database.dart';
import 'package:provider/provider.dart';

class DeleteProject extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

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
