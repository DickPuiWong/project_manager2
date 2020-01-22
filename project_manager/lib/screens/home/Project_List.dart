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
    final projects = Provider.of<List<Project>>(context);

    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) {
        return ProjTile(
          proj: projects[index],
          num: index,
        );
      },
    );
  }
}
