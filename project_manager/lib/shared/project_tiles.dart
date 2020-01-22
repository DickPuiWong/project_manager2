import 'package:flutter/material.dart';
import 'package:project_manager/models/Project.dart';
import 'package:project_manager/shared/Details/project_details.dart';

class ProjTile extends StatelessWidget {
  final Project proj;
  final int num;
  ProjTile({this.proj, this.num});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Card(
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
                  style: TextStyle(fontSize: 21),
                ),
                Text(
                  proj.projname,
                  style: TextStyle(fontSize: 21),
                ),
              ],
            ),
            subtitle: Text('Budget:RM ${proj.budget.toStringAsFixed(2)}\nID: ${proj.projID}\nLOCATION: ${proj.location}'),
            trailing: Container(
              width: 10,
              color: Colors.lightGreenAccent,
            ),
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
