// Name : Project_List.dart
// Purpose : to create or build a list of projects
// Function : This page will build a list of existing projects with all their details

import 'package:flutter/material.dart';
import 'package:project_manager/models/Project.dart';
import 'package:project_manager/shared/project_tiles.dart';
import 'package:provider/provider.dart';

class ProjList extends StatefulWidget {
  @override
  _ProjListState createState() => _ProjListState();
}

class _ProjListState extends State<ProjList> {
  @override
  Widget build(BuildContext context) {
    //declare and initialise object called projects which has provider of the list of projects from Project class
    final projects = Provider.of<List<Project>>(context);

    //ProjList class will return the list view builder widget that will build a list view of projects
    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) {
        //list view builder will return the ProjTile class which has all the project brief details
        return ProjTile(
          proj: projects[index],
          num: index,
        );
      },
    );
  }
}
