// Name : loading.dart
// Purpose : loading screen whenever the page is loading something
// Function : This file will run the loading animation whenever called

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[50],
      child: Center(
        child: SpinKitFadingCube(
          color: Colors.blue[900],
          size: 60.0,
        ),
      ),
    );
  }
}
