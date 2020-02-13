// Name : delete_tiles.dart
// Purpose : To enable user delete any project that has been created
// Function : This file contains all the structure that will ask for confirmation from the user if they want to delete the project or not

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_manager/models/Project.dart';

//DeleteTile class will run a function call _showCDPanel that will do all the confirmation of deletion
class DeleteTile extends StatelessWidget {
  final Project proj;
  final int num;
  DeleteTile({this.proj, this.num});

  @override
  Widget build(BuildContext context) {
    //Function _showCDPanel which will display a modal bottom sheet and return ConfirmDelete function
    void _showCDPanel() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return ConfirmDelete(
            proj: proj,
            num: num,
          );
        },
      );
    }

    //This Card widget will display all the project and when user tap on the project that they want to delete, it will return _showCDPanel function
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: ListTile(
            leading: Container(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                strokeWidth: 9,
                value: (((proj.paintedArea / proj.totalSurfaceAreaP) +
                        (proj.blastedArea / proj.totalSurfaceAreaB)) /
                    2),
                backgroundColor: Colors.redAccent,
                valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.lightGreenAccent),
              ),
            ),
            title: Row(
              children: <Widget>[
                Text(
                  '${num + 1}. ',
                  style: TextStyle(fontSize: 24),
                ),
                Text(
                  proj.projname,
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
            subtitle: Text('ID: ${proj.projID}\nLOCATION: ${proj.location}'),
            onTap: () {
              return _showCDPanel();
            },
          ),
        ),
      ),
    );
  }
}

//ConfirmDelete class contain all the buttons which ask the user to confirm the deletion or cancel
//The project card will also be displayed so user can double check the project that they want to delete is the right one
class ConfirmDelete extends StatefulWidget {
  final Project proj;
  final int num;
  ConfirmDelete({this.proj, this.num});
  @override
  _ConfirmDeleteState createState() => _ConfirmDeleteState();
}

class _ConfirmDeleteState extends State<ConfirmDelete> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            'Confirm to delete this project ?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton.icon(
                color: Colors.red,
                onPressed: () {
                  Firestore.instance
                      .collection('projects')
                      .document(widget.proj.projID)
                      .delete();
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                label: Text(
                  'Confirm',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              RaisedButton.icon(
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.clear),
                label: Text('Cancel'),
              ),
            ],
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Text(
                              '${(widget.proj.completion / 800 * 100).toInt()} %',
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 15),
                            child: LinearProgressIndicator(
                              value: widget.proj.completion.toDouble() / 800,
                              backgroundColor: Colors.redAccent,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.lightGreenAccent),
                            ),
                          ),
                          Text(
                            '${widget.num + 1}. ${widget.proj.projname}',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'LOCATION: ${widget.proj.location}',
                          ),
                        ],
                      ),
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
