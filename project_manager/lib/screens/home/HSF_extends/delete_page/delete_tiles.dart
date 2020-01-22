import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_manager/models/Project.dart';

class DeleteTile extends StatelessWidget {
  final Project proj;
  final int num;
  DeleteTile({this.proj, this.num});

  @override
  Widget build(BuildContext context) {
    void _showCDPanel() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return  ConfirmDelete(
              proj: proj,
              num: num,
            );
        },
      );
    }

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
