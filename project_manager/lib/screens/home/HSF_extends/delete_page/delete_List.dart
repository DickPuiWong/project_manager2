// Name : delete_List.dart
// Purpose : To enable user delete any project that has been created
// Function : This class will build the project provider and then return DeleteTile class

import 'package:flutter/material.dart';
import 'package:project_manager/models/Project.dart';
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

    //return the ListView builder widget and return the DeleteTile class
    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) {
        return DeleteTile(
          proj: projects[index],
          num: index,
        );
      },
    );
  }
}
