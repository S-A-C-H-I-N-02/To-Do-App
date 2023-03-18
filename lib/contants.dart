import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'homePage.dart';

User currentfirebaseUser = FirebaseAuth.instance.currentUser!;
List detailsList = [];

final _db = FirebaseFirestore.instance;

Future getDetailsList() async {
  try {
    await _db.collection('sampleuser').get().then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        if (element.data() != null) {
          detailsList.add(element.data());
          print(detailsList);
        }
      });
    });
    return detailsList;
  } catch (e) {
    print(e.toString());
    return null;
  }
}

FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
/*
loginAndAuthenticateUser() async {
  print("Trying to login");
  User firebaseUser = (await _firebaseAuth
          .signInWithEmailAndPassword(
              email: "sample@yahoo.com", password: "123456")
          .catchError((errMsg) {
    print('ERROR MESSAGE $errMsg');
  }))
      .user!;
}
*/

loginAndAuthenticateUser() async {
  try {
    final firebaseUser = await FirebaseAuth.instance.signInAnonymously();
    print("Signed in with temporary account.");
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "operation-not-allowed":
        print("Anonymous auth hasn't been enabled for this project.");
        break;
      default:
        print("Unknown error.");
    }
  }
}
