// Name : user.dart
// Purpose : all the variables that is needed in User class
// Function : This file contains all the declared and initialised variables for User and UserData class

class User {
  final String uid;

  User({this.uid});
}

////////////////////////////////////////////////////////////////////////////////

class UserData {
  final String uid;
  final String userName;
  final int permissionType;
  final List projList;

  UserData({this.uid, this.userName, this.permissionType, this.projList});
}
