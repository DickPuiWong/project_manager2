// Name : sign_in.dart
// Purpose : to enable the existing user to sign in
// Function : prompt the existing user to enter their email and password to sign in

import 'package:flutter/material.dart';
import 'package:project_manager/services/auth.dart';
import 'package:project_manager/shared/constants.dart';
import 'package:project_manager/shared/loading.dart';

class SignIn extends StatefulWidget {
  //Creation of an object called toggleView and put it in the class SignIn()
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // declare and initialise the objects and variables
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text fields needed in this class
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    //SignIn class will return a loading page while waiting to display the Scaffold that shows the sign in page
    return loading
        ? Loading()
        : SafeArea(
            child: Scaffold(
              backgroundColor: Colors.blue[900],
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 30.0,
                title: Text(
                  'LOGIN',
                  style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                actions: <Widget>[
                  FlatButton.icon(
                      onPressed: () {
                        widget.toggleView();
                      },
                      icon: Icon(
                        Icons.person_add,
                        color: Colors.blue[900],
                      ),
                      label: Text('Register',
                          style: TextStyle(color: Colors.blue[900])))
                ],
              ),
              body: ListView(
                children: <Widget>[
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 50.0,
                          ),
                          Image(
                              image:
                                  AssetImage('assets/waterworthlogowhite.png')),
                          SizedBox(
                            height: 40.0,
                          ),
                          TextFormField(
                            decoration:
                                textInputDecoration.copyWith(hintText: 'Email'),
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
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Password'),
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
                              color: Colors.white,
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.blue[900], fontSize: 20),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() => loading = true);
                                  dynamic result =
                                      await _auth.signInWithEmailAndPassword(
                                          email, password);
                                  if (result == null) {
                                    setState(() {
                                      loading = false;
                                      error =
                                          'Could not sign in with those credentials';
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
