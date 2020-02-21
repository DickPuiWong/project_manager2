// Name : IDM.dart
// Purpose :
// Function :

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_manager/models/BlastPotData.dart';
import 'package:project_manager/models/Project.dart';
import 'package:project_manager/services/database.dart';
import 'package:provider/provider.dart';

class IDMWrapper extends StatelessWidget {
  final Project project;
  final int permission;
  IDMWrapper({this.project, this.permission});
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Project>.value(
      value: ProjectDatabaseService(projID: project.projID).project,
      child: StreamProvider.value(
        value: AllBPDatabaseService().blastPotDatas,
        child: IDM(permission: permission),
      ),
    );
  }
}

class IDM extends StatefulWidget {
  final int permission;
  IDM({this.permission});
  @override
  _IDMState createState() => _IDMState();
}

class _IDMState extends State<IDM> {
  @override
  Widget build(BuildContext context) {
    final project = Provider.of<Project>(context);
    List<BlastPot> bpList = [];
    List<BlastPotDetails> bpsList = Provider.of<List<BlastPotDetails>>(context);

    BlastPot bpMaker(Map item, int i) {
      return BlastPot(
        num: item['bp${i + 1}']['Assigned num'],
        refillsDone: item['bp${i + 1}']['refills done'].toDouble(),
        usedAbrasive: item['bp${i + 1}']['used abrasive'].toDouble(),
        usedHoldTight: item['bp${i + 1}']['used HoldTight'].toDouble(),
        usedHours: item['bp${i + 1}']['used hours'].toDouble(),
      );
    }

    void listMaker(Map list) {
      for (int i = 0; i < list.length; i++) {
        bpList.add(bpMaker(project.blastPotList, i));
      }
    }

    listMaker(project.blastPotList);

    double checkError(double one, double two) {
      double x = 0;
      if (two != 0) {
        x = one / two;
      }
      return x;
    }

    double findPercentM() {
      double percent;
      percent =
          (checkError(project.abrasiveUsedWeight, project.abrasiveTotalWeight) +
                  checkError(
                      project.adhesiveUsedLitre, project.adhesiveTotalLitre)) /
              2;
      return percent;
    }

    Widget showTopRightButton() {
      Widget axe = Container();
      if (widget.permission == null) {
        axe = IconButton(
          icon: Icon(Icons.edit),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    IDMSettings(bpsList: bpsList, proj: project),
              ),
            );
          },
        );
      }
      return axe;
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
                      }),
                  showTopRightButton(),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(
                      'Blast Pots assigned: ${project.blastPot.toInt()}',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                  Divider(
                    height: 10,
                    color: Colors.indigo,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Used',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                              '${project.abrasiveUsedWeight}(${project.abrasiveUsedWeight * 25})'),
                          Text('${project.adhesiveUsedLitre}'),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Total',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'abrasive(bags,kg)',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'HoldTight(L)',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            'Limit',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                              '${project.abrasiveTotalWeight}(${project.abrasiveTotalWeight * 25})'),
                          Text('${project.adhesiveTotalLitre}'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 14),
                  Container(
                    height: 12,
                    child: LinearProgressIndicator(
                      value: findPercentM(),
                      backgroundColor: Colors.redAccent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.lightGreenAccent[400]),
                    ),
                  ),
                  Divider(
                    height: 16,
                    color: Colors.indigo,
                  ),
                ],
              ),
              SizedBox(height: 14),
              Text(
                'long press to delete',
                style: TextStyle(
                  fontSize: 13.5,
                ),
              ),
              SizedBox(height: 14),
              Flexible(
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                  itemCount: bpList.length,
                  itemBuilder: (context, index) {
                    return IDMListTiles(
                      bpsList: bpsList,
                      index: index,
                      bp: bpList[index],
                      project: project,
                    );
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

class IDMListTiles extends StatefulWidget {
  final List<BlastPotDetails> bpsList;
  final int index;
  final BlastPot bp;
  final Project project;
  IDMListTiles({this.bpsList, this.index, this.bp, this.project});
  @override
  _IDMListTilesState createState() => _IDMListTilesState();
}

class _IDMListTilesState extends State<IDMListTiles> {
  @override
  Widget build(BuildContext context) {
    BlastPotDetails currBPD;
    double showHoursUsed() {
      double x;
      for (int i = 0; i < widget.bpsList.length; i++) {
        if (widget.bp.num == widget.bpsList[i].num) {
          x = widget.bpsList[i].totalUsedHours;
          currBPD = widget.bpsList[i];
        }
      }
      return x;
    }

    showHoursUsed();

    Color alerter() {
      Color bgc = Colors.white;
      if (currBPD.totalUsedHours > 999) {
        bgc = Colors.red[200];
      } else if (currBPD.totalUsedHours > 899) {
        bgc = Colors.yellow[200];
      }
      return bgc;
    }

    String detectMaintanence() {
      String words = '';
      if (currBPD.totalUsedHours > 999) {
        words = '! Maintanence Required !';
      } else if (currBPD.totalUsedHours > 899) {
        words = '- Prepare for Maintanence -';
      }
      return words;
    }

    return Padding(
      padding: const EdgeInsets.all(5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          color: alerter(),
          child: Column(
            children: <Widget>[
              ListTile(
                onLongPress: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return BPTileDelete(
                          index: widget.index,
                          bp: widget.bp,
                          proj: widget.project,
                        );
                      });
                },
                title: Text(
                  'Blast Pot ${widget.bp.num}',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        'Abrasive used : ${widget.bp.usedAbrasive} bags(${widget.bp.usedAbrasive * 25} kg)'),
                    Text('HoldTight used : ${widget.bp.usedHoldTight} L'),
                    Text('Hours used : ${currBPD.totalUsedHours} hrs'),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return BPTilesSettings(
                            BPD: currBPD,
                            index: widget.index,
                            bp: widget.bp,
                            proj: widget.project,
                          );
                        });
                  },
                ),
              ),
              Center(
                child: Text(
                  detectMaintanence(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BPTileDelete extends StatefulWidget {
  final int index;
  final BlastPot bp;
  final Project proj;
  BPTileDelete({this.index, this.bp, this.proj});
  @override
  _BPTileDeleteState createState() => _BPTileDeleteState();
}

class _BPTileDeleteState extends State<BPTileDelete> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Form(
      key: _formKey,
      child: Dialog(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: Container(
            padding: EdgeInsets.all(5),
            height: 180,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Delete?',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text('Delete Blast Pot ${widget.bp.num}?'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton.icon(
                      icon: Icon(
                        Icons.check,
                        color: Colors.lightGreenAccent[400],
                      ),
                      label: Text(
                        'Yes',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () async {
                        Map mapChanger(Map inMap) {
                          int x = 1;
                          Map newMap = {};
                          for (int i = 0;
                              i < (widget.proj.blastPotList.length);
                              i++) {
                            if (i != widget.index) {
                              newMap['bp$x'] = inMap['bp${i + 1}'];
                              x++;
                            }
                          }
                          return newMap;
                        }

                        await Firestore.instance
                            .collection('projects')
                            .document(widget.proj.projID)
                            .setData({
                          'blast pot': (widget.proj.blastPot - 1),
                          'used abrasive weight':
                              (widget.proj.abrasiveUsedWeight),
                          'total abrasive weight':
                              widget.proj.abrasiveTotalWeight,
                          'used adhesive litres':
                              (widget.proj.adhesiveUsedLitre),
                          'total adhesive litres':
                              widget.proj.adhesiveTotalLitre,
                          'used paint litres': (widget.proj.paintUsedLitre),
                          'total paint litres': widget.proj.paintTotalLitre,
                          'ID': widget.proj.projID,
                          'name': widget.proj.projname,
                          'location': widget.proj.location,
                          'total area needed blasting':
                              widget.proj.totalSurfaceAreaB,
                          'blasted area': widget.proj.blastedArea,
                          'total area needed painting':
                              widget.proj.totalSurfaceAreaP,
                          'painted area': widget.proj.paintedArea,
                          'per fill': widget.proj.perFill,
                          'budget list': widget.proj.budgetList,
                          'progresses tracked': widget.proj.progressesTracked,
                          'users assigned': widget.proj.userAssigned,
                          'blast pot list':
                              mapChanger(widget.proj.blastPotList),
                          'Date Created': widget.proj.date,
                        });
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton.icon(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.redAccent[400],
                      ),
                      label: Text(
                        'No',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
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

class BPTilesSettings extends StatefulWidget {
  final BlastPotDetails BPD;
  final int index;
  final BlastPot bp;
  final Project proj;
  BPTilesSettings({this.BPD, this.index, this.bp, this.proj});

  @override
  _BPTilesSettingsState createState() => _BPTilesSettingsState();
}

class _BPTilesSettingsState extends State<BPTilesSettings> {
  final _formKey = GlobalKey<FormState>();
  int _bpNum;
  double _currRefills;
  double _refConst = 1;
  double _currUsedAbrasive;
  double _currUsedAdhesive;
  double _currHours;
  double _hrsConst = 1;

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
          borderRadius: BorderRadius.circular(3),
          child: Container(
            height: 450,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      'Blast Pot',
                      style: TextStyle(
                        fontSize: 24.8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Flexible(
                      child: Container(
                        child: TextFormField(
                          style: TextStyle(fontSize: 15),
                          initialValue:
                              '${(_bpNum ?? widget.bp.num)}' /*(1).toStringAsFixed(2)*/,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'No.',
                            labelStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            hintText: 'assigned no.',
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
                              (val.isEmpty ? 'Enter Num' : null),
                          onChanged: (val) {
                            _bpNum = int.tryParse(val);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey,
                  height: 10,
                ),
                SizedBox(height: 20),
//                Row(
//                  crossAxisAlignment: CrossAxisAlignment.end,
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                    Flexible(
//                      flex: 1,
//                      child: Stack(
//                        children: <Widget>[
//                          Padding(
//                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
//                            child: Column(
//                              crossAxisAlignment: CrossAxisAlignment.stretch,
//                              children: <Widget>[
//                                Container(
//                                  decoration: BoxDecoration(
//                                    border: Border.all(
//                                      color: Colors.indigo[50],
//                                      width: 2,
//                                    ),
//                                    borderRadius: BorderRadius.circular(3.5),
//                                  ),
//                                  padding: EdgeInsets.symmetric(
//                                      vertical: 14, horizontal: 12),
//                                  child: Text((_currUsedAbrasive ??
//                                              widget.bp.usedAbrasive)
//                                          .toStringAsFixed(1) +
//                                      '/' +
//                                      ((_currUsedAbrasive ??
//                                                  widget.bp.usedAbrasive) *
//                                              25)
//                                          .toStringAsFixed(0)),
//                                ),
//                              ],
//                            ),
//                          ),
//                          Positioned(
//                            left: 1,
//                            child: Container(
//                              padding: EdgeInsets.fromLTRB(2, 0, 4, 0),
//                              color: Colors.white,
//                              child: Text(
//                                'Abrasive(bags/kg)',
//                                style: TextStyle(
//                                  color: Colors.grey[600],
//                                  fontWeight: FontWeight.bold,
//                                ),
//                              ),
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
//                    Flexible(
//                      flex: 1,
//                      child: Stack(
//                        children: <Widget>[
//                          Padding(
//                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
//                            child: Column(
//                              crossAxisAlignment: CrossAxisAlignment.stretch,
//                              children: <Widget>[
//                                Container(
//                                  decoration: BoxDecoration(
//                                    border: Border.all(
//                                      color: Colors.indigo[50],
//                                      width: 2,
//                                    ),
//                                    borderRadius: BorderRadius.circular(3.5),
//                                  ),
//                                  padding: EdgeInsets.symmetric(
//                                      vertical: 14, horizontal: 12),
//                                  child: Text((_currUsedAdhesive ??
//                                          widget.bp.usedHoldTight)
//                                      .toStringAsFixed(1)),
//                                ),
//                              ],
//                            ),
//                          ),
//                          Positioned(
//                            left: 12,
//                            child: Container(
//                              padding: EdgeInsets.fromLTRB(2, 0, 4, 0),
//                              color: Colors.white,
//                              child: Text(
//                                'HoldTight(L)',
//                                style: TextStyle(
//                                  color: Colors.grey[600],
//                                  fontWeight: FontWeight.bold,
//                                ),
//                              ),
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
//                  ],
//                ),
//                SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex: 9,
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
                                  child: Text(
                                      (_currRefills ?? widget.bp.refillsDone)
                                          .toStringAsFixed(0)),
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
                                'Refills',
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
                      flex: 7,
                      child: Container(
                        child: TextFormField(
                          style: TextStyle(fontSize: 14),
                          keyboardType: TextInputType.number,
                          initialValue: _refConst.toStringAsFixed(0),
                          decoration: InputDecoration(
                            labelText: '+/-(refills)',
                            labelStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            hintText: 'refills',
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
                            _refConst = double.tryParse(val);
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
                              _currRefills = widget.bp.refillsDone;
                              _currUsedAbrasive = widget.bp.usedAbrasive;
                              _currUsedAdhesive = widget.bp.usedHoldTight;
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
                                _currRefills = nullChecker(
                                    _currRefills, widget.bp.refillsDone);
                                _currUsedAbrasive = nullChecker(
                                    _currUsedAbrasive, widget.bp.usedAbrasive);
                                _currUsedAdhesive = nullChecker(
                                    _currUsedAdhesive, widget.bp.usedHoldTight);
                                setState(() {
                                  _currRefills += _refConst;
                                  _currUsedAbrasive += widget
                                      .proj.perFill['abrasive']
                                      .toDouble();
                                  _currUsedAdhesive += widget
                                      .proj.perFill['HoldTight']
                                      .toDouble();
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
                                _currRefills = nullChecker(
                                    _currRefills, widget.bp.refillsDone);
                                _currUsedAbrasive = nullChecker(
                                    _currUsedAbrasive, widget.bp.usedAbrasive);
                                _currUsedAdhesive = nullChecker(
                                    _currUsedAdhesive, widget.bp.usedHoldTight);
                                setState(() {
                                  _currRefills -= _refConst;
                                  _currUsedAbrasive -= widget
                                      .proj.perFill['abrasive']
                                      .toDouble();
                                  _currUsedAdhesive -= widget
                                      .proj.perFill['HoldTight']
                                      .toDouble();
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'Hours',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
                                  child: Text(
                                      (_currHours ?? widget.BPD.totalUsedHours)
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
                                'Used(L)',
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
                          initialValue: '$_hrsConst' /*(1).toStringAsFixed(2)*/,
                          decoration: InputDecoration(
                            labelText: '+/-',
                            labelStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            hintText: 'L',
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
                            _hrsConst = double.tryParse(val);
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
                              _currHours = widget.BPD.totalUsedHours;
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
                                _currHours = nullChecker(
                                    _currHours, widget.BPD.totalUsedHours);
                                print('$_currHours += $_hrsConst');
                                setState(() {
                                  _currHours += _hrsConst;
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
                                _currHours = nullChecker(
                                    _currHours, widget.BPD.totalUsedHours);
                                setState(() {
                                  _currHours -= _hrsConst;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                FlatButton(
                  color: Colors.indigo[600],
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    Map bpListChanger(Map mapItem) {
                      mapItem['bp${widget.index + 1}'] = {
                        'Assigned num': _bpNum ?? widget.bp.num,
                        'refills done': _currRefills ?? widget.bp.refillsDone,
                        'used abrasive':
                            _currUsedAbrasive ?? widget.bp.usedAbrasive,
                        'used HoldTight':
                            _currUsedAdhesive ?? widget.bp.usedHoldTight,
                        'used hours': _currHours ?? widget.bp.usedHours,
                      };
                      return mapItem;
                    }

                    await Firestore.instance
                        .collection('BPData')
                        .document(widget.BPD.id)
                        .setData({
                      'id': widget.BPD.id,
                      'num': _bpNum ?? widget.BPD.num,
                      'used hours': _currHours ?? widget.BPD.totalUsedHours,
                    });

                    await Firestore.instance
                        .collection('projects')
                        .document(widget.proj.projID)
                        .setData({
                      'blast pot': widget.proj.blastPot,
                      'used abrasive weight': (widget.proj.abrasiveUsedWeight +
                          ((_currUsedAbrasive ??
                                  widget.proj.abrasiveUsedWeight) -
                              widget.bp.usedAbrasive)),
                      'total abrasive weight': widget.proj.abrasiveTotalWeight,
                      'used adhesive litres': (widget.proj.adhesiveUsedLitre +
                          ((_currUsedAdhesive ??
                                  widget.proj.adhesiveUsedLitre) -
                              widget.bp.usedHoldTight)),
                      'total adhesive litres': widget.proj.adhesiveTotalLitre,
                      'used paint litres': widget.bp.usedHours,
                      'total paint litres': widget.proj.paintTotalLitre,
                      'ID': widget.proj.projID,
                      'name': widget.proj.projname,
                      'location': widget.proj.location,
                      'total area needed blasting':
                          widget.proj.totalSurfaceAreaB,
                      'blasted area': widget.proj.blastedArea,
                      'total area needed painting':
                          widget.proj.totalSurfaceAreaP,
                      'painted area': widget.proj.paintedArea,
                      'per fill': widget.proj.perFill,
                      'users assigned': widget.proj.userAssigned,
                      'blast pot list': bpListChanger(widget.proj.blastPotList),
                      'budget list': widget.proj.budgetList,
                      'progresses tracked': widget.proj.progressesTracked,
                      'Date Created': widget.proj.date,
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IDMSettings extends StatefulWidget {
  final List<BlastPotDetails> bpsList;
  final Project proj;
  IDMSettings({this.bpsList, this.proj});
  @override
  _IDMSettingsState createState() => _IDMSettingsState();
}

class _IDMSettingsState extends State<IDMSettings> {
  double _currBlastPotNo;
  double _currTotalAbrasive;
  double _abrConst = 10;
  double _currTotalAdhesive;
  double _adhConst = 20;
  double _currRefillA;
  double _refAConst = 5;
  double _currRefillH;
  double _refHConst = 5;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    double nullChecker(double one, double two) {
      if (one == null) {
        one = two;
      }
      return one;
    }

    return Form(
      key: _formKey,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.indigo[50],
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: ListView(
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
                      onPressed: () async {
                        Map bpListChanger(Map mapItem) {
                          int ii = widget.proj.blastPot.toInt() + 1;
                          for (int i = 0;
                              i <
                                  ((_currBlastPotNo ?? widget.proj.blastPot) -
                                          widget.proj.blastPot)
                                      .toInt();
                              i++) {
                            mapItem['bp$ii'] = {
                              'Assigned num': 0,
                              'refills done': 0.0,
                              'used abrasive': 0.0,
                              'used HoldTight': 0.0,
                              'used hours': 0.0,
                            };
                            String id1 = Firestore.instance
                                .collection('BPData')
                                .document()
                                .documentID;
                            Firestore.instance
                                .collection('BPData')
                                .document(id1)
                                .setData({
                              'id': id1,
                              'num': 0,
                              'used hours': 0.0,
                            });
                            ii++;
                          }
                          return mapItem;
                        }

                        await Firestore.instance
                            .collection('projects')
                            .document(widget.proj.projID)
                            .setData({
                          'blast pot list':
                              bpListChanger(widget.proj.blastPotList),
                          'blast pot': (widget.proj.blastPot +
                              ((_currBlastPotNo ?? widget.proj.blastPot) -
                                  widget.proj.blastPot)),
                          'used abrasive weight':
                              widget.proj.abrasiveUsedWeight,
                          'total abrasive weight':
                              (widget.proj.abrasiveTotalWeight +
                                  ((_currTotalAbrasive ??
                                          widget.proj.abrasiveTotalWeight) -
                                      widget.proj.abrasiveTotalWeight)),
                          'used adhesive litres': widget.proj.adhesiveUsedLitre,
                          'total adhesive litres':
                              widget.proj.adhesiveTotalLitre +
                                  ((_currTotalAdhesive ??
                                          widget.proj.adhesiveTotalLitre) -
                                      widget.proj.adhesiveTotalLitre),
                          'used paint litres': widget.proj.paintUsedLitre,
                          'total paint litres': widget.proj.paintTotalLitre,
                          'ID': widget.proj.projID,
                          'name': widget.proj.projname,
                          'location': widget.proj.location,
                          'total area needed blasting':
                              widget.proj.totalSurfaceAreaB,
                          'blasted area': widget.proj.blastedArea,
                          'total area needed painting':
                              widget.proj.totalSurfaceAreaP,
                          'painted area': widget.proj.paintedArea,
                          'per fill': widget.proj.perFill,
                          'users assigned': widget.proj.userAssigned,
                          'budget list': widget.proj.budgetList,
                          'progresses tracked': widget.proj.progressesTracked,
                          'Date Created': widget.proj.date,
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Blast Pot',
                                style: TextStyle(fontSize: 24),
                              ),
                              Divider(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text: 'Quantity : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                            text:
                                                '${(_currBlastPotNo ?? widget.proj.blastPot).toInt()}'),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          _currBlastPotNo = nullChecker(
                                              _currBlastPotNo,
                                              widget.proj.blastPot);
                                          setState(() {
                                            _currBlastPotNo++;
                                          });
                                        },
                                        tooltip: 'Add',
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: () {
                                          _currBlastPotNo = nullChecker(
                                              _currBlastPotNo,
                                              widget.proj.blastPot);
                                          setState(() {
                                            if (_currBlastPotNo >
                                                widget.proj.blastPot) {
                                              _currBlastPotNo--;
                                            }
                                          });
                                        },
                                        tooltip: 'Remove',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Limits',
                                style: TextStyle(fontSize: 24),
                              ),
                              Divider(
                                height: 10,
                                indent: 5,
                                endIndent: 5,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    flex: 3,
                                    child: Stack(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 5, 0, 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.indigo[50],
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          3.5),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 14,
                                                    horizontal: 12),
                                                child: Text(
                                                    '${(_currTotalAbrasive ?? widget.proj.abrasiveTotalWeight).toStringAsFixed(1)} bags/ ${((_currTotalAbrasive ?? widget.proj.abrasiveTotalWeight) * 25).toStringAsFixed(1)} kg'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          left: 12,
                                          child: Container(
                                            padding:
                                                EdgeInsets.fromLTRB(2, 0, 4, 0),
                                            color: Colors.white,
                                            child: Text(
                                              'Abrasive(bags/kg)',
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
                                            '$_abrConst' /*(1).toStringAsFixed(2)*/,
                                        decoration: InputDecoration(
                                          labelText: '+/-',
                                          labelStyle: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                          hintText: 'bags',
                                          isDense: true,
                                          fillColor: Colors.white,
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.indigo[50],
                                                  width: 2.0)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.indigo[900],
                                                  width: 2.0)),
                                        ),
                                        validator: (val) => (val.isEmpty
                                            ? 'Enter amount'
                                            : null),
                                        onChanged: (val) {
                                          _abrConst = double.tryParse(val);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  ButtonTheme(
                                    minWidth: 45,
                                    child: Tooltip(
                                      message: 'revert to initial value',
                                      child: FlatButton(
                                        child: Icon(Icons.refresh),
                                        onPressed: () {
                                          setState(() {
                                            _currTotalAbrasive =
                                                widget.proj.abrasiveTotalWeight;
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
                                              _currTotalAbrasive = nullChecker(
                                                  _currTotalAbrasive,
                                                  widget.proj
                                                      .abrasiveTotalWeight);
                                              setState(() {
                                                _currTotalAbrasive += _abrConst;
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
                                              _currTotalAbrasive = nullChecker(
                                                  _currTotalAbrasive,
                                                  widget.proj
                                                      .abrasiveTotalWeight);
                                              setState(() {
                                                _currTotalAbrasive -= _abrConst;
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    flex: 3,
                                    child: Stack(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 5, 0, 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.indigo[50],
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          3.5),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 14,
                                                    horizontal: 12),
                                                child: Text(
                                                    '${(_currTotalAdhesive ?? widget.proj.adhesiveTotalLitre).toStringAsFixed(1)} L'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          left: 12,
                                          child: Container(
                                            padding:
                                                EdgeInsets.fromLTRB(2, 0, 4, 0),
                                            color: Colors.white,
                                            child: Text(
                                              'HoldTight(L)',
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
                                            '$_adhConst' /*(1).toStringAsFixed(2)*/,
                                        decoration: InputDecoration(
                                          labelText: '+/-',
                                          labelStyle: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                          hintText: 'Litres',
                                          isDense: true,
                                          fillColor: Colors.white,
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.indigo[50],
                                                  width: 2.0)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.indigo[900],
                                                  width: 2.0)),
                                        ),
                                        validator: (val) => (val.isEmpty
                                            ? 'Enter amount'
                                            : null),
                                        onChanged: (val) {
                                          _adhConst = double.tryParse(val);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  ButtonTheme(
                                    minWidth: 45,
                                    child: Tooltip(
                                      message: 'revert to initial value',
                                      child: FlatButton(
                                        child: Icon(Icons.refresh),
                                        onPressed: () {
                                          setState(() {
                                            _currTotalAdhesive =
                                                widget.proj.adhesiveTotalLitre;
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
                                              _currTotalAdhesive = nullChecker(
                                                  _currTotalAdhesive,
                                                  widget
                                                      .proj.adhesiveTotalLitre);
                                              setState(() {
                                                _currTotalAdhesive += _adhConst;
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
                                              _currTotalAdhesive = nullChecker(
                                                  _currTotalAdhesive,
                                                  widget
                                                      .proj.adhesiveTotalLitre);
                                              setState(() {
                                                _currTotalAdhesive -= _adhConst;
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
//                ClipRRect(
//                  borderRadius: BorderRadius.circular(5),
//                  child: Container(
//                    padding: EdgeInsets.all(5),
//                    color: Colors.white,
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: <Widget>[
//                        Container(
//                          child: Column(
//                            children: <Widget>[
//                              Text(
//                                'ADHESIVE',
//                                style: TextStyle(fontSize: 24),
//                              ),
//                              Divider(
//                                height: 10,
//                                indent: 5,
//                                endIndent: 5,
//                              ),
//                              Row(
//                                mainAxisAlignment:
//                                    MainAxisAlignment.spaceBetween,
//                                children: <Widget>[
//                                  RichText(
//                                    text: TextSpan(
//                                      style: TextStyle(color: Colors.black),
//                                      children: [
//                                        TextSpan(
//                                          text: 'Limit : ',
//                                          style: TextStyle(
//                                              fontWeight: FontWeight.bold),
//                                        ),
//                                        TextSpan(
//                                            text:
//                                                '${(_currTotalAdhesive ?? widget.proj.adhesiveTotalLitre).toStringAsFixed(2)}L'),
//                                      ],
//                                    ),
//                                  ),
//                                  Row(
//                                    children: <Widget>[
//                                      IconButton(
//                                        icon: Icon(Icons.add),
//                                        onPressed: () {
//                                          _currTotalAdhesive = nullChecker(
//                                              _currTotalAdhesive,
//                                              widget.proj.adhesiveTotalLitre);
//                                          setState(() {
//                                            _currTotalAdhesive++;
//                                          });
//                                        },
//                                        tooltip: 'Add a liter(1L)',
//                                      ),
//                                      IconButton(
//                                        icon: Icon(Icons.remove),
//                                        onPressed: () {
//                                          _currTotalAdhesive = nullChecker(
//                                              _currTotalAdhesive,
//                                              widget.proj.adhesiveTotalLitre);
//                                          setState(() {
//                                            _currTotalAdhesive--;
//                                          });
//                                        },
//                                        tooltip: 'Remove a liter(1L)',
//                                      ),
//                                    ],
//                                  ),
//                                ],
//                              ),
//                            ],
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                ),?
                SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Column(
                            children: <Widget>[
                              Text(
                                'per Refill Constant',
                                style: TextStyle(fontSize: 24),
                              ),
                              Divider(
                                height: 10,
                                indent: 5,
                                endIndent: 5,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    flex: 3,
                                    child: Stack(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 5, 0, 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.indigo[50],
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          3.5),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 14,
                                                  horizontal: 12,
                                                ),
                                                child: Text(
                                                    '${(_currRefillA ?? widget.proj.perFill['abrasive']).toStringAsFixed(1)} bags/ ${((_currRefillA ?? widget.proj.perFill['abrasive']) * 25).toStringAsFixed(1)} kg'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          left: 12,
                                          child: Container(
                                            padding:
                                                EdgeInsets.fromLTRB(2, 0, 4, 0),
                                            color: Colors.white,
                                            child: Text(
                                              'Abrasive(bags/kg)',
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
                                            '$_refAConst' /*(1).toStringAsFixed(2)*/,
                                        decoration: InputDecoration(
                                          labelText: '+/-',
                                          labelStyle: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                          hintText: 'bags',
                                          isDense: true,
                                          fillColor: Colors.white,
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.indigo[50],
                                                  width: 2.0)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.indigo[900],
                                                  width: 2.0)),
                                        ),
                                        validator: (val) => (val.isEmpty
                                            ? 'Enter amount'
                                            : null),
                                        onChanged: (val) {
                                          _refAConst = double.tryParse(val);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  ButtonTheme(
                                    minWidth: 45,
                                    child: Tooltip(
                                      message: 'revert to initial value',
                                      child: FlatButton(
                                        child: Icon(Icons.refresh),
                                        onPressed: () {
                                          setState(() {
                                            _currRefillA = widget
                                                .proj.perFill['abrasive']
                                                .toDouble();
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
                                              _currRefillA = nullChecker(
                                                  _currRefillA,
                                                  widget
                                                      .proj.perFill['abrasive']
                                                      .toDouble());
                                              setState(() {
                                                _currRefillA += _refAConst;
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
                                              _currRefillA = nullChecker(
                                                  _currRefillA,
                                                  widget
                                                      .proj.perFill['abrasive']
                                                      .toDouble());
                                              setState(() {
                                                _currRefillA -= _refAConst;
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    flex: 3,
                                    child: Stack(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 5, 0, 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.indigo[50],
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          3.5),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 14,
                                                    horizontal: 12),
                                                child: Text(
                                                    '${(_currRefillH ?? widget.proj.perFill['HoldTight']).toStringAsFixed(1)} L'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          left: 12,
                                          child: Container(
                                            padding:
                                                EdgeInsets.fromLTRB(2, 0, 4, 0),
                                            color: Colors.white,
                                            child: Text(
                                              'HoldTight(L)',
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
                                            '$_refAConst' /*(1).toStringAsFixed(2)*/,
                                        decoration: InputDecoration(
                                          labelText: '+/-',
                                          labelStyle: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                          hintText: 'litres',
                                          isDense: true,
                                          fillColor: Colors.white,
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.indigo[50],
                                                  width: 2.0)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.indigo[900],
                                                  width: 2.0)),
                                        ),
                                        validator: (val) => (val.isEmpty
                                            ? 'Enter amount'
                                            : null),
                                        onChanged: (val) {
                                          _refHConst = double.tryParse(val);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  ButtonTheme(
                                    minWidth: 45,
                                    child: Tooltip(
                                      message: 'revert to initial value',
                                      child: FlatButton(
                                        child: Icon(Icons.refresh),
                                        onPressed: () {
                                          setState(() {
                                            _currRefillH = widget
                                                .proj.perFill['HoldTight']
                                                .toDouble();
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
                                              _currRefillH = nullChecker(
                                                  _currRefillH,
                                                  widget
                                                      .proj.perFill['HoldTight']
                                                      .toDouble());
                                              setState(() {
                                                _currRefillH += _refHConst;
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
                                              _currRefillH = nullChecker(
                                                  _currRefillH,
                                                  widget
                                                      .proj.perFill['HoldTight']
                                                      .toDouble());
                                              setState(() {
                                                _currRefillH -= _refHConst;
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
