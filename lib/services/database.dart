import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  // collection reference
  final firestoreInstance = Firestore.instance;
  final CollectionReference _userRef = Firestore.instance.collection('users');

  Future setUser(String firstName, String lastName, String email) async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    return await firestoreInstance
        .collection('users')
        .document(firebaseUser.uid)
        .setData({
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "created": FieldValue.serverTimestamp(),
      "profilePicture": '',
      "points": FieldValue.increment(0),
    });
  }

  Future getKeyboard() async {
    final FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    return await firestoreInstance
        .collection('keyboard')
        // .where('owner', 'not-in', 'awdawda')
        .getDocuments();
  }

  Future setKeyboard(
      String desc,
      String name,
      String brand,
      String switchType,
      String keyboardSize,
      String keyboardLayout,
      String keycapPlastic,
      String caseColor,
      String keycapColor,
      String weight,
      String condition,
      DateTime startDate,
      DateTime endDate,
      String currentPrice,
      String bidIncrement,
      String image,
      String status) async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    String owner = firebaseUser.uid.toString();
    return await firestoreInstance.collection('keyboard').document().setData({
      "desc": desc,
      "name": name,
      "brand": brand,
      "switchType": switchType,
      "keyboardSize": keyboardSize,
      "keyboardLayout": keyboardLayout,
      "keycapPlastic": keycapPlastic,
      "caseColor": caseColor,
      "keycapColor": keycapColor,
      "weight": weight,
      "condition": condition,
      "startDate": startDate,
      "endDate": endDate,
      "currentPrice": currentPrice,
      "bidIncrement": bidIncrement,
      "image": image,
      "owner": owner,
      "status": status,
    });
  }
}
