import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_manager/models/Project.dart';
import 'package:project_manager/shared/Details/IDB.dart';
import 'package:project_manager/shared/Details/IDM.dart';
import 'package:project_manager/shared/Details/IDP.dart';
import 'package:project_manager/shared/Details/IDS.dart';
import 'package:project_manager/services/database.dart';
import 'package:provider/provider.dart';
import 'package:project_manager/shared/Details/detail_settings.dart';

//This ProjectDetails class contains all the main aspect that has the information of the project
class ProjectDetails extends StatelessWidget {
  //object creation and initialised into the class ProjectDetails()
  final Project proj;
  final num;
  ProjectDetails({this.proj, this.num});

  @override
  Widget build(BuildContext context) {
    //the class will return a stream provider of class Project
    return StreamProvider<Project>.value(
      value: ProjectDatabaseService(projID: proj.projID).project,
      child: Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Center(child: Text('Project Details')),
          actions: <Widget>[
            AppbarButtons(),
          ],
        ),

        //the body of this Scaffold will be showing the ListView of the extended details from PDExtend() class
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
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => DSP(
              proj: project,
            ),
          ),
        );
      },
      icon: Icon(
        Icons.edit,
        color: Colors.white,
        size: 18,
      ),
      label: Text(
        'Edit',
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}

//PDExtend class is the class that contains structure of all the main aspect involved
class PDExtend extends StatefulWidget {
  //object creation and initialised in the PDExtend() class
  final int num;
  PDExtend({this.num});
  @override
  _PDExtendState createState() => _PDExtendState();
}

class _PDExtendState extends State<PDExtend> {
  @override
  Widget build(BuildContext context) {
    //declare and initialise the object project and assigned it to the provider of Project() class contexts
    final project = Provider.of<Project>(context);

    double findPercent1() {
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

    double spentBudget() {
      double sb = 0;
      for (int i = 0; i < project.budgetList.length; i++) {
        sb += project.budgetList['bt${i + 1}']['spent'];
      }
      return sb;
    }

    double esimateBudget() {
      double eb = 0;
      for (int i = 0; i < project.budgetList.length; i++) {
        eb += project.budgetList['bt${i + 1}']['estimate'];
      }
      return eb;
    }

    double findPercent2() {
      double percent;
      double _totalDone = 0, _totalOverall = 0;
      for (int i = 0; i < project.budgetList.length; i++) {
        _totalDone += spentBudget();
        _totalOverall += esimateBudget();
      }
      percent = _totalDone / _totalOverall;
      if (_totalDone == 0 && _totalOverall == 0) {
        percent = 0;
      }
      return percent;
    }

    //return the Column widget
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 25, 5, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //Contain the information of date of creation,project name,location and supervisor in charge
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Text(
                    'Date created: ${DateTime.fromMillisecondsSinceEpoch(project.date)}',
                    style: TextStyle(
                      fontSize: 10.0,
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Project Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      '${widget.num + 1}. ${project.projname}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Divider(
                    height: 40,
                    color: Colors.blue[300],
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Text(
                              'Project Location',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              project.location,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Divider(
                            height: 60,
                            color: Colors.blue[300],
                          ),
                          Center(
                            child: Text(
                              'Supervisor',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              project.userAssigned[0],
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),

          //This Container widget contains the work progress aspect
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        color: Colors.white,
                        child: Center(
                          child: Container(
                            height: 240,
                            width: 240,
                            child: Stack(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 65,
                                      ),
                                      Text(
                                        '${(findPercent1() * 100).toInt()}%',
                                        style: TextStyle(fontSize: 50),
                                      ),
                                      Text(
                                        'Work Completed',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 240,
                                  width: 240,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 12,
                                    value: findPercent1(),
                                    backgroundColor: Colors.redAccent,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.lightGreenAccent),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Work Progress Tracker',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                                children: [
                                  TextSpan(
                                    text:
                                        ' ${(findPercent1() * 100).toInt()}%\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 35,
                                    ),
                                  ),
                                  TextSpan(text: '  Completion'),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.chevron_right),
                              onPressed: () async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            IDPWrapper(
                                              project: project,
                                            )));
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 40),

          //this container contains the budget aspect
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 50),
                        color: Colors.white,
                        child: Center(
                          child: Container(
                            height: 240,
                            width: 240,
                            child: Stack(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 65,
                                      ),
                                      Text(
                                        '${(findPercent2() * 100).toInt()}%',
                                        style: TextStyle(fontSize: 50),
                                      ),
                                      Text(
                                        'Expenditure',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 240,
                                  width: 240,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 12,
                                    value: findPercent2(),
                                    backgroundColor: Colors.redAccent,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.lightGreenAccent),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Budget',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ],
                  ),
                  Divider(
                    height: 30,
                    color: Colors.blue[300],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
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
                                          '${spentBudget().toStringAsFixed(2)}',
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
                                    TextSpan(text: 'Estimated :RM '),
                                    TextSpan(
                                      text:
                                          '${esimateBudget().toStringAsFixed(2)}',
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
                  ),
                ],
              ),
            ),
          ),
//          Divider(
//            height: 34,
//            color: Colors.indigo[600],
//          ),
          SizedBox(height: 40),

          //this Container contains the blast pot and material usage aspect
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  ExpansionTile(
                    title: Center(
                      child: Text(
                        'Blast Pots & Material Usage',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
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
                                DataCell(Text('litres')),
                                DataCell(Text((project.adhesiveTotalLitre)
                                    .toStringAsFixed(1))),
                                DataCell(Text((project.adhesiveUsedLitre)
                                    .toStringAsFixed(1))),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(Text('paint')),
                                DataCell(Text('litres')),
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
                    label: Text('More Details'),
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
          SizedBox(
            height: 40,
          ),

          //this Container contains the staff related aspect
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Assigned Staffs',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  ListTile(
                    title: Center(
                      child: Text(
                        'Zac',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    subtitle: Center(child: Text('Supervisor')),
                  ),
                  Container(
                    child: FlatButton.icon(
                      icon: Icon(Icons.people),
                      label: Text('Staffs'),
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
        ],
      ),
    );
  }
}
