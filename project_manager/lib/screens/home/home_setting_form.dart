import 'package:flutter/material.dart';
import 'package:project_manager/screens/home/HSF_extends/add_project.dart';
import 'package:project_manager/screens/home/HSF_extends/delete_project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_manager/screens/home/HSF_extends/user_manager.dart';
import 'package:project_manager/models/Project.dart';

class HSF extends StatefulWidget {
  @override
  _HSFState createState() => _HSFState();
}

class _HSFState extends State<HSF> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () {
                    List<BlastPot> t1=[];
                    Map t2={};
                    void t3(Map x,int i,BlastPot y){
                      t2['Blast Pot $i']={'Assigned num': y.num,'used abrasive':y.usedAbrasive,'used adhesive': y.usedAdhesive,'used paint': y.usedPaint};
                    }
                    for(int i=0;i<3;i++){
                      t1.add(BlastPot(num:i+1,usedAbrasive:0,usedAdhesive:0,usedPaint:0,));
                      t3(t2,i+1,t1[i]);
                    }
                    String id = Firestore.instance
                        .collection('projects')
                        .document()
                        .documentID;
                    Firestore.instance
                        .collection('projects')
                        .document(id)
                        .setData({
                      'ID': id,
                      'name': 'Dummy Project',
                      'location': 'Harbor 1',
                      'completion': 0.0,
                      'budget': 99999999.99,
                      'spent budget': 0.00,
                      'total adhesive litres': 1000,
                      'used adhesive litres': 0.0,
                      'adhesive price': 42.99,
                      'total abrasive weight': 10000.00,
                      'used abrasive weight': 0,
                      'abrasive price': 80,
                      'total paint litres': 5000,
                      'used paint litres': 0,
                      'paint price': 25.00,
                      'total area needed blasting': 1000.0,
                      'blasted area': 500.0,
                      'total area needed painting': 1000.00,
                      'painted area': 250.0,
                      'users assigned': [],
                      'blast pot': 8,
                      'blast pot list': t2,
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
                            builder: (BuildContext context) => AddProject()));
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
