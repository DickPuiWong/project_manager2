// Name : add_project.dart
// Purpose : Enable user to add new project
// Function : This file contains all the structure which allows user to key in the new project details and create a new project

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_manager/shared/constants.dart';

class AddProject extends StatefulWidget {
  @override
  _AddProjectState createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  //object creation and declaration
  final _formKey = GlobalKey<FormState>();

  //variables declaration and initialisation
  double _newBudget;
  String _newName;
  String _newLocation;
  double _newAdhesiveWeight;
  double _newAbrasiveLitre;
  double _newPaintLitre;
  double _newAdhesivePrice;
  double _newAbrasivePrice;
  double _newPaintPrice;
  double _newBlastTotalArea;
  double _newPaintTotalArea;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.blue[50],

        //The app bar contains the Main title and flat button which will update all the details once user done adding in the details
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text('                Add Project'),
          actions: <Widget>[
            //When user press this button, all the details will be updated and new project will be created
            FlatButton.icon(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  String id = Firestore.instance
                      .collection('projects')
                      .document()
                      .documentID;
                  print(id);
                  Firestore.instance
                      .collection('projects')
                      .document(id)
                      .setData({
                    'ID': id,
                    'budget': _newBudget,
                    'spent budget': 0.00,
                    'name': _newName,
                    'location': _newLocation,
                    'completion': 0.0,
                    'total adhesive litres': _newAdhesiveWeight,
                    'used adhesive litres': 0.0,
                    'adhesive price': _newAdhesivePrice,
                    'total abrasive weight': _newAbrasiveLitre,
                    'used abrasive weight': 0.0,
                    'abrasive price': _newAbrasivePrice,
                    'total paint litres': _newPaintLitre,
                    'used paint litres': 0.0,
                    'paint price': _newPaintPrice,
                    'total area needed blasting': _newBlastTotalArea,
                    'blasted area': 0.0,
                    'total area needed painting': _newPaintTotalArea,
                    'painted area': 0.0,
                    'users assigned': [],
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
                                hintText: 'Location of project(address)'),
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
                                hintText: 'Total Budget to Invest(RM)'),
                            keyboardType: TextInputType.number,
                            validator: (val) =>
                                (val.isEmpty ? 'Enter an amount' : null),
                            onChanged: (val) {
                              setState(
                                  () => (_newBudget = double.tryParse(val)));
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
                                hintText: 'Total Abrasive Price(RM)'),
                            keyboardType: TextInputType.number,
                            validator: (val) =>
                                (val.isEmpty ? 'Enter an amount' : null),
                            onChanged: (val) {
                              setState(() =>
                                  (_newAbrasivePrice = double.tryParse(val)));
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
                                hintText: 'Total Adhesive Litres(L)'),
                            keyboardType: TextInputType.number,
                            validator: (val) =>
                                (val.isEmpty ? 'Enter an amount' : null),
                            onChanged: (val) {
                              setState(() =>
                                  (_newAdhesiveWeight = double.tryParse(val)));
                            },
                          ),
                          SizedBox(height: 34),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Total Adhesive Price(RM)'),
                            keyboardType: TextInputType.number,
                            validator: (val) =>
                                (val.isEmpty ? 'Enter an amount' : null),
                            onChanged: (val) {
                              setState(() =>
                                  (_newAdhesivePrice = double.tryParse(val)));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                      height:
                          34), ////////////////////////////////////////////////////////
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Colors.blue[700],
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Total Paint Litres(L)'),
                            keyboardType: TextInputType.number,
                            validator: (val) =>
                                (val.isEmpty ? 'Enter an amount' : null),
                            onChanged: (val) {
                              setState(() =>
                                  (_newPaintLitre = double.tryParse(val)));
                            },
                          ),
                          SizedBox(height: 34),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Total Paint Price(RM)'),
                            keyboardType: TextInputType.number,
                            validator: (val) =>
                                (val.isEmpty ? 'Enter an amount' : null),
                            onChanged: (val) {
                              setState(() =>
                                  (_newPaintPrice = double.tryParse(val)));
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
