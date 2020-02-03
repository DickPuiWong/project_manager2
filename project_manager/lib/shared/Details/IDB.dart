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
                  );
                },
              );
            },
          ),
          DataCell(
            Text('${project.budgetList['bt${i + 1}']['percentage']}'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return DataRowSetting(
                    num: (i + 1),
                    bt: ttt,
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
  DataRowSetting({this.num, this.bt});
  @override
  _DataRowSettingState createState() => _DataRowSettingState();
}

class _DataRowSettingState extends State<DataRowSetting> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Dialog(
        child: Container(
          height: 400,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${widget.bt.name}',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${widget.bt.percentage.toStringAsFixed(1)}%',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Divider(
                height: 20,
                color: Colors.grey[600],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Spent:',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),

                  Flexible(
                    child: Container(
                      color: Colors.grey[50],
                      child: TextFormField(
                        style: TextStyle(fontSize: 15),
                        initialValue: '${25.toStringAsFixed(2)}',
                        decoration: textInputDecoration2.copyWith(hintText: 'RM'),
                        validator: (val) => (val.isEmpty ? 'Enter amount' : null),
                        onChanged: (val) {},
                      ),
                    ),
                  ),
                ], 
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('RM${widget.bt.spent.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                  Row(
                    children: <Widget>[
                      ButtonTheme(
                          minWidth: 45,
                          child: FlatButton(
                              child: Icon(Icons.add), onPressed: () {})),
                      ButtonTheme(
                          minWidth: 45,
                          child: FlatButton(
                              child: Icon(Icons.refresh), onPressed: () {})),
                      ButtonTheme(
                          minWidth: 45,
                          child: FlatButton(
                              child: Icon(Icons.remove), onPressed: () {})),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text('Estimate: RM${widget.bt.estimate.toStringAsFixed(2)}'),
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
