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
  @override
  Widget build(BuildContext context) {
    final project = Provider.of<Project>(context);
    List<DataRow> dataRowList = [];

    for (int i = 0; i < project.progressesTracked.length; i++) {
      dataRowList.add(
        DataRow(
          cells: [
            DataCell(Text(project.progressesTracked['pt${i + 1}']['name'])),
            DataCell(Text(
                '${(((project.progressesTracked['pt${i + 1}']['done'] / project.progressesTracked['pt${i + 1}']['total']) * 100)).toStringAsFixed(1)}')),
            DataCell(Text(
                '${project.progressesTracked['pt${i + 1}']['done'].toStringAsFixed(2)}m²')),
            DataCell(Text(
                '${project.progressesTracked['pt${i + 1}']['total'].toStringAsFixed(2)}m²')),
          ],
        ),
      );
    }

    double findPercent() {
      double percent;
      double _totalDone = 0, _totalOverall = 0;
      for (int i = 0; i < project.progressesTracked.length; i++) {
        _totalDone += project.progressesTracked['pt${i + 1}']['done'];
        _totalOverall += project.progressesTracked['pt${i + 1}']['total'];
      }
      percent = _totalDone / _totalOverall;
      return percent;
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.indigo[50],
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
                              IDPSettings(proj: project),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Center(
                child: Container(
                  height: 250,
                  width: 250,
                  child: CircularProgressIndicator(
                    strokeWidth: 12,
                    value: findPercent(),
                    backgroundColor: Colors.redAccent,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.lightGreenAccent),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Flexible(
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        color: Colors.white,
                        child: DataTable(
                          columnSpacing: 15,
                          columns: [
                            DataColumn(label: Text('Type')),
                            DataColumn(label: Text('Progress(%)')),
                            DataColumn(label: Text('Done')),
                            DataColumn(label: Text('Total')),
                          ],
                          rows: dataRowList,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.indigo[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(onPressed: () {}, child: Text('Add')),
              FlatButton(onPressed: () {}, child: Text('Add')),
            ],
          ),
        ),
      ),
    );
  }
}

class IDPSettings extends StatefulWidget {
  final Project proj;
  IDPSettings({this.proj});
  @override
  _IDPSettingsState createState() => _IDPSettingsState();
}

class _IDPSettingsState extends State<IDPSettings> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    double _currBlastedArea;
    double _currBlastTotalArea;
    double _currPaintedArea;
    double _currPaintTotalArea;

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
                    children: <Widget>[
                      SizedBox(height: 34),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Blast Applied, ',
                              style: TextStyle(fontSize: 24),
                            ),
                            Text(
                              'Blasted Areas(m²): ',
                              style: TextStyle(fontSize: 16),
                            ),
                            TextFormField(
                              initialValue: widget.proj.blastedArea.toString(),
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Total Area Blasted(m²)'),
                              validator: (val) => (val.isEmpty
                                  ? 'Enter area Blasted(m²)'
                                  : null),
                              onChanged: (val) {
                                setState(() =>
                                    (_currBlastedArea = double.tryParse(val)));
                              },
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Total Area Needed to be Blasted(m²): ',
                              style: TextStyle(fontSize: 16),
                            ),
                            TextFormField(
                              initialValue:
                                  widget.proj.totalSurfaceAreaB.toString(),
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Total Area Needed to Blast(m²)'),
                              validator: (val) => (val.isEmpty
                                  ? 'Enter area needed to be blast(m²)'
                                  : null),
                              onChanged: (val) {
                                setState(() => (_currBlastTotalArea =
                                    double.tryParse(val)));
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 34),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Paints Applied, ',
                              style: TextStyle(fontSize: 24),
                            ),
                            Text(
                              'Total Area Painted(m²): ',
                              style: TextStyle(fontSize: 16),
                            ),
                            TextFormField(
                              initialValue: widget.proj.paintedArea.toString(),
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Total Area Painted(m²)'),
                              validator: (val) => (val.isEmpty
                                  ? 'Enter area Painted(m²)'
                                  : null),
                              onChanged: (val) {
                                setState(() =>
                                    (_currPaintedArea = double.tryParse(val)));
                              },
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Total Area Needed to be Paint(m²): ',
                              style: TextStyle(fontSize: 16),
                            ),
                            TextFormField(
                              initialValue:
                                  widget.proj.abrasivePrice.toString(),
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Total Area Needed to Paint(m²)'),
                              validator: (val) => (val.isEmpty
                                  ? 'Enter area needed to be paint(m²)'
                                  : null),
                              onChanged: (val) {
                                setState(() => (_currPaintTotalArea =
                                    double.tryParse(val)));
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
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
