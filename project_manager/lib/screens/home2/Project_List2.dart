// Name : Project_List2.dart
// Purpose : to create or build a list of projects
// Function : This page will build a list of existing projects with all their details only for supervisor permission type

import 'package:flutter/material.dart';
import 'package:project_manager/models/Project.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/shared/project_tiles.dart';
import 'package:provider/provider.dart';

class ProjList2 extends StatefulWidget {
  @override
  _ProjList2State createState() => _ProjList2State();
}

class _ProjList2State extends State<ProjList2> {
  @override
  Widget build(BuildContext context) {
    final projects = Provider.of<List<Project>>(context);
    final userData = Provider.of<UserData>(context);
    List<Project> userProjList = [];

    for (int i = 0; i < userData.projList.length; i++) {
      for (int ii = 0; ii < projects.length; ii++) {
        if (projects[ii].projID == userData.projList[i]) {
          Project temp = projects[ii];
          userProjList.add(temp);
        }
      }
    }

    return ListView.builder(
      itemCount: userProjList.length,
      itemBuilder: (context, index) {
        return ProjTile(
          permission: userData.permissionType,
          proj: userProjList[index],
          num: index,
        );
      },
    );
  }
}
