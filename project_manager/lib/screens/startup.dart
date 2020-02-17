// Name : startup.dart
// Purpose : the starting page where it will display the greetings to user and prompt them to choose either to login or register
// Import : none
// Export : none

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_manager/models/user.dart';
import 'package:provider/provider.dart';
import 'package:project_manager/screens/wrapper.dart';
import 'package:project_manager/services/auth.dart';

//StartUp() stateless widget returns a Scaffold
class StartUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // The is a Column inside the Scaffold
    return Scaffold(
      backgroundColor: Colors.blue[900],

      // This Column() has 2 Containers and a Row.
      body: Column(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 0.0, horizontal: 80.0),

            //This Container will display the company's logo in png form
            child: Container(
              child: Image(
                image: AssetImage('assets/waterworthlogowhite.png'),
                width: 280,
                height: 280,
              ),
            ),
          ),

          // This Container will display the greeting messages
          Container(
            child: Text(
              '             Hi There!\n'
              'Welcome to Waterworth',
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
          ),
          SizedBox(
            height: 50,
          ),

          //This Row() contains 2 FlatButton()
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[

              SizedBox(
                width: 10,
              ),
              FlatButton(
                onPressed: () async {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => StreamProvider<User>.value(
                          value: AuthService().user,
                          child: Wrapper(
                            choice: false,
                          ))));
                },

                //The name of the FlatButton will be Register displayed in Card widget
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12.0),
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.blue[900], fontSize: 20),
                    ),
                  ),
                ),
              ),
              FlatButton(
                onPressed: () async {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => StreamProvider<User>.value(
                          value: AuthService().user,
                          child: Wrapper(
                            choice: true,
                          ))));
                },

                //The name of the FlatButton will be Login displayed in Card widget
                child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 20.0),
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.blue[900], fontSize: 20),
                      ),
                    ),),
              ));
                        style:
                            TextStyle(color: Colors.blue[900], fontSize: 20),
                      ),
                    ]));),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          )
        ],
      ),
    );
  }
}
