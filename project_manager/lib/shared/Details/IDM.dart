// Name : IDM.dart
// Purpose :
// Function :

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_manager/models/Project.dart';
import 'package:project_manager/services/database.dart';
import 'package:provider/provider.dart';
import 'package:project_manager/shared/constants.dart';

class IDMWrapper extends StatelessWidget {
  final Project project;
  IDMWrapper({this.project});
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Project>.value(
      value: ProjectDatabaseService(projID: project.projID).project,
      child: IDM(),
    );
  }
}

class IDM extends StatefulWidget {
  @override
  _IDMState createState() => _IDMState();
}

class _IDMState extends State<IDM> {
  @override
  Widget build(BuildContext context) {
    final project = Provider.of<Project>(context);
    List<BlastPot> bpList = [];

    BlastPot bpMaker(Map item, int i) {
      return BlastPot(
        num: item['Blast Pot ${i + 1}']['Assigned num'],
        usedAbrasive: item['Blast Pot ${i + 1}']['used abrasive'],
        usedAdhesive: item['Blast Pot ${i + 1}']['used adhesive'],
        usedPaint: item['Blast Pot ${i + 1}']['used paint'],
      );
    }

    void listMaker(Map list) {
      int x = 0;
      for (int i = 0; i < list.length + x; i++) {
        if (project.blastPotList['Blast Pot ${i + 1}'] != null) {
          bpList.add(bpMaker(project.blastPotList, i));
        } else {
          x++;
        }
      }
    }

    listMaker(project.blastPotList);

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
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              IDMSettings(proj: project),
                        ),
                      );
                    },
                  ),
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
                              '${project.abrasiveUsedWeight}(${project.abrasiveUsedWeight / 25})'),
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
                            'abrasive(kg,bags)',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'adhesive(L)',
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
                              '${project.abrasiveTotalWeight}(${project.abrasiveTotalWeight / 25})'),
                          Text('${project.adhesiveTotalLitre}'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: ((project.abrasiveUsedWeight /
                                project.abrasiveTotalWeight) +
                            (project.adhesiveUsedLitre /
                                project.adhesiveTotalLitre)) /
                        2,
                    backgroundColor: Colors.redAccent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.lightGreenAccent[400]),
                  ),
                  Divider(
                    height: 14,
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
  final BlastPot bp;
  final Project project;
  IDMListTiles({this.bp, this.project});
  @override
  _IDMListTilesState createState() => _IDMListTilesState();
}

class _IDMListTilesState extends State<IDMListTiles> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          color: Colors.white,
          child: ListTile(
            onLongPress: () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return BPTileDelete(
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
                    'Abrasive used : ${widget.bp.usedAbrasive} kg(${widget.bp.usedAbrasive / 25} bags)'),
                Text('Adhesive used : ${widget.bp.usedAdhesive} L'),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return BPTilesSettings(
                        bp: widget.bp,
                        proj: widget.project,
                      );
                    });
              },
            ),
          ),
        ),
      ),
    );
  }
}

