// Name : register.dart
// Purpose : to enable the new user to register
// Function : prompt the new user to enter their email and password to register

import 'package:flutter/material.dart';
import 'package:project_manager/services/auth.dart';
import 'package:project_manager/shared/constants.dart';
import 'package:project_manager/shared/loading.dart';

//Register class will contain all the functionality where it will collect the user email and password to proceed in registering the new user
class Register extends StatefulWidget {
  //Creation of an object called toggleView and put it in the class Register()
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // declare and initialise the objects and variables
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text fields needed in this class
  String email = '';
  String password = '';
  String userName = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    //Register class will return a loading page while waiting to display the Scaffold that shows the register page
    return loading
        ? Loading()
        : SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.blue[900],
                elevation: 0.0,
                title: Text(
                  'REGISTER',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                actions: <Widget>[
                  FlatButton.icon(
                      onPressed: () {
                        widget.toggleView();
                      },
                      icon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
              body: ListView(
                children: <Widget>[
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20.0,
                          ),
                          Image(
                              image:
                                  AssetImage('assets/waterworthlogoblack.png')),
                          SizedBox(
                            height: 40.0,
                          ),
                          TextFormField(
                            style: TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Username',
                                fillColor: Colors.blue[300],
                                hintStyle: TextStyle(color: Colors.white)),
                            validator: (val) =>
                                (val.isEmpty ? 'Enter a username' : null),
                            onChanged: (val) {
                              userName = val;
                              print(userName);
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            style: TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Email',
                                fillColor: Colors.blue[300],
                                hintStyle: TextStyle(color: Colors.white)),
                            validator: (val) =>
                                (val.isEmpty ? 'Enter an email' : null),
                            onChanged: (val) {
                              setState(() => (email = val));
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            style: TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Password',
                                fillColor: Colors.blue[300],
                                hintStyle: TextStyle(color: Colors.white)),
                            validator: (val) => (val.length < 6
                                ? 'Enter a password 6+ char long'
                                : null),
                            obscureText: true,
                            onChanged: (val) {
                              setState(() => (password = val));
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          RaisedButton(
                              color: Colors.blue[900],
                              child: Text(
                                'Register',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() => loading = true);
                                  dynamic result =
                                      await _auth.registerWithEmailAndPassword(
                                          email, password);
                                  if (result == null) {
                                    setState(() {
                                      loading = true;
                                      error =
                                          'Email invalid. Please use a valid email.';
                                    });
                                  }
                                }
                              }),
                          SizedBox(
                            height: 12.0,
                          ),
                          Text(
                            error,
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
