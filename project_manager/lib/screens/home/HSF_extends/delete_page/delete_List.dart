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
    final projects = Provider.of<List<Project>>(context);

    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) {
        return DeleteTile(proj: projects[index],num: index,);
      },
    );
  }
}
