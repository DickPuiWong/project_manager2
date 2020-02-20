// Name : add_project.dart
// Purpose : Enable user to add new project
// Function : This file contains all the structure which allows user to key in the new project details and create a new project

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_manager/shared/constants.dart';
import 'package:project_manager/models/Project.dart';

class AddProject extends StatefulWidget {
  @override
  _AddProjectState createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  //object creation and declaration
  final _formKey = GlobalKey<FormState>();

  //variables declaration and initialisation
//  double _newBudget;
  String _newName;
  String _newLocation;
  double _newAdhesiveWeight;
  double _newAbrasiveLitre;
//  double _newAdhesivePrice;
//  double _newAbrasivePrice;
  double _newBlastTotalArea;
  double _newPaintTotalArea;
  List _newSupervisor;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.blue[50],

        //The app bar contains the Main title and flat button which will update all the details once user done adding in the details
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Center(child: Text('Add Project')),
          actions: <Widget>[
            //When user press this button, all the details will be updated and new project will be created
            FlatButton.icon(
              onPressed: () {
//                var date = new DateTime.now();
//                List<String> t1 = [
//                  'Abrasive',
//                  'Adhesive',
//                  'Consumables',
//                  'Diesel/Electric meter',
//                  'Equipment',
//                  'Food',
//                  'Freight & Delivery',
//                  'Labour',
//                  'Material & Supplies',
//                  'Paint',
//                  'Water',
//                ];
//                Map t2 = {};
//                void t3(Map x, int i, BlastPot y) {
//                  t2['bp$i'] = {
//                    'Assigned num': y.num,
//                    'refills done': y.refillsDone,
//                    'used abrasive': y.usedAbrasive,
//                    'used HoldTight': y.usedHoldTight,
//                    'used hours': y.usedHours
//                  };
//                }
//
//                for (int i = 0; i < 3; i++) {
//                  t3(
//                      t2,
//                      i + 1,
//                      BlastPot(
//                        num: i + 1,
//                        refillsDone: 0,
//                        usedAbrasive: 0,
//                        usedHoldTight: 0,
//                        usedHours: 0,
//                      ));
//                }
//                Map t4 = {};
//                for (int i = 0; i < t1.length; i++) {
//                  t4['bt${i + 1}'] = {
//                    'name': t1[i],
//                    'spent': 0,
//                    'estimate': 0,
//                  };
//                }
//                Map t5 = {};
//                t5['pt1'] = {
//                  'name': 'Blasting',
//                  'done': 500.0,
//                  'total': 1000.0,
//                };
//                t5['pt2'] = {
//                  'name': 'Painting',
//                  'done': 200.0,
//                  'total': 1000.0,
//                };
//                Map t6 = {'abrasive': 5.0, 'HoldTight': 1.0};

                if (_formKey.currentState.validate()) {
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

                  for (int i = 0; i < 3; i++) {
                    t3(
                        t2,
                        i + 1,
                        BlastPot(
                          num: i + 1,
                          refillsDone: 0,
                          usedAbrasive: 0,
                          usedHoldTight: 0,
                          usedHours: 0,
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
                    'done': 0.0,
                    'total': 0.0,
                  };
                  t5['pt2'] = {
                    'name': 'Painting',
                    'done': 0.0,
                    'total': 0.0,
                  };
                  Map t6 = {'abrasive': 5.0, 'HoldTight': 1.0};

                  String id = Firestore.instance
                      .collection('projects')
                      .document()
                      .documentID;
                  Firestore.instance
                      .collection('projects')
                      .document(id)
                      .setData({
                    'ID': id,
                    'name': _newName,
                    'location': _newLocation,
                    'total adhesive litres': _newAdhesiveWeight,
                    'used adhesive litres': 0.0,
                    'total abrasive weight': 0.0,
                    'used abrasive weight': _newAbrasiveLitre,
                    'total paint litres': 0.0,
                    'used paint litres': 0.0,
                    'total area needed blasting': _newBlastTotalArea,
                    'blasted area': 0.0,
                    'total area needed painting': _newPaintTotalArea,
                    'painted area': 0.0,
                    'users assigned': [],
                    'project supervisor': _newSupervisor,
                    'blast pot': 3,
                    'per fill': t6,
                    'blast pot list': t2,
                    'budget list': t4,
                    'progresses tracked': t5,
                    'Date Created': date.millisecondsSinceEpoch,
                  });
                  Navigator.pop(context);
                }
              },
              color: Colors.blue[900],
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: Text(
                'Create',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),

        //The body of this Scaffold will contains all the text field that enables the user to key in any relevant field in the new project
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 10,
          ),
          child: ListView(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(
                      'Create New Project',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900]),
                    ),
                  ),
                  Divider(
                    height: 48,
                    thickness: 1.2,
                    color: Colors.blue[200],
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      color: Colors.blue[700],
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                hintText: 'New Project Name'),
                            validator: (val) =>
                                (val.isEmpty ? 'Enter a name' : null),
                            onChanged: (val) {
                              setState(() => (_newName = val));
                            },
                          ),
                          SizedBox(height: 34),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Location of project'),
                            validator: (val) => (val.isEmpty
                                ? 'Enter a location(address)'
                                : null),
                            onChanged: (val) {
                              setState(() => (_newLocation = val));
                            },
                          ),
                          SizedBox(height: 34),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Supervisor name'),
                            validator: (val) =>
                                (val.isEmpty ? 'Enter a name' : null),
                            onChanged: (val) {
                              setState(() => (_newSupervisor = [val]));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 34),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Colors.blue[700],
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Total Abrasive Weight(kg)'),
                            keyboardType: TextInputType.number,
                            validator: (val) =>
                                (val.isEmpty ? 'Enter an amount' : null),
                            onChanged: (val) {
                              setState(() =>
                                  (_newAbrasiveLitre = double.tryParse(val)));
                            },
                          ),
                          SizedBox(height: 34),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Total HoldTight(litres)'),
                            keyboardType: TextInputType.number,
                            validator: (val) =>
                                (val.isEmpty ? 'Enter an amount' : null),
                            onChanged: (val) {
                              setState(() =>
                                  (_newAdhesiveWeight = double.tryParse(val)));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 34),
