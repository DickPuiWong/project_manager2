// Name : IDP.dart
// Purpose :
// Function :

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_manager/models/Project.dart';
import 'package:project_manager/services/database.dart';
import 'package:provider/provider.dart';
import 'package:project_manager/shared/constants.dart';

class IDPWrapper extends StatelessWidget {
  final Project project;
  IDPWrapper({this.project});
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Project>.value(
      value: ProjectDatabaseService(projID: project.projID).project,
      child: IDP(),
    );
  }
}

class IDP extends StatefulWidget {
  @override
  _IDPState createState() => _IDPState();
}

class _IDPState extends State<IDP> {
  List<bool> selectedRowList = [];
  bool wtd = false;
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    final project = Provider.of<Project>(context);

    double errorAvoider(double one, double two) {
      double x;
      if (two == 0) {
        x = 0;
      } else {
        x = one / two;
      }
      return x;
    }

    void setSelected(bool a, int index) async {
      setState(() {
        if (a == true) {
          selectedRowList[index] = true;
          selected++;
        } else {
          selectedRowList[index] = false;
          selected--;
        }
      });
    }

    Function showCheckBox(int num) {
      Function functionX;
      if (wtd == true) {
        functionX = ((x) {
          setSelected(x, num);
        });
      }
      return functionX;
    }

