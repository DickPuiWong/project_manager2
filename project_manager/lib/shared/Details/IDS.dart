// Name : IDS.dart
// Purpose :
// Function :

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_manager/models/Project.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/services/database.dart';
import 'package:provider/provider.dart';

class IDSWrapper extends StatelessWidget {
  final Project project;
  IDSWrapper({this.project});
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UserData>>.value(
      value: UsersDatabaseService().usersData,
      child: StreamProvider<Project>.value(
        value: ProjectDatabaseService(projID: project.projID).project,
        child: SafeArea(
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
                    ],
                  ),
                  Text(
                    'Assigned',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Flexible(
                    child: IDSAssignedList(),
                  ),
                  Text(
                    'Not Assigned',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Flexible(
                    child: IDSNotAssignedList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class IDSAssignedList extends StatefulWidget {
  @override
  _IDSAssignedListState createState() => _IDSAssignedListState();
}

class _IDSAssignedListState extends State<IDSAssignedList> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<UserData>>(context);
    final project = Provider.of<Project>(context);
    List<UserData> assignedUserList = [];
    List<bool> assignedList = [];

    for (int i = 0; i < users.length; i++) {
      for (int ii = 0; ii < users[i].projList.length; ii++) {
        bool assigned = false;
        for (int iii = 0; iii < project.userAssigned.length; iii++) {
          if (users[i].uid == project.userAssigned[iii]) {
            if (users[i].projList[ii] == project.projID) {
              assignedUserList.add(users[i]);
              assigned = true;
              assignedList.add(assigned);
            }
          }
        }
      }
    }

    if (assignedUserList.length == 0) {
      return Center(
        child: Text('No one is assigned'),
      );
    } else {
      return ListView.builder(
        itemCount: assignedUserList.length,
        itemBuilder: (context, index) {
          return IDSTiles(
            currUser: assignedUserList[index],
            assigned: assignedList[index],
            project: project,
          );
        },
      );
    }
  }
}

class IDSNotAssignedList extends StatefulWidget {
  @override
  _IDSNotAssignedListState createState() => _IDSNotAssignedListState();
}

class _IDSNotAssignedListState extends State<IDSNotAssignedList> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<UserData>>(context);
    final project = Provider.of<Project>(context);
    List<UserData> notAssignedUserList = [];
    List<bool> assignedList = [];

    bool listChecker(UserData user) {
      bool x = false;
      for (int i = 0; i < notAssignedUserList.length; i++) {
        if (notAssignedUserList[i] == user) {
          x = true;
        }
      }
      if (x == false) {
        notAssignedUserList.add(user);
      }
      return x;
    }

    for (int ii = 0; ii < users.length; ii++) {
      bool assigned = false;
      if (users[ii].projList.length < 1) {
        listChecker(users[ii]);
        assignedList.add(assigned);
      } else {
        for (int iii = 0; iii < users[ii].projList.length; iii++) {
          if (project.projID == users[ii].projList[iii]) {
            assigned = true;
            iii = users[ii].projList.length;
          }
        }
        if (assigned == false) {
          listChecker(users[ii]);
          assignedList.add(assigned);
        }
      }
    }

    return ListView.builder(
      itemCount: notAssignedUserList.length,
      itemBuilder: (context, index) {
        return IDSTiles(
          currUser: notAssignedUserList[index],
          assigned: assignedList[index],
          project: project,
        );
      },
    );
  }
}

class IDSTiles extends StatefulWidget {
  final UserData currUser;
  final bool assigned;
  final Project project;
  IDSTiles({this.currUser, this.assigned, this.project});
  @override
  _IDSTilesState createState() => _IDSTilesState();
}

class _IDSTilesState extends State<IDSTiles> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Card(
        elevation: 0.0,
        child: Container(
          child: ListTile(
            dense: true,
            onTap: () {},
            onLongPress: () {},
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.currUser.userName,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            subtitle: Text('${widget.assigned.toString()}'),
            trailing: IconButton(
              tooltip: '${widget.currUser.projList}',
              icon: Icon(Icons.settings),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return SheetChanger(
                      user: widget.currUser,
                      assigned: widget.assigned,
                      project: widget.project,
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class SheetChanger extends StatefulWidget {
  final UserData user;
  final bool assigned;
  final Project project;
  SheetChanger({this.user, this.assigned, this.project});
  @override
  _SheetChangerState createState() => _SheetChangerState();
}

class _SheetChangerState extends State<SheetChanger> {
  @override
  Widget build(BuildContext context) {
    if (widget.assigned == true) {
      return UnassignSheet(
        user: widget.user,
        assigned: widget.assigned,
        project: widget.project,
      );
    } else {
      return AssignSheet(
        user: widget.user,
        assigned: widget.assigned,
        project: widget.project,
      );
    }
  }
}

class AssignSheet extends StatefulWidget {
  final UserData user;
  final bool assigned;
  final Project project;
  AssignSheet({this.user, this.assigned, this.project});
  @override
  _AssignSheetState createState() => _AssignSheetState();
}

class _AssignSheetState extends State<AssignSheet> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Form(
      key: _formKey,
      child: Dialog(
        child: Container(
          padding: EdgeInsets.all(10),
          height: 130,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(height: 5),
              Text(
                'Assign?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton.icon(
                    onPressed: () async {
                      List assignToListP(List inList) {
                        List<String> newList = [];
                        for (int i = 0; i < inList.length; i++) {
                          newList.add(inList[i]);
                        }
                        newList.add(widget.user.uid);
                        return newList;
                      }

                      List assignToListU(List inList) {
                        List<String> newList = [];
                        for (int i = 0; i < inList.length; i++) {
                          newList.add(inList[i]);
                        }
                        newList.add(widget.project.projID);
                        return newList;
                      }

                      await Firestore.instance
                          .collection('projects')
                          .document(widget.project.projID)
                          .setData({
                        'ID': widget.project.projID,
                        'name': widget.project.projname,
                        'location': widget.project.location,
                        'completion': widget.project.completion,
                        'budget': widget.project.budget,
                        'spent budget': widget.project.spentBudget,
                        'total adhesive litres':
                            widget.project.adhesiveTotalLitre,
                        'used adhesive litres':
                            widget.project.adhesiveUsedLitre,
                        'adhesive price': widget.project.adhesivePrice,
                        'total abrasive weight':
                            widget.project.abrasiveTotalWeight,
                        'used abrasive weight':
                            widget.project.abrasiveUsedWeight,
                        'abrasive price': widget.project.abrasivePrice,
                        'total paint litres': widget.project.paintTotalLitre,
                        'used paint litres': widget.project.paintUsedLitre,
                        'paint price': widget.project.paintPrice,
                        'total area needed blasting':
                            widget.project.totalSurfaceAreaB,
                        'blasted area': widget.project.blastedArea,
                        'total area needed painting':
                            widget.project.totalSurfaceAreaP,
                        'painted area': widget.project.paintedArea,
                        'users assigned':
                            assignToListP(widget.project.userAssigned),
                        'blast pot': widget.project.blastPot,
                        'blast pot list': widget.project.blastPotList,
                        'budget list': widget.project.budgetList,
                        'Date Created': widget.project.date,
                      });
                      await Firestore.instance
                          .collection('UserData')
                          .document(widget.user.uid)
                          .setData({
                        'ID': widget.user.uid,
                        'Username': widget.user.userName,
                        'permissionType': widget.user.permissionType,
                        'projList': assignToListU(widget.user.projList),
                      });
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.check,
                      color: Colors.lightGreenAccent[400],
                    ),
                    label: Text('Yes'),
                  ),
                  FlatButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.clear,
                      color: Colors.redAccent,
                    ),
                    label: Text('No'),
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

class UnassignSheet extends StatefulWidget {
  final UserData user;
  final bool assigned;
  final Project project;
  UnassignSheet({this.user, this.assigned, this.project});
  @override
  _UnassignSheetState createState() => _UnassignSheetState();
}

class _UnassignSheetState extends State<UnassignSheet> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Form(
      key: _formKey,
      child: Dialog(
        child: Container(
          padding: EdgeInsets.all(10),
          height: 130,
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(height: 5),
              Text(
                'Unassign?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton.icon(
                    onPressed: () async {
                      List unassignToListP(List inList) {
                        List<String> newList = [];
                        for (int i = 0; i < inList.length; i++) {
                          if (inList[i] != widget.user.uid) {
                            newList.add(inList[i]);
                          }
                        }
                        return newList;
                      }

                      List unassignToListU(List inList) {
                        List<String> newList = [];
                        for (int i = 0; i < inList.length; i++) {
                          if (inList[i] != widget.project.projID) {
                            newList.add(inList[i]);
                          }
                        }
                        return newList;
                      }

                      await Firestore.instance
                          .collection('projects')
                          .document(widget.project.projID)
                          .setData({
                        'ID': widget.project.projID,
                        'name': widget.project.projname,
                        'location': widget.project.location,
                        'completion': widget.project.completion,
                        'budget': widget.project.budget,
                        'spent budget': widget.project.spentBudget,
                        'total adhesive litres':
                            widget.project.adhesiveTotalLitre,
                        'used adhesive litres':
                            widget.project.adhesiveUsedLitre,
                        'adhesive price': widget.project.adhesivePrice,
                        'total abrasive weight':
                            widget.project.abrasiveTotalWeight,
                        'used abrasive weight':
                            widget.project.abrasiveUsedWeight,
                        'abrasive price': widget.project.abrasivePrice,
                        'total paint litres': widget.project.paintTotalLitre,
                        'used paint litres': widget.project.paintUsedLitre,
                        'paint price': widget.project.paintPrice,
                        'total area needed blasting':
                            widget.project.totalSurfaceAreaB,
                        'blasted area': widget.project.blastedArea,
                        'total area needed painting':
                            widget.project.totalSurfaceAreaP,
                        'painted area': widget.project.paintedArea,
                        'users assigned':
                            unassignToListP(widget.project.userAssigned),
                        'blast pot': widget.project.blastPot,
                        'blast pot list': widget.project.blastPotList,
                        'Date Created': widget.project.date,
                      });
                      await Firestore.instance
                          .collection('UserData')
                          .document(widget.user.uid)
                          .setData({
                        'ID': widget.user.uid,
                        'Username': widget.user.userName,
                        'permissionType': widget.user.permissionType,
                        'projList': unassignToListU(widget.user.projList),
                      });
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.check,
                      color: Colors.lightGreenAccent[400],
                    ),
                    label: Text('Yes'),
                  ),
                  FlatButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.clear,
                      color: Colors.redAccent,
                    ),
                    label: Text('No'),
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
