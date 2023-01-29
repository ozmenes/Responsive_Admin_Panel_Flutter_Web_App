import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_admin_panel_web_app/models/users_data.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // collection referecence
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData(
      String _uid,
      String? fullName,
      String? imageUrl,
      String? phone,
      String? address,
      //String? email,
      String? role,
      String updatedDate,
      //String? createdDate,
      ) async {
    await userCollection.doc(_uid).update({
      'fullName': fullName,
      'imageUrl': imageUrl,
      'phone': phone,
      'address': address,
      'role': role,
      'updatedDate': updatedDate,
    });
  }

  // create users info
  Future addUsersInfo(String _uid,String fullName,
      String? imageUrl,String address,
      String phone,String? email,String role,
      String? createdDate, String updatedDate) async {
    try {
      String uid = _auth.currentUser!.uid.toString();
      String email = _auth.currentUser!.email.toString();
      return await userCollection.doc(uid).set({
        'uid' : _uid,
        'fullName': fullName,
        'imageUrl' : imageUrl,
        'address': address,
        'phone': phone,
        'email': email,
        'role': role,
        'createdDate': createdDate,
        'updatedDate': updatedDate,
      });
    } catch (e) {
      debugPrint("Error on addUsersInfo = " + e.toString());
      return null;
    }
  }

  // users list from snapshot
  List<UserInformation> _usersListFromSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserInformation(
        uid: doc.get('uid')?? "",
        fullName: doc.get('fullName') ?? "",
        imageUrl: doc.get('imageUrl') ?? "",
        address: doc.get('address') ?? "",
        phone: doc.get('phone') ?? " ", //if int ?? 0,
        email: doc.get('email') ?? "",
        role: doc.get('role') ?? "",
        createdDate: doc.get('createdDate') ?? "",
        updatedDate: doc.get('updatedDate') ?? "",
      );
    }).toList();
  }

  //userData from SnapShot
  UserInformation _userDataFromSnapShot(DocumentSnapshot snapshot) {
    return UserInformation(
      uid: snapshot.get('uid')?? "",
      fullName: snapshot.get('fullName') ?? "",
      imageUrl: snapshot.get("imageUrl") ?? "",
      address: snapshot.get('address') ?? "",
      phone: snapshot.get('phone') ?? "",
      email: snapshot.get('email') ?? "",
      role: snapshot.get('role') ?? "",
      createdDate: snapshot.get('createdDate') ?? "",
      updatedDate: snapshot.get('updatedDate') ?? "",
    );
  }

  //get Users stream
  Stream<List<UserInformation>> get getUsers {
    return userCollection.snapshots().map(_usersListFromSnapShot);
  }
  Stream<QuerySnapshot?> get currentUserData{
    return userCollection.snapshots();
  }

  //get user doc stream
  Stream<UserInformation> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapShot);
  }
  //get delete user document
  Future deleteUser(String _uid)async{
    return await userCollection.doc(_uid).delete();
  }
  // Future deleteUser(String _uid)async{
  //   CollectionReference reference= userCollection.doc(_uid).collection('users');
  //   QuerySnapshot snapshot = await reference.get();
  //   return snapshot.docs[0].reference.delete();
  // }
}