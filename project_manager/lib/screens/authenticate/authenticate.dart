// Name : authenticate.dart
// Purpose : to authenticate the user to see if they are new or existing
// Function : this file is to check if the user is an existing user or new user

import 'package:flutter/material.dart';
import 'package:project_manager/screens/authenticate/register.dart';
import 'package:project_manager/screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  //Creation of an object called showSignIn
  final bool showSignIn;
  Authenticate({this.showSignIn});
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  //declaration of showSignIn as boolean type
  bool showSignIn;

  //toggleView function will set the showSignIn to not equal to showSignIn
  void toggleView() {
    setState(() => (showSignIn = !showSignIn));
  }

  @override
  Widget build(BuildContext context) {
    //function examine will check if the showSignIn is null, it will assign the showSignIn into widget.showSignIn
    void examine() {
      if ((showSignIn) == null) {
        showSignIn = widget.showSignIn;
      }
    }

    //function examine is called here
    examine();

    //this switch case is depending on the value passed in showSignIn and will return the user to appropriate page
    if (showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}
