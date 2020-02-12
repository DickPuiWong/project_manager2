// Name : wrapper.dart
// Purpose : to check if the user is new or existing and navigate them to the right page
// Function :

import 'package:flutter/material.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/screens/authenticate/authenticate.dart';
import 'package:project_manager/screens/wrapper2.dart';
import 'package:project_manager/services/database.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  //create an object called choice and assign it to Wrapper()
  final bool choice;
  Wrapper({this.choice});
  @override
  Widget build(BuildContext context) {
    //create a provider called user which will provide all the User context
    final user = Provider.of<User>(context);

    //if user is null, return the Authenticate() where showSignIn has the object choice
    if (user == null) {
      return Authenticate(
        showSignIn: choice,
      );
    }
    //if user is not null, it will return the stream provider with the value of uid and called Wrapper2()
    else {
      return StreamProvider<UserData>.value(
        value: UserDataService(uid: user.uid).userData,
        child: Wrapper2(),
      );
    }
  }
}
