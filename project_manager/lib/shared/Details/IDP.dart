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
  @override
  Widget build(BuildContext context) {
    final project = Provider.of<Project>(context);
    List<DataRow> dataRowList = [];

    double errorAvoider(double one, double two) {
      double x;
      if (two == 0) {
        x = 0;
      } else {
        x = one / two;
      }
      return x;
    }

    for (int i = 0; i < project.progressesTracked.length; i++) {
      ProgressType temp = new ProgressType(
        name: project.progressesTracked['pt${i + 1}']['name'] ?? 'error',
        done: project.progressesTracked['pt${i + 1}']['done'].toDouble() ?? 0.0,
        total:
            project.progressesTracked['pt${i + 1}']['total'].toDouble() ?? 0.0,
      );
      dataRowList.add(
        DataRow(
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
                        rows: dataRowList,
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
          child: Row(
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
                    'completion': project.completion,
                    'budget': project.budget,
                    'spent budget': project.spentBudget,
                    'adhesive price': project.adhesivePrice,
                    'abrasive price': project.abrasivePrice,
                    'paint price': project.paintPrice,
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
                child: Text('Delete Field'),
                onPressed: () {},
              ),
            ],
          ),
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
  String name;
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        '${widget.pt.name}',
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
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
                            'name': widget.pt.name,
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
                        'completion': widget.project.completion,
                        'budget': widget.project.budget,
                        'spent budget': widget.project.spentBudget,
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
