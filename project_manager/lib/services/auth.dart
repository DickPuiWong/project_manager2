import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/services/database.dart';

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

  Future registerWithEmailAndPassword(String inEmail, String inPassword) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: inEmail, password: inPassword);
      FirebaseUser user = result.user;
      await UserDataService(uid: user.uid).updateUserData(2, projList);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut()async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}
