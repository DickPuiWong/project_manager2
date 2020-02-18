// Name : project_tiles.dart
// Purpose : to show the users the brief details of the projects
// Function : This page will display the brief details of the project

import 'package:flutter/material.dart';
import 'package:project_manager/models/Project.dart';
import 'package:project_manager/shared/Details/project_details.dart';

class ProjTile extends StatelessWidget {
  //object creation and assigned in ProjTile() class
  final Project proj;
  final int num;
  ProjTile({this.proj, this.num});

  @override
  Widget build(BuildContext context) {
    double estimateBudget() {
      double eb = 0;
      for (int i = 0; i < proj.budgetList.length; i++) {
        eb += proj.budgetList['bt${i + 1}']['estimate'];
      }
      return eb;
    }

    //ProjTile class will return Card widget to the home page
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.fromLTRB(10, 6, 10, 0),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: ListTile(
            dense: true,
            leading: Container(
              height: 45,
              width: 45,
              child: CircularProgressIndicator(
                strokeWidth: 9,
                value: (((proj.paintedArea / proj.totalSurfaceAreaP) +
                        (proj.blastedArea / proj.totalSurfaceAreaB)) /
                    2),
                backgroundColor: Colors.redAccent,
                valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.lightGreenAccent),
              ),
            ),
            title: Wrap(
              children: <Widget>[
                Text(
                  '${num + 1}. ',
                  style: TextStyle(fontSize: 21, color: Colors.black),
                ),
                Text(
                  proj.projname,
                  style: TextStyle(fontSize: 21, color: Colors.black),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Budget:RM ${estimateBudget().toStringAsFixed(2)}\nID: ${proj.projID}\nLocation: ${proj.location}',
                style: TextStyle(color: Colors.black),
              ),
            ),
//            trailing: Container(
//              width: 5,
//              color: Colors.lightGreenAccent,
//            ),

            //when user tap the project tile, they will be navigated to the project details in ProjectDetails()
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => ProjectDetails(
                    proj: proj,
                    num: num,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
