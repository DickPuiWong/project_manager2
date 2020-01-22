import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_manager/models/Project.dart';
import 'package:project_manager/services/database.dart';
import 'package:provider/provider.dart';

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
      for (int i = 0; i < list.length; i++) {
        bpList.add(bpMaker(project.blastPotList, i));
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
                  Text(
                    'Blast Pots assigned: ${project.blastPot.toInt()}',
                    style: TextStyle(fontSize: 22),
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
                              '${project.abrasiveUsedWeight}(${project.abrasiveUsedWeight / 250})'),
                          Text('${project.adhesiveUsedLitre}'),
                          Text('${project.paintUsedLitre}'),
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
                          Text(
                            'paint(L)',
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
                              '${project.abrasiveTotalWeight}(${project.abrasiveTotalWeight / 250})'),
                          Text('${project.adhesiveTotalLitre}'),
                          Text('${project.paintTotalLitre}'),
                        ],
                      ),
                    ],
                  ),
                  Divider(
                    height: 10,
                    color: Colors.indigo,
                  ),
                ],
              ),
              SizedBox(height: 34),
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
                    'Abrasive used : ${widget.bp.usedAbrasive} kg(${widget.bp.usedAbrasive / 250} bag/bags)'),
                Text('Adhesive used : ${widget.bp.usedAdhesive} L'),
                Text('Paint used : ${widget.bp.usedPaint} L'),
              ],
            ),
            trailing: Column(
              children: <Widget>[
                IconButton(
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
              ],
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
                        Map map1={};
                        void t3(int i,Map y){
                          map1['Blast Pot $i']=y;
                        }
                        for(int i=0;i<widget.proj.blastPotList.length;i++){
                          if(i==widget.bp.num-1){
                            t3(i+1,widget.proj.blastPotList['Blast Pot ${i+1}']);
                            print(map1['Blast Pot ${i+1}']['Assigned num']);
                            print(map1['Blast Pot ${i+1}']['used abrasive']);
                            print(map1['Blast Pot ${i+1}']['used adhesive']);
                            print(map1['Blast Pot ${i+1}']['used paint']);
                          }
                        }

//                        await Firestore.instance
//                            .collection('projects')
//                            .document(widget.proj.projID)
//                            .setData({
//                          'blast pot': widget.proj.blastPot,
//                          'used abrasive weight':
//                              (widget.proj.abrasiveUsedWeight),
//                          'total abrasive weight':
//                              widget.proj.abrasiveTotalWeight,
//                          'used adhesive litres':
//                              (widget.proj.adhesiveUsedLitre),
//                          'total adhesive litres':
//                              widget.proj.adhesiveTotalLitre,
//                          'used paint litres': (widget.proj.paintUsedLitre),
//                          'total paint litres': widget.proj.paintTotalLitre,
//                          'ID': widget.proj.projID,
//                          'name': widget.proj.projname,
//                          'location': widget.proj.location,
//                          'completion': widget.proj.completion,
//                          'budget': widget.proj.budget,
//                          'spent budget': widget.proj.spentBudget,
//                          'adhesive price': widget.proj.adhesivePrice,
//                          'abrasive price': widget.proj.abrasivePrice,
//                          'paint price': widget.proj.paintPrice,
//                          'total area needed blasting':
//                              widget.proj.totalSurfaceAreaB,
//                          'blasted area': widget.proj.blastedArea,
//                          'total area needed painting':
//                              widget.proj.totalSurfaceAreaP,
//                          'painted area': widget.proj.paintedArea,
//                          'users assigned': widget.proj.userAssigned,
//                          'blast pot list':
//                              bpListChanger(widget.proj.blastPotList),
//                        });
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
  double _currUsedAdhesive;
  double _currUsedPaint;
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
      child: Dialog(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: Container(
            height: 251,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Blast Pot ${widget.bp.num}',
                        style: TextStyle(
                          fontSize: 24.8,
                          fontWeight: FontWeight.bold,
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
                                        '${(_currUsedAbrasive ?? widget.bp.usedAbrasive).toStringAsFixed(2)}kg (${((_currUsedAbrasive ?? widget.bp.usedAbrasive) / 250).toStringAsFixed(2)} bags)'),
                              ],
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
                                    _currUsedAbrasive += 250;
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
                                    _currUsedAbrasive -= 250;
                                  });
                                },
                                tooltip: 'Remove',
                              ),
                            ],
                          ),
                        ],
                      ),
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
                          Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  _currUsedAdhesive = nullChecker(
                                      _currUsedAdhesive,
                                      widget.bp.usedAdhesive);
                                  setState(() {
                                    _currUsedAdhesive++;
                                  });
                                },
                                tooltip: 'Add',
                              ),
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  _currUsedAdhesive = nullChecker(
                                      _currUsedAdhesive,
                                      widget.bp.usedAdhesive);
                                  setState(() {
                                    _currUsedAdhesive--;
                                  });
                                },
                                tooltip: 'Remove',
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: 'Used Paint : \n',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                    text:
                                        '${(_currUsedPaint ?? widget.bp.usedPaint).toStringAsFixed(2)}L'),
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  _currUsedPaint = nullChecker(
                                      _currUsedPaint, widget.bp.usedPaint);
                                  setState(() {
                                    _currUsedPaint++;
                                  });
                                },
                                tooltip: 'Add',
                              ),
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  _currUsedPaint = nullChecker(
                                      _currUsedPaint, widget.bp.usedPaint);
                                  setState(() {
                                    _currUsedPaint--;
                                  });
                                },
                                tooltip: 'Remove',
                              ),
                            ],
                          ),
                        ],
                      ),
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
                            'used paint litres': (widget.proj.paintUsedLitre +
                                ((_currUsedPaint ??
                                        widget.proj.paintUsedLitre) -
                                    widget.bp.usedPaint)),
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
                          for (int i = widget.proj.blastPotList.length - 1;
                              i < (widget.proj.blastPot).toInt();
                              i++) {
                            mapItem['Blast Pot ${i + 1}'] = {
                              'Assigned num': i + 1,
                              'used abrasive': 0.0,
                              'used adhesive': 0.0,
                              'used paint': 0.0,
                            };
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
//                                          _currBlastPotNo = nullChecker(
//                                              _currBlastPotNo,
//                                              widget.proj.blastPot);
//                                          setState(() {
//                                            _currBlastPotNo--;
//                                          });
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
