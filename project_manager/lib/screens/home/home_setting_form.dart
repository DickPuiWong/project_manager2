import 'package:flutter/material.dart';
import 'package:project_manager/models/BlastPotData.dart';
import 'package:project_manager/screens/home/HSF_extends/add_project.dart';
import 'package:project_manager/screens/home/HSF_extends/delete_project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_manager/screens/home/HSF_extends/user_manager.dart';
import 'package:project_manager/models/Project.dart';
import 'package:project_manager/services/database.dart';
import 'package:provider/provider.dart';

class HSFWrapper extends StatefulWidget {
  @override
  _HSFWrapperState createState() => _HSFWrapperState();
}

class _HSFWrapperState extends State<HSFWrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<BlastPotDetails>>.value(
      value: AllBPDatabaseService().blastPotDatas,
      child: HSF(),
    );
  }
}

class HSF extends StatefulWidget {
  @override
  _HSFState createState() => _HSFState();
}

class _HSFState extends State<HSF> {
  final _formKey = GlobalKey<FormState>();
  List<BlastPotDetails> bpList = [];

  @override
  Widget build(BuildContext context) {
    bpList = Provider.of<List<BlastPotDetails>>(context);

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Settings Menu',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(
            thickness: 1.2,
            height: 29,
            color: Colors.indigo[300],
            indent: 5,
            endIndent: 5,
          ),
          Flexible(
            child: GridView.count(
              shrinkWrap: true,
              padding: EdgeInsets.all(10),
              crossAxisCount: 3,
              primary: false,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: <Widget>[
                FlatButton(
                  onPressed: () async {
                    var date = new DateTime.now();
                    List<String> t1 = [
                      'Abrasive',
                      'Adhesive',
                      'Consumables',
                      'Diesel/Electric meter',
                      'Equipment',
                      'Food',
                      'Freight & Delivery',
                      'Labour',
                      'Material & Supplies',
                      'Paint',
                      'Water',
                    ];
                    Map t2 = {};
                    void t3(Map x, int i, BlastPot y) {
                      t2['bp$i'] = {
                        'Assigned num': y.num,
                        'refills done': y.refillsDone,
                        'used abrasive': y.usedAbrasive,
                        'used HoldTight': y.usedHoldTight,
                        'used hours': y.usedHours
                      };
                    }

                    void creator(int i) async {
                      String id1 = Firestore.instance
                          .collection('BPData')
                          .document()
                          .documentID;
                      Firestore.instance
                          .collection('BPData')
                          .document(id1)
                          .setData({
                        'id': id1,
                        'num': i + 1,
                        'used hours': 0.0,
                      });
                      setState(() {
                        bpList[i] = BlastPotDetails(
                          id: id1,
                          num: i + 1,
                          totalUsedHours: 0.0,
                        );
                      });
                    }

                    for (int i = 0; i < 3; i++) {
                      bpList.add(BlastPotDetails());
                      if (bpList.length < 1) {
                        creator(i);
                      }
                      if (bpList[i].totalUsedHours == null) {
                        creator(i);
                      }
                      t3(
                          t2,
                          i + 1,
                          BlastPot(
                            num: i + 1,
                            refillsDone: 0,
                            usedAbrasive: 0,
                            usedHoldTight: 0,
                            usedHours:
                                (bpList[i].totalUsedHours ?? 0).toDouble(),
                          ));
                    }
                    Map t4 = {};
                    for (int i = 0; i < t1.length; i++) {
                      t4['bt${i + 1}'] = {
                        'name': t1[i],
                        'spent': 0,
                        'estimate': 0,
                      };
                    }
                    Map t5 = {};
                    t5['pt1'] = {
                      'name': 'Blasting',
                      'done': 500.0,
                      'total': 1000.0,
                    };
                    t5['pt2'] = {
                      'name': 'Painting',
                      'done': 250.0,
                      'total': 1000.0,
                    };
                    Map t6 = {'abrasive': 5.0, 'HoldTight': 1.0};

                    String id2 = Firestore.instance
                        .collection('projects')
                        .document()
                        .documentID;
                    await Firestore.instance
                        .collection('projects')
                        .document(id2)
                        .setData({
                      'ID': id2,
                      'name': 'Dummy Project',
                      'location': 'Harbor 1',
                      'total adhesive litres': 1000,
                      'used adhesive litres': 0.0,
                      'total abrasive weight': 40.00,
                      'used abrasive weight': 0,
                      'total paint litres': 5000,
                      'used paint litres': 0,
                      'total area needed blasting': 1000.0,
                      'blasted area': 500.0,
                      'total area needed painting': 1000.00,
                      'painted area': 250.0,
                      'users assigned': [],
                      'project supervisor': ['zac', 2],
                      'blast pot': 3,
                      'per fill': t6,
                      'blast pot list': t2,
                      'budget list': t4,
                      'progresses tracked': t5,
                      'Date Created': date.millisecondsSinceEpoch,
                    });
                  },
                  color: Colors.indigo[900],
                  child: Text(
                    'Add Dummy Project',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => AddWrapper()));
                  },
                  color: Colors.indigo[900],
                  child: Text(
                    'Add Project',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                DeleteProject()));
                  },
                  color: Colors.red[600],
                  child: Text(
                    'Delete Project',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => UserManager()));
                  },
                  color: Colors.amberAccent[400],
                  child: Text(
                    'User Manager',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
//                FlatButton(
//                  onPressed: () {
//                    Map x = {};
//                    x['ff'] = {
//                      ['tyty']: 'ty',
//                      ['yuyu']: 124356798
//                    };
//                    print('x --- $x');
//                  },
//                  color: Colors.amberAccent[400],
//                  child: Text(
//                    'test',
//                    textAlign: TextAlign.center,
//                    style: TextStyle(
//                      fontWeight: FontWeight.bold,
//                      fontSize: 18,
//                    ),
//                  ),
//                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
