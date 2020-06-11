import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/models/user.dart';
import 'package:flutter_firebase/services/database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Create user object 
  User _userFirebase(FirebaseUser user){
    return user != null ? User(uid: user.uid) : null;
  }

  // Auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFirebase);
  }

  //Sign in Guest
  Future signInGuest () async {
    try{
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFirebase(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //Sign in with Email & Pass
  Future signInWithEmailPassword(String email, String pass) async{
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: pass);
      FirebaseUser user = result.user;
      return _userFirebase(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //Register with Email & Pass
  Future signUpWithEmailPassword(String email, String pass, String name, String lastname, String phone) async{
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      FirebaseUser user = result.user;
      
      // create document for the user
      await DatabaseService(uid: user.uid).createUserData(name, lastname, phone);

      return _userFirebase(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //Sign out
  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}