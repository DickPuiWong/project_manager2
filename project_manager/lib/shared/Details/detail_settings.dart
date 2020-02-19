// Name : details_settings.dart
// Purpose : to edit the project details
// Function : This page will provide users with text field to edit the details of the project

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_manager/models/Project.dart';
import 'package:project_manager/shared/constants.dart';

class DSP extends StatefulWidget {
  final Project proj;
  DSP({this.proj});
  @override
  _DSPState createState() => _DSPState();
}

class _DSPState extends State<DSP> {
  final _formKey = GlobalKey<FormState>();

  String _currName;
  String _currLocation;
  double _currAbrasiveWeight;
  double _currAdhesiveWeight;
  double _currBlastedArea;
  double _currBlastTotalArea;
  double _currPaintedArea;
  double _currPaintTotalArea;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text('               Edit Project'),
          actions: <Widget>[
            FlatButton.icon(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  Firestore.instance
                      .collection('projects')
                      .document(widget.proj.projID)
                      .updateData(
                    {
                      'name': _currName ?? widget.proj.projname,
                      'location': _currLocation ?? widget.proj.location,
                      'completion': (((widget.proj.paintedArea /
                                  widget.proj.totalSurfaceAreaP) +
                              (widget.proj.blastedArea /
                                  widget.proj.totalSurfaceAreaB)) /
                          2),
                      'total adhesive weight':
                          _currAdhesiveWeight ?? widget.proj.adhesiveTotalLitre,
                      'total abrasive weight': _currAbrasiveWeight ??
                          widget.proj.abrasiveTotalWeight,
                      'total area needed blasting':
                          _currBlastTotalArea ?? widget.proj.totalSurfaceAreaB,
                      'blasted area':
                          _currBlastedArea ?? widget.proj.blastedArea,
                      'total area needed painting':
                          _currPaintTotalArea ?? widget.proj.totalSurfaceAreaP,
                      'painted area':
                          _currPaintedArea ?? widget.proj.paintedArea,
                    },
                  );
                  Navigator.pop(context);
                }
              },
              icon: Icon(
                Icons.update,
                color: Colors.white,
              ),
              label: Text(
                'Update',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 20),
              Column(
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Text(
                              'Project Name',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                          TextFormField(
                            initialValue: widget.proj.projname,
                            textAlign: TextAlign.center,
                            decoration: textInputDecoration.copyWith(
                              hintText: 'Project Name',
                            ),
                            validator: (val) =>
                                (val.isEmpty ? 'Enter a name' : null),
                            onChanged: (val) {
                              setState(() => (_currName = val));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 34),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Text(
                              'Project Location',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                          TextFormField(
                            initialValue: widget.proj.location,
                            textAlign: TextAlign.center,
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Project Location(address)'),
                            validator: (val) =>
                                (val.isEmpty ? 'Enter an address' : null),
                            onChanged: (val) {
                              setState(() => (_currLocation = val));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 34),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
