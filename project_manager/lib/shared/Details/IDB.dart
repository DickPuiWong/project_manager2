import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:project_manager/models/Project.dart';
import 'package:project_manager/services/database.dart';
import 'package:provider/provider.dart';
import 'package:project_manager/shared/constants.dart';

class IDBWrapper extends StatelessWidget {
  final Project project;
  IDBWrapper({this.project});
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Project>.value(
      value: ProjectDatabaseService(projID: project.projID).project,
      child: IDB(),
    );
  }
}

class IDB extends StatefulWidget {
  @override
  _IDBState createState() => _IDBState();
}

class _IDBState extends State<IDB> {
  @override
  Widget build(BuildContext context) {
    final project = Provider.of<Project>(context);
    List<DataRow> dataRowList = [];
    for (int i = 0; i < project.budgetList.length; i++) {
      BudgetType ttt = new BudgetType(
        name: project.budgetList['bt${i + 1}']['name'],
        percentage: project.budgetList['bt${i + 1}']['percentage'].toDouble(),
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
            Text('${project.budgetList['bt${i + 1}']['percentage'].toStringAsFixed(1)}'),
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
        ],
      ));
    }

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
                              IDBSettings(proj: project),
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
                  currentValue: ((((project.spentBudget ?? 0) /
                              (project.budget ?? 0.0) *
                              100) ??
                          0)
                      .toInt()),
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
                    'Used : RM${project.spentBudget.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Total : RM${project.budget.toStringAsFixed(2)}',
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
                            label: Text('Percent(%)'),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Text('Spent(RM)'),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Text('Estimate(RM)'),
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
  double _newSpent, _newEstimate, _newPercent;
  @override
  Widget build(BuildContext context) {
    void percentCalculator() {
      setState(() {
        _newPercent = (_newSpent ?? widget.bt.spent) /
            (_newEstimate ?? widget.bt.estimate) *
            100;
      });
    }

    return Form(
      key: _formKey,
      child: Dialog(
        child: Container(
          height: 240,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${widget.bt.name} budget(RM)',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${(_newPercent ?? widget.bt.percentage).toStringAsFixed(1)}%',
                    style:
                        TextStyle(fontSize: 20.5, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Divider(
                height: 20,
                color: Colors.grey[600],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Spent:',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                    child: Container(
                      color: Colors.grey[50],
                      child: TextFormField(
                        style: TextStyle(fontSize: 14),
                        keyboardType: TextInputType.number,
                        initialValue:
                            (_newSpent ?? widget.bt.spent).toStringAsFixed(2),
                        decoration: InputDecoration(
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
                          if (double.tryParse(val) >=
                              (_newEstimate ?? widget.bt.estimate)) {
                            _newSpent = (_newEstimate ?? widget.bt.estimate);
                          } else {
                            _newSpent = double.tryParse(val);
                          }
                          percentCalculator();
                        },
                      ),
                    ),
                  ),
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
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Estimate:',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                    child: Container(
                      color: Colors.grey[50],
                      child: TextFormField(
                        style: TextStyle(fontSize: 14),
                        keyboardType: TextInputType.number,
                        initialValue: (_newEstimate ?? widget.bt.estimate)
                            .toStringAsFixed(2),
                        decoration: InputDecoration(
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
                          _newEstimate = double.tryParse(val);
                          percentCalculator();
                        },
                      ),
                    ),
                  ),
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
                ],
              ),
              SizedBox(height: 9),
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
                      Map x = widget.project.budgetList;
                      for (int i = 0;
                          i < widget.project.budgetList.length;
                          i++) {
                        if ((i + 1) == widget.num) {
                          x['bt${i + 1}'] = {
                            'name': widget.bt.name,
                            'percentage': (_newPercent ?? widget.bt.percentage),
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
                      'completion': widget.project.completion,
                      'budget': widget.project.budget + _newEstimate,
                      'spent budget': widget.project.spentBudget + _newSpent,
                      'adhesive price': widget.project.adhesivePrice,
                      'abrasive price': widget.project.abrasivePrice,
                      'paint price': widget.project.paintPrice,
                      'total area needed blasting':
                          widget.project.totalSurfaceAreaB,
                      'blasted area': widget.project.blastedArea,
                      'total area needed painting':
                          widget.project.totalSurfaceAreaP,
                      'painted area': widget.project.paintedArea,
                      'users assigned': widget.project.userAssigned,
                      'blast pot list': widget.project.blastPotList,
                      'budget list': listChanger(),
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

class IDBSettings extends StatefulWidget {
  final Project proj;
  IDBSettings({this.proj});
  @override
  _IDBSettingsState createState() => _IDBSettingsState();
}

class _IDBSettingsState extends State<IDBSettings> {
  final _formKey = GlobalKey<FormState>();
  double x;
  @override
  Widget build(BuildContext context) {
    List<Widget> cards = [];
    for (int i = 0; i < widget.proj.budgetList.length; i++) {
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
                    widget.proj.budgetList['bt${i + 1}']['name'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )),
                  Divider(height: 10),
                  Row(
                    children: <Widget>[
                      Text(
                          'Spent: RM${(widget.proj.budgetList['bt${i + 1}']['spent']).toStringAsFixed(2)}'),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Text(
                          'Estimate: RM${(widget.proj.budgetList['bt${i + 1}']['estimate']).toStringAsFixed(2)}'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Form(
      key: _formKey,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.indigo[50],
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
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
        ),
      ),
    );
  }
}
