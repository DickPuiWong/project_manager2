class User {
  final String uid;

  User({this.uid});
}

class UserData{
  final String uid;
  final String userName;
  final int permissionType;
  final List projList;

  UserData({this.uid, this.userName, this.permissionType, this.projList});
}