//                  ClipRRect(
//                    borderRadius: BorderRadius.circular(5),
//                    child: Container(
//                      padding: EdgeInsets.all(5),
//                      color: Colors.blue[700],
//                      child: Column(
//                        children: <Widget>[
//                          TextFormField(
//                            decoration: textInputDecoration.copyWith(
//                                hintText: 'Total Adhesive Litres(L)'),
//                            keyboardType: TextInputType.number,
//                            validator: (val) =>
//                                (val.isEmpty ? 'Enter an amount' : null),
//                            onChanged: (val) {
//                              setState(() =>
//                                  (_newAdhesiveWeight = double.tryParse(val)));
//                            },
//                          ),
//                          SizedBox(height: 34),
//                          TextFormField(
//                            decoration: textInputDecoration.copyWith(
//                                hintText: 'Total Adhesive Price(RM)'),
//                            keyboardType: TextInputType.number,
//                            validator: (val) =>
//                                (val.isEmpty ? 'Enter an amount' : null),
//                            onChanged: (val) {
//                              setState(() =>
//                                  (_newAdhesivePrice = double.tryParse(val)));
//                            },
//                          ),
//                        ],
//                      ),
//                    ),
//                  ),
//                  SizedBox(
//                      height:
//                          34), ////////////////////////////////////////////////////////
//                  ClipRRect(
//                    borderRadius: BorderRadius.circular(5),
//                    child: Container(
//                      padding: EdgeInsets.all(5),
//                      color: Colors.blue[700],
//                      child: Column(
//                        children: <Widget>[
//                          TextFormField(
//                            decoration: textInputDecoration.copyWith(
//                                hintText: 'Total Paint Litres(L)'),
//                            keyboardType: TextInputType.number,
//                            validator: (val) =>
//                                (val.isEmpty ? 'Enter an amount' : null),
//                            onChanged: (val) {
//                              setState(() =>
//                                  (_newPaintLitre = double.tryParse(val)));
//                            },
//                          ),
//                          SizedBox(height: 34),
//                          TextFormField(
//                            decoration: textInputDecoration.copyWith(
//                                hintText: 'Total Paint Price(RM)'),
//                            keyboardType: TextInputType.number,
//                            validator: (val) =>
//                                (val.isEmpty ? 'Enter an amount' : null),
//                            onChanged: (val) {
//                              setState(() =>
//                                  (_newPaintPrice = double.tryParse(val)));
//                            },
//                          ),
//                        ],
//                      ),
//                    ),
//                  ),
//                  SizedBox(height: 34),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      color: Colors.blue[700],
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Total Area Needed to Blast(m^2)'),
                            keyboardType: TextInputType.number,
                            validator: (val) =>
                                (val.isEmpty ? 'Enter an amount' : null),
                            onChanged: (val) {
                              setState(() =>
                                  (_newBlastTotalArea = double.tryParse(val)));
                            },
                          ),
                          SizedBox(height: 34),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Total Area Needed to Paint(m^2)'),
                            keyboardType: TextInputType.number,
                            validator: (val) =>
                                (val.isEmpty ? 'Enter an amount' : null),
                            onChanged: (val) {
                              setState(() =>
                                  (_newPaintTotalArea = double.tryParse(val)));
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
