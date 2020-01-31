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
      dataRowList.add(DataRow(
        cells: [
          DataCell(Text(project.budgetList['bt${i + 1}']['name'])),
          DataCell(Text('${project.budgetList['bt${i + 1}']['percentage']}')),
          DataCell(Text(
              '${(project.budgetList['bt${i + 1}']['spent']).toStringAsFixed(2)}')),
          DataCell(Text(
              '${project.budgetList['bt${i + 1}']['estimate'].toStringAsFixed(2)}')),
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
                  currentValue:
                      ((((project.spentBudget ?? 0) / (project.budget ?? 0.0) * 100) ?? 0).toInt()),
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
//                        [
//                          DataRow(
//                            cells: [
//                              DataCell(Text(project.budgetList['bt1']['name'])),
//                              DataCell(Text(
//                                  '${project.budgetList['bt1']['percentage']}')),
//                              DataCell(Text(
//                                  '${(project.budgetList['bt1']['spent']).toStringAsFixed(2)}')),
//                              DataCell(Text(
//                                  '${project.budgetList['bt1']['estimate'].toStringAsFixed(2)}')),
//                            ],
//                          ),
//                          DataRow(
//                            cells: [
//                              DataCell(Text(project.budgetList['bt2']['name'])),
//                              DataCell(Text(
//                                  '${project.budgetList['bt2']['percentage']}')),
//                              DataCell(Text(
//                                  '${(project.budgetList['bt2']['spent']).toStringAsFixed(2)}')),
//                              DataCell(Text(
//                                  '${project.budgetList['bt2']['estimate'].toStringAsFixed(2)}')),
//                            ],
//                          ),
//                          DataRow(
//                            cells: [
//                              DataCell(Text(project.budgetList['bt3']['name'])),
//                              DataCell(Text(
//                                  '${project.budgetList['bt3']['percentage']}')),
//                              DataCell(Text(
//                                  '${(project.budgetList['bt3']['spent']).toStringAsFixed(2)}')),
//                              DataCell(Text(
//                                  '${project.budgetList['bt3']['estimate'].toStringAsFixed(2)}')),
//                            ],
//                          ),
//                          DataRow(
//                            cells: [
//                              DataCell(Text(project.budgetList['bt4']['name'])),
//                              DataCell(Text(
//                                  '${project.budgetList['bt4']['percentage']}')),
//                              DataCell(Text(
//                                  '${(project.budgetList['bt4']['spent']).toStringAsFixed(2)}')),
//                              DataCell(Text(
//                                  '${project.budgetList['bt4']['estimate'].toStringAsFixed(2)}')),
//                            ],
//                          ),
//                          DataRow(
//                            cells: [
//                              DataCell(Text(project.budgetList['bt5']['name'])),
//                              DataCell(Text(
//                                  '${project.budgetList['bt5']['percentage']}')),
//                              DataCell(Text(
//                                  '${(project.budgetList['bt5']['spent']).toStringAsFixed(2)}')),
//                              DataCell(Text(
//                                  '${project.budgetList['bt5']['estimate'].toStringAsFixed(2)}')),
//                            ],
//                          ),
//                          DataRow(
//                            cells: [
//                              DataCell(Text(project.budgetList['bt6']['name'])),
//                              DataCell(Text(
//                                  '${project.budgetList['bt6']['percentage']}')),
//                              DataCell(Text(
//                                  '${(project.budgetList['bt6']['spent']).toStringAsFixed(2)}')),
//                              DataCell(Text(
//                                  '${project.budgetList['bt6']['estimate'].toStringAsFixed(2)}')),
//                            ],
//                          ),
//                          DataRow(
//                            cells: [
//                              DataCell(Text(project.budgetList['bt7']['name'])),
//                              DataCell(Text(
//                                  '${project.budgetList['bt7']['percentage']}')),
//                              DataCell(Text(
//                                  '${(project.budgetList['bt7']['spent']).toStringAsFixed(2)}')),
//                              DataCell(Text(
//                                  '${project.budgetList['bt7']['estimate'].toStringAsFixed(2)}')),
//                            ],
//                          ),
//                          DataRow(
//                            cells: [
//                              DataCell(Text(project.budgetList['bt8']['name'])),
//                              DataCell(Text(
//                                  '${project.budgetList['bt8']['percentage']}')),
//                              DataCell(Text(
//                                  '${(project.budgetList['bt8']['spent']).toStringAsFixed(2)}')),
//                              DataCell(Text(
//                                  '${project.budgetList['bt8']['estimate'].toStringAsFixed(2)}')),
//                            ],
//                          ),
//                          DataRow(
//                            cells: [
//                              DataCell(Text(project.budgetList['bt9']['name'])),
//                              DataCell(Text(
//                                  '${project.budgetList['bt9']['percentage']}')),
//                              DataCell(Text(
//                                  '${(project.budgetList['bt9']['spent']).toStringAsFixed(2)}')),
//                              DataCell(Text(
//                                  '${project.budgetList['bt9']['estimate'].toStringAsFixed(2)}')),
//                            ],
//                          ),
//                          DataRow(
//                            cells: [
//                              DataCell(
//                                  Text(project.budgetList['bt10']['name'])),
//                              DataCell(Text(
//                                  '${project.budgetList['bt10']['percentage']}')),
//                              DataCell(Text(
//                                  '${(project.budgetList['bt10']['spent']).toStringAsFixed(2)}')),
//                              DataCell(Text(
//                                  '${project.budgetList['bt10']['estimate'].toStringAsFixed(2)}')),
//                            ],
//                          ),
//                          DataRow(
//                            cells: [
//                              DataCell(
//                                  Text(project.budgetList['bt11']['name'])),
//                              DataCell(Text(
//                                  '${project.budgetList['bt11']['percentage']}')),
//                              DataCell(Text(
//                                  '${(project.budgetList['bt11']['spent']).toStringAsFixed(2)}')),
//                              DataCell(Text(
//                                  '${project.budgetList['bt11']['estimate'].toStringAsFixed(2)}')),
//                            ],
//                          ),
//                        ],
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

//class RowLister extends StatefulWidget {
//  @override
//  _RowListerState createState() => _RowListerState();
//}
//
//class _RowListerState extends State<RowLister> {
//  @override
//  Widget build(BuildContext context) {
//    List rowList = [
////      DataRow(
////        cells: [
////          DataCell(Text(project.budgetList['bt1']['name'])),
////          DataCell(Text(
////              '${project.budgetList['bt1']['percentage']}')),
////          DataCell(Text(
////              '${(project.budgetList['bt1']['spent']).toStringAsFixed(2)}')),
////          DataCell(Text(
////              '${project.budgetList['bt1']['estimate'].toStringAsFixed(2)}')),
////        ],
////      ),
////      DataRow(
////        cells: [
////          DataCell(Text('adhesive')),
////          DataCell(Text('4')),
////          DataCell(Text(
////              (project.adhesivePrice).toStringAsFixed(2))),
////          DataCell(Text('4')),
////        ],
////      ),
////      DataRow(
////        cells: [
////          DataCell(Text('paint')),
////          DataCell(Text('4')),
////          DataCell(Text(
////              (project.paintPrice).toStringAsFixed(2))),
////          DataCell(Text('4')),
////        ],
////      ),
////      DataRow(
////        cells: [
////          DataCell(Text('consumables')),
////          DataCell(Text('4')),
////          DataCell(Text(
////              (project.paintPrice).toStringAsFixed(2))),
////          DataCell(Text('4')),
////        ],
////      ),
////      DataRow(
////        cells: [
////          DataCell(Text('labour')),
////          DataCell(Text('4')),
////          DataCell(Text(
////              (project.paintPrice).toStringAsFixed(2))),
////          DataCell(Text('4')),
////        ],
////      ),
////      DataRow(
////        cells: [
////          DataCell(Text('Equipment')),
////          DataCell(Text('4')),
////          DataCell(Text(
////              (project.paintPrice).toStringAsFixed(2))),
////          DataCell(Text('4')),
////        ],
////      ),
////      DataRow(
////        cells: [
////          DataCell(Text('food')),
////          DataCell(Text('4')),
////          DataCell(Text(
////              (project.paintPrice).toStringAsFixed(2))),
////          DataCell(Text('4')),
////        ],
////      ),
////      DataRow(
////        cells: [
////          DataCell(Text('freight & delivery')),
////          DataCell(Text('4')),
////          DataCell(Text(
////              (project.paintPrice).toStringAsFixed(2))),
////          DataCell(Text('4')),
////        ],
////      ),
////      DataRow(
////        cells: [
////          DataCell(Text('water')),
////          DataCell(Text('4')),
////          DataCell(Text(
////              (project.paintPrice).toStringAsFixed(2))),
////          DataCell(Text('4')),
////        ],
////      ),
////      DataRow(
////        cells: [
////          DataCell(Text('materials & supplies')),
////          DataCell(Text('4')),
////          DataCell(Text(
////              (project.paintPrice).toStringAsFixed(2))),
////          DataCell(Text('4')),
////        ],
////      ),
////      DataRow(
////        cells: [
////          DataCell(Text('diesel/electric meter')),
////          DataCell(Text('4')),
////          DataCell(Text(
////              (project.paintPrice).toStringAsFixed(2))),
////          DataCell(Text('4')),
////        ],
////      ),
//    ];
//    return Container();
//  }
//}

class IDBSettings extends StatefulWidget {
  final Project proj;
  IDBSettings({this.proj});
  @override
  _IDBSettingsState createState() => _IDBSettingsState();
}

class _IDBSettingsState extends State<IDBSettings> {
  double x;
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
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
                Row(
                  children: <Widget>[
                    Text('fffffaaaaaaaaaaaqqqqqqqq'),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: TextFormField(
                        initialValue: widget.proj.abrasivePrice.toString(),
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Total Area Needed to Paint(m^2)'),
                        validator: (val) => (val.isEmpty
                            ? 'Enter area needed to be paint'
                            : null),
                        onChanged: (val) {
                          setState(() => (x = double.tryParse(val)));
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
}