    List<DataRow> generatorX() {
      List<DataRow> dataRowList = [];
      for (int i = 0; i < project.progressesTracked.length; i++) {
        ProgressType temp = new ProgressType(
          name: project.progressesTracked['pt${i + 1}']['name'] ?? 'error',
          done:
              project.progressesTracked['pt${i + 1}']['done'].toDouble() ?? 0.0,
          total: project.progressesTracked['pt${i + 1}']['total'].toDouble() ??
              0.0,
        );
        if (selectedRowList.length < project.progressesTracked.length) {
          selectedRowList.add(false);
        }
        dataRowList.add(
          DataRow(
            selected: selectedRowList[i],
            onSelectChanged: showCheckBox(i),
            cells: [
              DataCell(
                Text(project.progressesTracked['pt${i + 1}']['name']),
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return IDPRowSetting(
                        num: (i + 1),
                        project: project,
                        pt: temp,
                      );
                    },
                  );
                },
              ),
              DataCell(
                Text(
                    '${((errorAvoider(project.progressesTracked['pt${i + 1}']['done'], project.progressesTracked['pt${i + 1}']['total']) * 100)).toInt()}'),
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return IDPRowSetting(
                        num: (i + 1),
                        project: project,
                        pt: temp,
                      );
                    },
                  );
                },
              ),
              DataCell(
                Text(
                    '${project.progressesTracked['pt${i + 1}']['done'].toStringAsFixed(1)}'),
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return IDPRowSetting(
                        num: (i + 1),
                        project: project,
                        pt: temp,
                      );
                    },
                  );
                },
              ),
              DataCell(
                Text(
                    '${project.progressesTracked['pt${i + 1}']['total'].toStringAsFixed(1)}'),
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return IDPRowSetting(
                        num: (i + 1),
                        project: project,
                        pt: temp,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      }
      return dataRowList;
    }

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

    Widget bottomButtonsSwitcher() {
      Widget bottomButtons;
      if (wtd == false) {
        bottomButtons = Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton(
              child: Text('Add Field'),
              onPressed: () async {
                Map listChanger() {
                  Map x = project.progressesTracked;
                  x['pt${project.progressesTracked.length + 1}'] = {
                    'name': 'filename',
                    'done': 0.0,
                    'total': 0.0,
                  };
                  return x;
                }

                await Firestore.instance
                    .collection('projects')
                    .document(project.projID)
                    .setData({
                  'blast pot': project.blastPot,
                  'used abrasive weight': project.abrasiveUsedWeight,
                  'total abrasive weight': project.abrasiveTotalWeight,
                  'used adhesive litres': project.adhesiveUsedLitre,
                  'total adhesive litres': project.adhesiveTotalLitre,
                  'used paint litres': project.paintUsedLitre,
                  'total paint litres': project.paintTotalLitre,
                  'ID': project.projID,
                  'name': project.projname,
                  'location': project.location,
                  'total area needed blasting': project.totalSurfaceAreaB,
                  'blasted area': project.blastedArea,
                  'total area needed painting': project.totalSurfaceAreaP,
                  'painted area': project.paintedArea,
                  'users assigned': project.userAssigned,
                  'blast pot list': project.blastPotList,
                  'budget list': project.budgetList,
                  'progresses tracked': listChanger(),
                  'Date Created': project.date,
                });
              },
            ),
            FlatButton(
              child: Text('Manage Delete'),
              onPressed: () async {
                setState(() {
                  wtd = true;
                });
              },
            ),
          ],
        );
      } else {
        bottomButtons = Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton(
              child: Text('Delete Fields ($selected)'),
              onPressed: () async {
                Map listChanger() {
                  Map x = {};
                  int a = 1;
                  for (int i = 0; i < project.progressesTracked.length; i++) {
                    if (selectedRowList[i] == false) {
                      x['pt$a'] = {
                        'name': project.progressesTracked['pt${i + 1}']['name'],
                        'done': project.progressesTracked['pt${i + 1}']['done'],
                        'total': project.progressesTracked['pt${i + 1}']
                            ['total'],
                      };
                      a++;
                    }
                    selectedRowList[i] = false;
                  }
                  return x;
                }

                setState(() {
                  selected = 0;
                });

                await Firestore.instance
                    .collection('projects')
                    .document(project.projID)
                    .setData({
                  'blast pot': project.blastPot,
                  'used abrasive weight': project.abrasiveUsedWeight,
                  'total abrasive weight': project.abrasiveTotalWeight,
                  'used adhesive litres': project.adhesiveUsedLitre,
                  'total adhesive litres': project.adhesiveTotalLitre,
                  'used paint litres': project.paintUsedLitre,
                  'total paint litres': project.paintTotalLitre,
                  'ID': project.projID,
                  'name': project.projname,
                  'location': project.location,
                  'total area needed blasting': project.totalSurfaceAreaB,
                  'blasted area': project.blastedArea,
                  'total area needed painting': project.totalSurfaceAreaP,
                  'painted area': project.paintedArea,
                  'users assigned': project.userAssigned,
                  'blast pot list': project.blastPotList,
                  'budget list': project.budgetList,
                  'progresses tracked': listChanger(),
                  'Date Created': project.date,
                });
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () async {
                setState(() {
                  wtd = false;
                  selected = 0;
                });
              },
            ),
          ],
        );
      }
      return bottomButtons;
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Container(
              color: Colors.indigo[50],
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 5),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              color: Colors.indigo[50],
              child: Center(
                child: Container(
                  height: 240,
                  width: 240,
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          '${(findPercent() * 100).toInt()}%',
                          style: TextStyle(fontSize: 50),
                        ),
                      ),
                      Container(
                        height: 240,
                        width: 240,
                        child: CircularProgressIndicator(
                          strokeWidth: 12,
                          value: findPercent(),
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
            Flexible(
              child: ListView(
                children: <Widget>[
                  Container(
//                      padding: EdgeInsets.symmetric(vertical: 5),
                    color: Colors.white,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 15,
                        columns: [
                          DataColumn(label: Text('Type')),
                          DataColumn(label: Text('Progress(%)'), numeric: true),
                          DataColumn(label: Text('Done(m²)'), numeric: true),
                          DataColumn(label: Text('Total(m²)'), numeric: true),
                        ],
                        rows: generatorX(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.indigo[100],
          child: bottomButtonsSwitcher(),
        ),
      ),
    );
  }
}

class IDPRowSetting extends StatefulWidget {
  final int num;
  final Project project;
  final ProgressType pt;
  IDPRowSetting({this.num, this.project, this.pt});
  @override
  _IDPRowSettingState createState() => _IDPRowSettingState();
}

class _IDPRowSettingState extends State<IDPRowSetting> {
  final _formKey = GlobalKey<FormState>();
  String _newName;
  double _newDone;
  double _newTotal;
  double _addsub1 = 100;
  double _addsub2 = 100;

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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            height: 400,
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex: 2,
                      child: Container(
                        child: TextFormField(
                          style: TextStyle(fontSize: 14),
                          initialValue:
                              '${(_newName ?? widget.pt.name)}' /*(1).toStringAsFixed(2)*/,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            hintText: 'name here',
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
                              (val.isEmpty ? 'Enter fieldname' : null),
                          onChanged: (val) {
                            _newName = val;
                          },
                        ),
                      ),
                    ),
                    ButtonTheme(
                      minWidth: 30,
                      child: FlatButton(
                        child: Icon(Icons.refresh),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 20,
                  color: Colors.blueGrey[600],
                ),
                SizedBox(height: 8),
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
                                  child: Text((_newDone ?? widget.pt.done)
                                      .toStringAsFixed(1)),
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
                                'Done(m²)',
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
                          initialValue: '$_addsub1' /*(1).toStringAsFixed(2)*/,
                          decoration: InputDecoration(
                            labelText: '+/-',
                            labelStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            hintText: 'm²',
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
                            _addsub1 = double.tryParse(val);
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
                              _newDone = widget.pt.done;
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
                                _newDone =
                                    nullChecker(_newDone, widget.pt.done);
                                print('$_newDone += $_addsub1');
                                setState(() {
                                  _newDone += _addsub1;
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
                                _newDone =
                                    nullChecker(_newDone, widget.pt.done);
                                setState(() {
                                  _newDone -= _addsub1;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 14),
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
                                  child: Text((_newTotal ?? widget.pt.total)
                                      .toStringAsFixed(1)),
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
                                'Total(m²)',
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
                          initialValue:
                              '${(_addsub2 ?? 100)}' /*(1).toStringAsFixed(2)*/,
                          decoration: InputDecoration(
                            labelText: '+/-',
                            labelStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            hintText: 'm²',
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
                            _newTotal = double.tryParse(val);
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
                              _newTotal = widget.pt.total;
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
                                _newTotal =
                                    nullChecker(_newTotal, widget.pt.total);
                                setState(() {
                                  _newTotal += _addsub2;
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
                                _newTotal =
                                    nullChecker(_newTotal, widget.pt.total);
                                setState(() {
                                  _newTotal -= _addsub2;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Center(
                  child: RaisedButton.icon(
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
                        Map x = widget.project.progressesTracked;
                        if (widget.num == widget.num) {
                          x['pt${widget.num}'] = {
                            'name': _newName ?? widget.pt.name,
                            'done': (_newDone ?? widget.pt.done),
                            'total': (_newTotal ?? widget.pt.total),
                          };
                        }
                        return x;
                      }

                      await Firestore.instance
                          .collection('projects')
                          .document(widget.project.projID)
                          .setData({
                        'blast pot': widget.project.blastPot,
                        'used abrasive weight':
                            widget.project.abrasiveUsedWeight,
                        'total abrasive weight':
                            widget.project.abrasiveTotalWeight,
                        'used adhesive litres':
                            widget.project.adhesiveUsedLitre,
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
                        'blast pot list': widget.project.blastPotList,
                        'budget list': widget.project.budgetList,
                        'progresses tracked': listChanger(),
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
      ),
    );
  }
}
