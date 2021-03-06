// Name : IDB.dart
// Purpose : This file contain all the functionality for the Budget aspect
// Function : Display, edit, add and delete the types of budget, spent and percentage of budget reached

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:project_manager/models/Project.dart';
import 'package:project_manager/services/database.dart';
import 'package:provider/provider.dart';

class IDBWrapper extends StatelessWidget {
  //create a Project object and assigned to IDBWrapper class
  final Project project;
  IDBWrapper({this.project});
  @override
  Widget build(BuildContext context) {
    //IDBWrapper returns stream provider of Project class where the value returned is the project ID
    //Then called the class IDB()
    return StreamProvider<Project>.value(
      value: ProjectDatabaseService(projID: project.projID).project,
      child: IDB(),
    );
  }
}

//IDB class show the table of budget and spending
class IDB extends StatefulWidget {
  @override
  _IDBState createState() => _IDBState();
}

class _IDBState extends State<IDB> {
  @override
  Widget build(BuildContext context) {
    final project = Provider.of<Project>(context);
    List<DataRow> dataRowList = [];

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

    for (int i = 0; i < project.budgetList.length; i++) {
      BudgetType ttt = new BudgetType(
        name: project.budgetList['bt${i + 1}']['name'],
        spent: project.budgetList['bt${i + 1}']['spent'].toDouble(),
        estimate: project.budgetList['bt${i + 1}']['estimate'].toDouble(),
      );
      dataRowList.add(DataRow(
        cells: [
          DataCell(
            Text(project.budgetList['bt${i + 1}']['name']),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return DataRowSetting(
                    num: (i + 1),
                    bt: ttt,
                    project: project,
                  );
                },
              );
            },
          ),
          DataCell(
            Text(
                '${(project.budgetList['bt${i + 1}']['spent']).toStringAsFixed(2)}'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return DataRowSetting(
                    num: (i + 1),
                    bt: ttt,
                    project: project,
                  );
                },
              );
            },
          ),
          DataCell(
            Text(
                '${project.budgetList['bt${i + 1}']['estimate'].toStringAsFixed(2)}'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return DataRowSetting(
                    num: (i + 1),
                    bt: ttt,
                    project: project,
                  );
                },
              );
            },
          ),
          DataCell(
            Text(((project.budgetList['bt${i + 1}']['spent']) /
                    (project.budgetList['bt${i + 1}']['estimate']) *
                    100)
                .toStringAsFixed(1)),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return DataRowSetting(
                    num: (i + 1),
                    bt: ttt,
                    project: project,
                  );
                },
              );
            },
          ),
          DataCell(
            Text(((project.budgetList['bt${i + 1}']['spent']) /
                    (esimateBudget()) *
                    100)
                .toStringAsFixed(1)),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return DataRowSetting(
                    num: (i + 1),
                    bt: ttt,
                    project: project,
                  );
                },
              );
            },
          ),
        ],
      ));
    }

    //This Scaffold functions as editor for the budget and expenditure
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              StreamProvider<Project>.value(
                            value:
                                ProjectDatabaseService(projID: project.projID)
                                    .project,
                            child: IDBSettings(),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Container(
                child: FAProgressBar(
                  borderRadius: 30,
                  size: 50,
                  currentValue: ((findPercent2() * 100).toInt()),
                  changeColorValue: 80,
                  maxValue: 100,
                  backgroundColor: Colors.grey[400],
                  progressColor: Colors.blueAccent,
                  changeProgressColor: Colors.redAccent,
                  displayText: '%',
                  direction: Axis.horizontal,
                ),
              ),
              SizedBox(height: 10),
              Column(
                children: <Widget>[
                  Text(
                    'Used : RM${spentBudget().toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Total : RM${esimateBudget().toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(
                thickness: 0.8,
                height: 10,
                color: Colors.indigo[900],
              ),
              Flexible(
                child: ListView(
                  children: <Widget>[
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 3),
                      child: DataTable(
                        columnSpacing: 30,
                        columns: [
                          DataColumn(label: Text('Types')),
                          DataColumn(
                            label: Text('Spent(RM)'),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Text('Estimate(RM)'),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Text('Spent/Estimate(%)'),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Text('Spent/Total(%)'),
                            numeric: true,
                          ),
                        ],
                        rows: dataRowList,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//DataRowSetting class will display the page where users update their budget
class DataRowSetting extends StatefulWidget {
  final int num;
  final BudgetType bt;
  final Project project;
  DataRowSetting({this.num, this.bt, this.project});
  @override
  _DataRowSettingState createState() => _DataRowSettingState();
}

class _DataRowSettingState extends State<DataRowSetting> {
  final _formKey = GlobalKey<FormState>();
  double _newSpent, _newEstimate;
  double _sptConst=100,_estConst=100;
  @override
  Widget build(BuildContext context) {
    double nullChecker(double one, double two) {
      if (one == null) {
        one = two;
      }
      return one;
    }

    return Form(
      key: _formKey,
      child: Dialog(
        child: Container(
          height: 350,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
          child: ListView(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      '${widget.bt.name}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Divider(
                height: 20,
                color: Colors.blueGrey[600],
              ),
              SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    flex: 3,
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.indigo[50],
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(3.5),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 12),
                                child: Text((_newSpent ?? widget.bt.spent)
                                    .toStringAsFixed(2)),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 12,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(2, 0, 4, 0),
                            color: Colors.white,
                            child: Text(
                              'Spent(RM)',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                      child: TextFormField(
                        style: TextStyle(fontSize: 14),
                        keyboardType: TextInputType.number,
                        initialValue: '$_sptConst' /*(1).toStringAsFixed(2)*/,
                        decoration: InputDecoration(
                          labelText: '+/-',
                          labelStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          hintText: 'RM',
                          isDense: true,
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.indigo[50], width: 2.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.indigo[900], width: 2.0)),
                        ),
                        validator: (val) =>
                        (val.isEmpty ? 'Enter amount' : null),
                        onChanged: (val) {
                          _sptConst = double.tryParse(val);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ButtonTheme(
                    minWidth: 45,
                    child: Tooltip(
                      message: 'revert to initial value',
                      child: FlatButton(
                        child: Icon(Icons.refresh),
                        onPressed: () {
                          setState(() {
                            _newSpent = widget.bt.spent;
                          });
                        },
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      ButtonTheme(
                        minWidth: 45,
                        child: Tooltip(
                          message: 'add',
                          child: FlatButton(
                            child: Icon(Icons.add),
                            onPressed: () {
                              _newSpent =
                                  nullChecker(_newSpent, widget.bt.spent);
                              setState(() {
                                _newSpent += _sptConst;
                              });
                            },
                          ),
                        ),
                      ),
                      ButtonTheme(
                        minWidth: 45,
                        child: Tooltip(
                          message: 'subtract',
                          child: FlatButton(
                            child: Icon(Icons.remove),
                            onPressed: () {
                              _newSpent =
                                  nullChecker(_newSpent, widget.bt.spent);
                              setState(() {
                                _newSpent -= _sptConst;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    flex: 3,
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.indigo[50],
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(3.5),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 12),
                                child: Text((_newEstimate ?? widget.bt.estimate)
                                    .toStringAsFixed(2)),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 12,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(2, 0, 4, 0),
                            color: Colors.white,
                            child: Text(
                              'Estimate(RM)',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                      child: TextFormField(
                        style: TextStyle(fontSize: 14),
                        keyboardType: TextInputType.number,
                        initialValue: '$_estConst' /*(1).toStringAsFixed(2)*/,
                        decoration: InputDecoration(
                          labelText: '+/-',
                          labelStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          hintText: 'RM',
                          isDense: true,
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.indigo[50], width: 2.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.indigo[900], width: 2.0)),
                        ),
                        validator: (val) =>
                        (val.isEmpty ? 'Enter amount' : null),
                        onChanged: (val) {
                          _estConst = double.tryParse(val);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ButtonTheme(
                    minWidth: 45,
                    child: Tooltip(
                      message: 'revert to initial value',
                      child: FlatButton(
                        child: Icon(Icons.refresh),
                        onPressed: () {
                          setState(() {
                            _newEstimate = widget.bt.estimate;
                          });
                        },
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      ButtonTheme(
                        minWidth: 45,
                        child: Tooltip(
                          message: 'add',
                          child: FlatButton(
                            child: Icon(Icons.add),
                            onPressed: () {
                              _newEstimate =
                                  nullChecker(_newEstimate, widget.bt.estimate);
                              setState(() {
                                _newEstimate += _estConst;
                              });
                            },
                          ),
                        ),
                      ),
                      ButtonTheme(
                        minWidth: 45,
                        child: Tooltip(
                          message: 'subtract',
                          child: FlatButton(
                            child: Icon(Icons.remove),
                            onPressed: () {
                              _newEstimate =
                                  nullChecker(_newEstimate, widget.bt.estimate);
                              setState(() {
                                _newEstimate -= _estConst;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 9),
              RaisedButton.icon(
                color: Colors.indigo[900],
                icon: Icon(
                  Icons.update,
                  color: Colors.white,
                ),
                label: Text(
                  'Update',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  Map listChanger() {
                    Map x = widget.project.budgetList;
                    for (int i = 0;
                        i < widget.project.budgetList.length;
                        i++) {
                      if ((i + 1) == widget.num) {
                        x['bt${i + 1}'] = {
                          'name': widget.bt.name,
                          'spent': (_newSpent ?? widget.bt.spent),
                          'estimate': (_newEstimate ?? widget.bt.estimate),
                        };
                      }
                    }
                    return x;
                  }

                  await Firestore.instance
                      .collection('projects')
                      .document(widget.project.projID)
                      .setData({
                    'blast pot': widget.project.blastPot,
                    'used abrasive weight': widget.project.abrasiveUsedWeight,
                    'total abrasive weight':
                        widget.project.abrasiveTotalWeight,
                    'used adhesive litres': widget.project.adhesiveUsedLitre,
                    'total adhesive litres':
                        widget.project.adhesiveTotalLitre,
                    'used paint litres': widget.project.paintUsedLitre,
                    'total paint litres': widget.project.paintTotalLitre,
                    'ID': widget.project.projID,
                    'name': widget.project.projname,
                    'location': widget.project.location,
                    'total area needed blasting':
                        widget.project.totalSurfaceAreaB,
                    'blasted area': widget.project.blastedArea,
                    'total area needed painting':
                        widget.project.totalSurfaceAreaP,
                    'painted area': widget.project.paintedArea,
                    'users assigned': widget.project.userAssigned,
                    'per fill': widget.project.perFill,
                    'blast pot list': widget.project.blastPotList,
                    'budget list': listChanger(),
                    'progresses tracked': widget.project.progressesTracked,
                    'Date Created': widget.project.date,
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IDBSettings extends StatefulWidget {
  @override
  _IDBSettingsState createState() => _IDBSettingsState();
}

class _IDBSettingsState extends State<IDBSettings> {
  bool canDelete = true;
  double x;
  @override
  Widget build(BuildContext context) {
    final project = Provider.of<Project>(context);

    List<Widget> cards = [];
    var _textState, _colorState, _colorState2;
    if (canDelete == false) {
      _textState = 'Disable Delete';
      _colorState = Colors.lightGreenAccent;
      _colorState2 = Colors.redAccent;
    } else {
      _textState = 'Enable Delete';
      _colorState = Colors.redAccent;
      _colorState2 = Colors.transparent;
    }

    for (int i = 0; i < project.budgetList.length; i++) {
      cards.add(
        Padding(
          padding: const EdgeInsets.all(5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2.6),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                      child: Text(
                    project.budgetList['bt${i + 1}']['name'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )),
                  Divider(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                              'Spent: RM${(project.budgetList['bt${i + 1}']['spent']).toStringAsFixed(2)}'),
                          SizedBox(height: 5),
                          Text(
                              'Estimate: RM${(project.budgetList['bt${i + 1}']['estimate']).toStringAsFixed(2)}'),
                        ],
                      ),
                      AbsorbPointer(
                        absorbing: canDelete,
                        child: IconButton(
                          icon: Icon(Icons.delete),
                          color: _colorState2,
                          onPressed: () async {
                            Map listChanger() {
                              Map temp = {};
                              int z = 1;
                              for (int ii = 0;
                                  ii < project.budgetList.length;
                                  ii++) {
                                if (ii != i) {
                                  temp['bt$z'] = {
                                    'name': project.budgetList['bt${ii + 1}']
                                        ['name'],
                                    'spent': project.budgetList['bt${ii + 1}']
                                        ['spent'],
                                    'estimate': project
                                        .budgetList['bt${ii + 1}']['estimate'],
                                  };
                                  z++;
                                }
                              }
                              return temp;
                            }

                            listChanger();

                            await Firestore.instance
                                .collection('projects')
                                .document(project.projID)
                                .setData({
                              'blast pot': project.blastPot,
                              'used abrasive weight':
                                  project.abrasiveUsedWeight,
                              'total abrasive weight':
                                  project.abrasiveTotalWeight,
                              'used adhesive litres': project.adhesiveUsedLitre,
                              'total adhesive litres':
                                  project.adhesiveTotalLitre,
                              'used paint litres': project.paintUsedLitre,
                              'total paint litres': project.paintTotalLitre,
                              'ID': project.projID,
                              'name': project.projname,
                              'location': project.location,
                              'total area needed blasting':
                                  project.totalSurfaceAreaB,
                              'blasted area': project.blastedArea,
                              'total area needed painting':
                                  project.totalSurfaceAreaP,
                              'painted area': project.paintedArea,
                              'users assigned': project.userAssigned,
                              'per fill': project.perFill,
                              'blast pot list': project.blastPotList,
                              'budget list': listChanger(),
                              'progresses tracked': project.progressesTracked,
                              'Date Created': project.date,
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.indigo[50],
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.file_upload),
                    onPressed: () async {},
                  ),
                ],
              ),
              Flexible(
                child: ListView(
                  children: cards,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0.0,
          color: Colors.indigo[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.add),
                label: Text('Add Type'),
                color: Colors.white,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AddType(project: project);
                    },
                  );
                },
              ),
              FlatButton.icon(
                icon: Icon(Icons.cancel),
                label: Text(_textState),
                color: _colorState,
                onPressed: () {
                  setState(() {
                    canDelete = !canDelete;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddType extends StatefulWidget {
  final Project project;
  AddType({this.project});
  @override
  _AddTypeState createState() => _AddTypeState();
}

class _AddTypeState extends State<AddType> {
  final _formKey = GlobalKey<FormState>();
  String _newName;
  double _newSpent, _newEstimate;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Dialog(
        child: Container(
          height: 320,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  'Add New Type',
                  style: TextStyle(fontSize: 22),
                ),
              ),
              Divider(
                height: 14,
                color: Colors.blueGrey,
              ),
              TextFormField(
                style: TextStyle(fontSize: 14),
                keyboardType: TextInputType.text,
                initialValue: (_newName ?? ''),
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 20),
                  labelText: 'Name',
                  hintText: 'A name for the new budget type',
                  isDense: true,
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.indigo[50], width: 2.0)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.indigo[900], width: 2.0)),
                ),
                validator: (val) => (val.isEmpty ? 'Enter amount' : null),
                onChanged: (val) {
                  _newName = val;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                style: TextStyle(fontSize: 14),
                keyboardType: TextInputType.number,
                initialValue: '${(_newSpent ?? '')}',
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 20),
                  labelText: 'Spent Budget',
                  hintText: 'RM',
                  isDense: true,
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.indigo[50], width: 2.0)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.indigo[900], width: 2.0)),
                ),
                validator: (val) => (val.isEmpty ? 'Enter amount' : null),
                onChanged: (val) {
                  _newSpent = double.tryParse(val);
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                style: TextStyle(fontSize: 14),
                keyboardType: TextInputType.number,
                initialValue: '${(_newEstimate ?? '')}',
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 20),
                  labelText: 'Estimated Budget',
                  hintText: 'RM',
                  isDense: true,
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.indigo[50], width: 2.0)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.indigo[900], width: 2.0)),
                ),
                validator: (val) => (val.isEmpty ? 'Enter amount' : null),
                onChanged: (val) {
                  _newEstimate = double.tryParse(val);
                },
              ),
              SizedBox(height: 20),
              Center(
                child: FlatButton(
                  color: Colors.indigo[900],
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  onPressed: () async {
                    Map listChanger() {
                      Map x = widget.project.budgetList;
                      int i = widget.project.budgetList.length;
                      x['bt${i + 1}'] = {
                        'name': _newName,
                        'spent': (_newSpent ?? 0),
                        'estimate': (_newEstimate ?? 0),
                      };
                      print(x['bt${i + 1}']);
                      return x;
                    }

                    await Firestore.instance
                        .collection('projects')
                        .document(widget.project.projID)
                        .setData({
                      'blast pot': widget.project.blastPot,
                      'used abrasive weight': widget.project.abrasiveUsedWeight,
                      'total abrasive weight':
                          widget.project.abrasiveTotalWeight,
                      'used adhesive litres': widget.project.adhesiveUsedLitre,
                      'total adhesive litres':
                          widget.project.adhesiveTotalLitre,
                      'used paint litres': widget.project.paintUsedLitre,
                      'total paint litres': widget.project.paintTotalLitre,
                      'ID': widget.project.projID,
                      'name': widget.project.projname,
                      'location': widget.project.location,
                      'total area needed blasting':
                          widget.project.totalSurfaceAreaB,
                      'blasted area': widget.project.blastedArea,
                      'total area needed painting':
                          widget.project.totalSurfaceAreaP,
                      'painted area': widget.project.paintedArea,
                      'users assigned': widget.project.userAssigned,
                      'per fill': widget.project.perFill,
                      'blast pot list': widget.project.blastPotList,
                      'budget list': listChanger(),
                      'progresses tracked': widget.project.progressesTracked,
                      'Date Created': widget.project.date,
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
