import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ///https://firebase.flutter.dev/docs/auth/usage/#authentication-state
  Future  _authStateChanges()async{
    final StreamSubscription<User?> _check = FirebaseAuth.instance
        .idTokenChanges()
        .listen((User? user) {
      if (user == null) {
        debugPrint('User is currently signed out!');
      } else {
        debugPrint('User is signed in!');
      }
    });
    if (_check != null){
      debugPrint(_check.toString());
    }else{
      debugPrint('_authStateChanges');
    }
  }

  //create user obj based on FirebaseUser
  UserModel? _userFromFirebaseUser(User user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  // sign in Anon
  Future signInAnon() async {
    try {
      UserCredential credential = await _auth.signInAnonymously();
      User? firebaseUser = credential.user;
      return _userFromFirebaseUser(firebaseUser!);
    } catch (e) {
      debugPrint("Error on signInAnon = " + e.toString());
      return null;
    }
  }

  // auth change user stream
  Stream<UserModel?> get user {
    return _auth.authStateChanges().map((User? user) => _userFromFirebaseUser(user!));
  }

  // get uid
  Future<String> getCurrentUID() async {
    return _auth.currentUser!.uid;
  }

  //sign in with email and pass
  Future signInWithEmailAndPassword(String email, String password)async{
    try{
      UserCredential credential =
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = credential.user;
      return _userFromFirebaseUser(user!);

    }catch(e){
      debugPrint("Error on signInWithEmailAndPassword = " + e.toString());
      return null;
    }
  }
  Future changePassword(String email, String currentPassword,String newPassword)async{
    try{
      UserCredential credential =
      await _auth.signInWithEmailAndPassword(email: email, password: currentPassword);
      User? user = credential.user;

      if(user!.emailVerified != false){
        await _auth.currentUser!.updatePassword(newPassword);


        debugPrint('Password changed!');
        return   _userFromFirebaseUser(user);
       // return signOut();
      }
      return null;
    }on FirebaseAuthException catch(e){
    //Utils.showSnackBar(e.message);
    debugPrint(e.toString());
    return null;
    }catch(e){
    debugPrint(e.toString());
    return null;
    }
  }

  //register with email and pass
  Future registerWithEmailAndPassword(String email, String password)async{
    try{
      UserCredential credential =
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = credential.user;

      // create a new document for the user with the uid
      // await DatabaseService(uid: user?.uid).updateUserDate(
      //     'New user fullName', user!.metadata.creationTime,
      //      DateFormat.yMd().add_Hm().format(_now),'email', 1, 'address', 'role');

      return _userFromFirebaseUser(user!);
    }catch(e){
      debugPrint("Error on registerWithEmailAndPassword = " + e.toString());
      return null;
    }
  }

  // register with phone number
  Future registerWithPhoneNumber(String number)async{}

  //sign out
  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      debugPrint("SignOut error:"+e.toString());
    }
  }
  Future deleteUser()async{
    try {
      await _auth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        debugPrint('The user must reauthenticate before this operation can be executed.');
      }
    }
  }
  Future  updateEmailAndPassword(String _email,String _password)async {
    //const auth = firebase.auth();

    try {
      AuthCredential credential = EmailAuthProvider.credential(email: _email, password: _password);
      if(_auth.currentUser != null){
        debugPrint(_auth.currentUser!.email.toString());
        await _auth.currentUser!.updateEmail(_email);

        await _auth.currentUser!.updatePassword(_password);
        debugPrint('Email and Password successfully updated.!');
      }
      else{
        debugPrint('Email and Password could not updated.!');
      }
      //await _auth.currentUser!.reauthenticateWithCredential(credential);

      //currentUser.updateEmail(this.email.value);

    } catch(err) {
      debugPrint("Reauthentication error! : "+err.toString());
    }
  }
  // Future<bool> validateCurrentPassword(String password) async {
  //   return await _auth.currentUser!.v//validatePassword(password);
  // }
  //
  // void updateUserPassword(String password) {
  //   _auth.updatePassword(password);
  // }
}
