import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  static FirebaseFirestore _db = FirebaseFirestore.instance;

  static storeUser({String email, @required String uid}) async {
    CollectionReference users = _db.collection("users");
    return users.doc(uid).set({"email": email});
  }

  static storeReceived(
      {String receiverName,
      String phoneNumber,
      String amount,
      String date,
      String uid}) async {
    CollectionReference receiveRef = _db.collection('received');
    receiveRef.doc(uid).set({
      "receiverName": receiverName,
      "phoneNumber": phoneNumber,
      "amount": amount,
      "date": date
    });
  }
}