class BPTileDelete extends StatefulWidget {
  final BlastPot bp;
  final Project proj;
  BPTileDelete({this.bp, this.proj});
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
                          int x = 0;
                          Map newMap = {};
                          for (int i = 0;
                              i < (widget.proj.blastPotList.length + x);
                              i++) {
                            if (inMap['Blast Pot ${i + 1}'] != null) {
                              if (i + 1 != widget.bp.num) {
                                newMap['Blast Pot ${i + 1}'] =
                                    (inMap['Blast Pot ${i + 1}']);
                              }
                            } else {
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
                          'completion': widget.proj.completion,
                          'budget': widget.proj.budget,
                          'spent budget': widget.proj.spentBudget,
                          'adhesive price': widget.proj.adhesivePrice,
                          'abrasive price': widget.proj.abrasivePrice,
                          'paint price': widget.proj.paintPrice,
                          'total area needed blasting':
                              widget.proj.totalSurfaceAreaB,
                          'blasted area': widget.proj.blastedArea,
                          'total area needed painting':
                              widget.proj.totalSurfaceAreaP,
                          'painted area': widget.proj.paintedArea,
                          'users assigned': widget.proj.userAssigned,
                          'budget list': widget.proj.budgetList,
                          'progresses tracked': widget.proj.progressesTracked,
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
                      onPressed: () {},
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
  final BlastPot bp;
  final Project proj;
  BPTilesSettings({this.bp, this.proj});

  @override
  _BPTilesSettingsState createState() => _BPTilesSettingsState();
}

class _BPTilesSettingsState extends State<BPTilesSettings> {
  double _currUsedAbrasive;
  double _abraConst;
  double _currUsedAdhesive;
  double _adheConst;
  double _currUsedPaint;
  final _formKey = GlobalKey<FormState>();

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
            height: 280,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          'Blast Pot ${widget.bp.num}',
                          style: TextStyle(
                            fontSize: 24.8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        height: 10,
                        indent: 5,
                        endIndent: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: 'Used Abrasive : \n',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                    text:
                                        '${(_currUsedAbrasive ?? widget.bp.usedAbrasive).toStringAsFixed(2)}kg\n(${((_currUsedAbrasive ?? widget.bp.usedAbrasive) / 25).toStringAsFixed(2)} bags)'),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Container(
                              width: 60,
                              child: TextFormField(
                                initialValue: (_abraConst ?? 25).toString(),
                                decoration: textInputDecoration.copyWith(
                                    hintText: 'kg'),
                                validator: (val) =>
                                    (val.isEmpty ? 'Enter amount' : null),
                                onChanged: (val) {
                                  setState(() =>
                                      (_abraConst = double.tryParse(val)));
                                },
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  _currUsedAbrasive = nullChecker(
                                      _currUsedAbrasive,
                                      widget.bp.usedAbrasive);
                                  setState(() {
                                    _currUsedAbrasive += 25;
                                  });
                                },
                                tooltip: 'Add',
                              ),
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  _currUsedAbrasive = nullChecker(
                                      _currUsedAbrasive,
                                      widget.bp.usedAbrasive);
                                  setState(() {
                                    _currUsedAbrasive -= 25;
                                  });
                                },
                                tooltip: 'Remove',
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 12.5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: 'Used Adhesive : \n',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                    text:
                                        '${(_currUsedAdhesive ?? widget.bp.usedAdhesive).toStringAsFixed(2)}L'),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Container(
                              width: 60,
                              child: TextFormField(
                                initialValue: (_adheConst ?? 25).toString(),
                                decoration: textInputDecoration.copyWith(
                                    hintText: 'kg'),
                                validator: (val) =>
                                    (val.isEmpty ? 'Enter amount' : null),
                                onChanged: (val) {
                                  setState(() =>
                                      (_adheConst = double.tryParse(val)));
                                },
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              ButtonTheme(
                                minWidth: 45,
                                child: FlatButton(
                                  child: Icon(Icons.add),
                                  onPressed: () {
                                    _currUsedAdhesive = nullChecker(
                                        _currUsedAdhesive,
                                        widget.bp.usedAdhesive);
                                    setState(() {
                                      _currUsedAdhesive++;
                                    });
                                  },
                                ),
                              ),
                              ButtonTheme(
                                minWidth: 45,
                                child: FlatButton(
                                  child: Icon(Icons.remove),
                                  onPressed: () {
                                    _currUsedAdhesive = nullChecker(
                                        _currUsedAdhesive,
                                        widget.bp.usedAdhesive);
                                    setState(() {
                                      _currUsedAdhesive--;
                                    });
                                  },
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
                            mapItem['Blast Pot ${widget.bp.num}'] = {
                              'Assigned num': widget.bp.num,
                              'used abrasive':
                                  _currUsedAbrasive ?? widget.bp.usedAbrasive,
                              'used adhesive':
                                  _currUsedAdhesive ?? widget.bp.usedAdhesive,
                              'used paint':
                                  _currUsedPaint ?? widget.bp.usedPaint,
                            };
                            return mapItem;
                          }

                          await Firestore.instance
                              .collection('projects')
                              .document(widget.proj.projID)
                              .setData({
                            'blast pot': widget.proj.blastPot,
                            'used abrasive weight':
                                (widget.proj.abrasiveUsedWeight +
                                    ((_currUsedAbrasive ??
                                            widget.proj.abrasiveUsedWeight) -
                                        widget.bp.usedAbrasive)),
                            'total abrasive weight':
                                widget.proj.abrasiveTotalWeight,
                            'used adhesive litres':
                                (widget.proj.adhesiveUsedLitre +
                                    ((_currUsedAdhesive ??
                                            widget.proj.adhesiveUsedLitre) -
                                        widget.bp.usedAdhesive)),
                            'total adhesive litres':
                                widget.proj.adhesiveTotalLitre,
                            'used paint litres': widget.bp.usedPaint,
                            'total paint litres': widget.proj.paintTotalLitre,
                            'ID': widget.proj.projID,
                            'name': widget.proj.projname,
                            'location': widget.proj.location,
                            'completion': widget.proj.completion,
                            'budget': widget.proj.budget,
                            'spent budget': widget.proj.spentBudget,
                            'adhesive price': widget.proj.adhesivePrice,
                            'abrasive price': widget.proj.abrasivePrice,
                            'paint price': widget.proj.paintPrice,
                            'total area needed blasting':
                                widget.proj.totalSurfaceAreaB,
                            'blasted area': widget.proj.blastedArea,
                            'total area needed painting':
                                widget.proj.totalSurfaceAreaP,
                            'painted area': widget.proj.paintedArea,
                            'users assigned': widget.proj.userAssigned,
                            'blast pot list':
                                bpListChanger(widget.proj.blastPotList),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IDMSettings extends StatefulWidget {
  final Project proj;
  IDMSettings({this.proj});
  @override
  _IDMSettingsState createState() => _IDMSettingsState();
}

class _IDMSettingsState extends State<IDMSettings> {
  double _currBlastPotNo;
  double _currTotalAbrasive;
  double _currTotalAdhesive;
  double _currTotalPaint;

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
                      onPressed: () async {
                        Map bpListChanger(Map mapItem) {
                          int ii = 1;
                          for (int i = 0;
                              i <
                                  ((_currBlastPotNo ?? widget.proj.blastPot) -
                                          widget.proj.blastPot)
                                      .toInt();
                              i++) {
                            if (mapItem['Blast Pot $ii'] == null) {
                              mapItem['Blast Pot $ii'] = {
                                'Assigned num': ii,
                                'used abrasive': 0.0,
                                'used adhesive': 0.0,
                                'used paint': 0.0,
                              };
                            } else {
                              i--;
                            }
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
                          'total paint litres': widget.proj.paintTotalLitre +
                              ((_currTotalPaint ??
                                      widget.proj.paintTotalLitre) -
                                  widget.proj.paintTotalLitre),
                          'ID': widget.proj.projID,
                          'name': widget.proj.projname,
                          'location': widget.proj.location,
                          'completion': widget.proj.completion,
                          'budget': widget.proj.budget,
                          'spent budget': widget.proj.spentBudget,
                          'adhesive price': widget.proj.adhesivePrice,
                          'abrasive price': widget.proj.abrasivePrice,
                          'paint price': widget.proj.paintPrice,
                          'total area needed blasting':
                              widget.proj.totalSurfaceAreaB,
                          'blasted area': widget.proj.blastedArea,
                          'total area needed painting':
                              widget.proj.totalSurfaceAreaP,
                          'painted area': widget.proj.paintedArea,
                          'users assigned': widget.proj.userAssigned,
                          'budget list': widget.proj.budgetList,
                          'progresses tracked': widget.proj.progressesTracked,
                          'Date Created': widget.proj.date,
                        });
                        print(new DateTime.fromMillisecondsSinceEpoch(
                            widget.proj.date));
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
                                indent: 5,
                                endIndent: 5,
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
                                'ABRASIVE',
                                style: TextStyle(fontSize: 24),
                              ),
                              Divider(
                                height: 10,
                                indent: 5,
                                endIndent: 5,
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
                                          text: 'Max : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                            text:
                                                '${(_currTotalAbrasive ?? widget.proj.abrasiveTotalWeight).toStringAsFixed(2)}kg (${((_currTotalAbrasive ?? widget.proj.abrasiveTotalWeight) / 250).toStringAsFixed(1)}bag)'),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          _currTotalAbrasive = nullChecker(
                                              _currTotalAbrasive,
                                              widget.proj.abrasiveTotalWeight);
                                          setState(() {
                                            _currTotalAbrasive += 250;
                                          });
                                        },
                                        tooltip: 'Add a bag(250kg)',
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: () {
                                          _currTotalAbrasive = nullChecker(
                                              _currTotalAbrasive,
                                              widget.proj.abrasiveTotalWeight);
                                          setState(() {
                                            _currTotalAbrasive -= 250;
                                          });
                                        },
                                        tooltip: 'Remove a bag(250kg)',
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
                                'ADHESIVE',
                                style: TextStyle(fontSize: 24),
                              ),
                              Divider(
                                height: 10,
                                indent: 5,
                                endIndent: 5,
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
                                          text: 'Max : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                            text:
                                                '${(_currTotalAdhesive ?? widget.proj.adhesiveTotalLitre).toStringAsFixed(2)}L'),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          _currTotalAdhesive = nullChecker(
                                              _currTotalAdhesive,
                                              widget.proj.adhesiveTotalLitre);
                                          setState(() {
                                            _currTotalAdhesive++;
                                          });
                                        },
                                        tooltip: 'Add a liter(1L)',
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: () {
                                          _currTotalAdhesive = nullChecker(
                                              _currTotalAdhesive,
                                              widget.proj.adhesiveTotalLitre);
                                          setState(() {
                                            _currTotalAdhesive--;
                                          });
                                        },
                                        tooltip: 'Remove a liter(1L)',
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
                                'PAINT',
                                style: TextStyle(fontSize: 24),
                              ),
                              Divider(
                                height: 10,
                                indent: 5,
                                endIndent: 5,
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
                                          text: 'Max : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                            text:
                                                '${(_currTotalPaint ?? widget.proj.paintTotalLitre).toStringAsFixed(2)}L'),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          _currTotalPaint = nullChecker(
                                              _currTotalPaint,
                                              widget.proj.paintTotalLitre);
                                          setState(() {
                                            _currTotalPaint++;
                                          });
                                        },
                                        tooltip: 'Add a liter(1L)',
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: () {
                                          _currTotalPaint = nullChecker(
                                              _currTotalPaint,
                                              widget.proj.paintTotalLitre);
                                          setState(() {
                                            _currTotalPaint--;
                                          });
                                        },
                                        tooltip: 'Remove a liter(1L)',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
