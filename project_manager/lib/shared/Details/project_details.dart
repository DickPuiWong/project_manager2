import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_manager/models/Project.dart';
import 'package:project_manager/shared/Details/IDB.dart';
import 'package:project_manager/shared/Details/IDM.dart';
import 'package:project_manager/shared/Details/IDP.dart';
import 'package:project_manager/shared/Details/IDS.dart';
import 'package:project_manager/shared/Details/detail_settings.dart';
import 'package:project_manager/services/database.dart';
import 'package:provider/provider.dart';

class ProjectDetails extends StatelessWidget {
  final Project proj;
  final num;
  ProjectDetails({this.proj, this.num});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<Project>.value(
      value: ProjectDatabaseService(projID: proj.projID).project,
      child: Scaffold(
        backgroundColor: Colors.indigo[50],
        appBar: AppBar(
          backgroundColor: Colors.indigo[900],
          title: Text('Project Details'),
          actions: <Widget>[
            AppbarButtons(),
          ],
        ),
        body: ListView(
          children: <Widget>[
            PDExtend(
              num: num,
            ),
          ],
        ),
      ),
    );
  }
}

class AppbarButtons extends StatefulWidget {
  @override
  _AppbarButtonsState createState() => _AppbarButtonsState();
}

class _AppbarButtonsState extends State<AppbarButtons> {
  @override
  Widget build(BuildContext context) {
    final project = Provider.of<Project>(context);
    return FlatButton.icon(
      onPressed: () async {
//        await Navigator.push(
//          context,
//          MaterialPageRoute(
//            builder: (BuildContext context) => DSP(
//              proj: project,
//            ),
//          ),
//        );
      },
      icon: Icon(
        Icons.edit,
        color: Colors.white,
      ),
      label: Text(
        'Edit',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class PDExtend extends StatefulWidget {
  final int num;
  PDExtend({this.num});
  @override
  _PDExtendState createState() => _PDExtendState();
}

class _PDExtendState extends State<PDExtend> {
  @override
  Widget build(BuildContext context) {
    final project = Provider.of<Project>(context);
    double findPercent() {
      double percent;
      double _totalDone = 0, _totalOverall = 0;
      for (int i = 0; i < project.progressesTracked.length; i++) {
        _totalDone += project.progressesTracked['pt${i + 1}']['done'];
        _totalOverall += project.progressesTracked['pt${i + 1}']['total'];
      }
      percent = _totalDone / _totalOverall;
      if (_totalDone == 0 && _totalOverall == 0) {
        percent = 0;
      }
      return percent;
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(5, 25, 5, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Text(
                      'Date created: ${DateTime.fromMillisecondsSinceEpoch(project.date)}'),
                  SizedBox(height: 12),
                  Text(
                    '${widget.num + 1}. ${project.projname}',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Text(
                              'Location',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24),
                            ),
                          ),
                          Text(
                            project.location,
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 34,
                    color: Colors.indigo[600],
                  ),
                  Container(
                    height: 10,
                    child: LinearProgressIndicator(
                      value:
                      (((project.paintedArea / project.totalSurfaceAreaP) +
                          (project.blastedArea /
                              project.totalSurfaceAreaB)) /
                          2),
                      backgroundColor: Colors.redAccent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.lightGreenAccent[400]),
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 20, color: Colors.black),
                          children: [
                            TextSpan(
                              text: '${(findPercent() * 100).toInt()}%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 44,
                              ),
                            ),
                            TextSpan(text: ' Completion'),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.chevron_right),
                        onPressed: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => IDPWrapper(
                                    project: project,
                                  )));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 34),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        'BUDGET',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  color: Colors.lightGreenAccent,
                                  height: 17,
                                  width: 17,
                                ),
                                Text(' Within Budget'),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: <Widget>[
                                Container(
                                  color: Colors.amberAccent,
                                  height: 17,
                                  width: 17,
                                ),
                                Text(' Reaching Limit'),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: <Widget>[
                                Container(
                                  color: Colors.redAccent,
                                  height: 17,
                                  width: 17,
                                ),
                                Text(' Over Limit'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ListTile(
                    leading: Container(
                      color: Colors.lightGreenAccent,
                      height: 35,
                      width: 35,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black),
                                children: [
                                  TextSpan(text: 'Spent :RM '),
                                  TextSpan(
                                    text:
                                    '${project.spentBudget.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black),
                                children: [
                                  TextSpan(text: 'Total  :RM '),
                                  TextSpan(
                                    text:
                                    '${project.budget.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.chevron_right),
                      color: Colors.black,
                      onPressed: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => IDBWrapper(
                                  project: project,
                                )));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: 34,
            color: Colors.indigo[600],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Assigned Staffs',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Zac',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Text('Supervisor'),
                  ),
                  Container(
                    child: FlatButton.icon(
                      icon: Icon(Icons.people),
                      label: Text('Other Staffs'),
                      onPressed: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    IDSWrapper(project: project)));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 34),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  ExpansionTile(
                    title: Text(
                      'Materials',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                        color: Colors.grey[100],
                        child: DataTable(
                          columnSpacing: 30,
                          columns: [
                            DataColumn(label: Text('Type')),
                            DataColumn(label: Text('Unit')),
                            DataColumn(label: Text('Total')),
                            DataColumn(label: Text('Used')),
                          ],
                          rows: [
                            DataRow(
                              cells: [
                                DataCell(Text('abrasive')),
                                DataCell(Text('kg')),
                                DataCell(Text((project.abrasiveTotalWeight)
                                    .toStringAsFixed(1))),
                                DataCell(Text((project.abrasiveUsedWeight)
                                    .toStringAsFixed(1))),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(Text('adhesive')),
                                DataCell(Text('L')),
                                DataCell(Text((project.adhesiveTotalLitre)
                                    .toStringAsFixed(1))),
                                DataCell(Text((project.adhesiveUsedLitre)
                                    .toStringAsFixed(1))),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(Text('paint')),
                                DataCell(Text('L')),
                                DataCell(Text((project.paintTotalLitre)
                                    .toStringAsFixed(1))),
                                DataCell(Text((project.paintUsedLitre)
                                    .toStringAsFixed(1))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  FlatButton.icon(
                    icon: Icon(Icons.build),
                    label: Text(' Material Details'),
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => IDMWrapper(
                                project: project,
                              )));
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}