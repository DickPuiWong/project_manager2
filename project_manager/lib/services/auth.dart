// Name : auth.dart
// Purpose : to authenticate users
// Function : This file is acting as a service for authentication and it connects to Firebase services

import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/services/database.dart';

//AuthService class contains all the services that is used for authentication
class AuthService {
  List<String> projList = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user obj base on firebaseuser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  //sign in service with email and password
  Future signInWithEmailAndPassword(String inEmail, String inPassword) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: inEmail, password: inPassword);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register service with email and password
  Future registerWithEmailAndPassword(
      String inEmail, String inPassword, String name) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: inEmail, password: inPassword);
      FirebaseUser user = result.user;
      await UserDataService(uid: user.uid).updateUserData(name, 2, projList);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out service
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
