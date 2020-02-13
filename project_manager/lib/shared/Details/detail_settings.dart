// Name : details_settings.dart
// Purpose : to edit the project details
// Function : This page will provide users with text field to edit the details of the project

import 'package:cloud_firestore/cloud_firestore.dart';
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
  double _currAbrasivePrice;
  double _currAdhesiveWeight;
  double _currAdhesivePrice;
  double _currBlastedArea;
  double _currBlastTotalArea;
  double _currPaintedArea;
  double _currPaintTotalArea;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.indigo[50],
        appBar: AppBar(
          backgroundColor: Colors.indigo[900],
          title: Text('Edit Project'),
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
                      'adhesive price':
                          _currAdhesivePrice ?? widget.proj.adhesivePrice,
                      'total abrasive weight': _currAbrasiveWeight ??
                          widget.proj.abrasiveTotalWeight,
                      'abrasive price':
                          _currAbrasivePrice ?? widget.proj.abrasivePrice,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'PROJECT NAME: ',
                          style: TextStyle(fontSize: 24),
                        ),
                        TextFormField(
                          initialValue: widget.proj.projname,
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Project Name'),
                          validator: (val) =>
                              (val.isEmpty ? 'Enter a name' : null),
                          onChanged: (val) {
                            setState(() => (_currName = val));
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
                          'LOCATION(address): ',
                          style: TextStyle(fontSize: 24),
                        ),
                        TextFormField(
                          initialValue: widget.proj.location,
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
                  SizedBox(height: 34),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'ADHESIVE, ',
                          style: TextStyle(fontSize: 24),
                        ),
                        Text(
                          'Total Weight(kg): ',
                          style: TextStyle(fontSize: 16),
                        ),
                        TextFormField(
                          initialValue:
                              widget.proj.adhesiveTotalLitre.toString(),
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Total Adhesive Weight'),
                          validator: (val) =>
                              (val.isEmpty ? 'Enter a value' : null),
                          onChanged: (val) {
                            setState(() =>
                                (_currAdhesiveWeight = double.tryParse(val)));
                          },
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Total Price(RM): ',
                          style: TextStyle(fontSize: 19),
                        ),
                        TextFormField(
                          initialValue: widget.proj.adhesivePrice.toString(),
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Total Adhesive Price'),
                          validator: (val) =>
                              (val.isEmpty ? 'Enter a value' : null),
                          onChanged: (val) {
                            setState(() =>
                                (_currAdhesiveWeight = double.tryParse(val)));
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
                          'ABRASIVE, ',
                          style: TextStyle(fontSize: 24),
                        ),
                        Text(
                          'Total Weight(kg): ',
                          style: TextStyle(fontSize: 16),
                        ),
                        TextFormField(
                          initialValue:
                              widget.proj.abrasiveTotalWeight.toString(),
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Total Abrasive Weight'),
                          validator: (val) =>
                              (val.isEmpty ? 'Enter a value' : null),
                          onChanged: (val) {
                            setState(() =>
                                (_currAbrasiveWeight = double.tryParse(val)));
                          },
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Total Price(RM): ',
                          style: TextStyle(fontSize: 19),
                        ),
                        TextFormField(
                          initialValue: widget.proj.abrasivePrice.toString(),
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Total Abrasive Price'),
                          validator: (val) =>
                              (val.isEmpty ? 'Enter a value' : null),
                          onChanged: (val) {
                            setState(() =>
                                (_currAbrasivePrice = double.tryParse(val)));
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
                          'Blast Applied, ',
                          style: TextStyle(fontSize: 24),
                        ),
                        Text(
                          'Blasted Areas(m^2): ',
                          style: TextStyle(fontSize: 16),
                        ),
                        TextFormField(
                          initialValue: widget.proj.blastedArea.toString(),
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Total Abrasive Weight'),
                          validator: (val) =>
                              (val.isEmpty ? 'Enter a value' : null),
                          onChanged: (val) {
                            setState(() =>
                                (_currBlastedArea = double.tryParse(val)));
                          },
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Total Area Needed to be Blasted(m^2): ',
                          style: TextStyle(fontSize: 19),
                        ),
                        TextFormField(
                          initialValue:
                              widget.proj.totalSurfaceAreaB.toString(),
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Total Abrasive Price'),
                          validator: (val) =>
                              (val.isEmpty ? 'Enter a value' : null),
                          onChanged: (val) {
                            setState(() =>
                                (_currBlastTotalArea = double.tryParse(val)));
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
                          'Total Area Painted(m^2): ',
                          style: TextStyle(fontSize: 16),
                        ),
                        TextFormField(
                          initialValue: widget.proj.paintedArea.toString(),
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Total Area Painted'),
                          validator: (val) =>
                              (val.isEmpty ? 'Enter area Painted' : null),
                          onChanged: (val) {
                            setState(() =>
                                (_currPaintedArea = double.tryParse(val)));
                          },
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Total Area Needed to be Paint(m^2): ',
                          style: TextStyle(fontSize: 19),
                        ),
                        TextFormField(
                          initialValue: widget.proj.abrasivePrice.toString(),
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Total Area Needed to Paint(m^2)'),
                          validator: (val) => (val.isEmpty
                              ? 'Enter area needed to be paint'
                              : null),
                          onChanged: (val) {
                            setState(() =>
                                (_currPaintTotalArea = double.tryParse(val)));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
