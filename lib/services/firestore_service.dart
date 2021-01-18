import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mpesa_ledger/models/expenditure.model.dart';
import 'package:mpesa_ledger/models/group.model.dart';
import 'package:mpesa_ledger/models/received.model.dart';

class DatabaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static storeUser({String email, @required String uid}) async {
    CollectionReference users = _db.collection("users");
    return users.doc(uid).set({"email": email});
  }

  Future<void> storeReceived(
      {String senderName,
      String phoneNumber,
      String amount,
      String transactionDate,
      String transactionRef,
      String mode = 'Mpesa',
      @required String projectId}) async {
    return _db
        .collection('received')
        .doc(projectId)
        .collection("projectReceived")
        .doc(transactionRef)
        .set({
      "senderName": senderName,
      "phoneNumber": phoneNumber,
      "transactionRef": transactionRef,
      "amount": amount,
      "transactionDate": transactionDate,
      "timestamp": DateTime.now().toString(),
      "mode": mode,
    });
  }

  Future<void> storeExpenditure(
      {Expenditure expenditure, @required String projectId}) async {
    return _db
        .collection('expenditure')
        .doc(projectId)
        .collection("projectExpenditure")
        .doc(expenditure.transactionRef)
        .set({
      "receiverName": expenditure.receiverName,
      "phoneNumber": expenditure.phoneNumber,
      "amount": expenditure.amount,
      "transactionDate": expenditure.transactionDate,
      "timestamp": DateTime.now().toString(),
      "mode": expenditure.mode,
      "title": expenditure.title
    });
  }

  Stream<QuerySnapshot> getProjectExpenditure({String projectId}) {
    return _db
        .collection("expenditure")
        .doc(projectId)
        .collection("projectExpenditure")
        .snapshots();
  }

  Stream<List<Expenditure>> getProjectExpenditure2({String projectId}) {
    return _db
        .collection("expenditure")
        .doc(projectId)
        .collection("projectExpenditure")
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) =>
                Expenditure.fromDocumentSnapshot(documentSnapshot))
            .toList());
  }

  Future<DocumentReference> createProject(
      {String title, String description}) async {
    return _db
        .collection("projects")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("userProjects")
        .add({
      "title": title,
      "description": description,
      "timestamp": new DateTime.now()
    });
  }

  Future<void> updateProject(
      {String title, String description, String projectId}) async {
    return _db
        .collection("projects")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("userProjects")
        .doc(projectId)
        .update({
      "title": title,
      "description": description,
    });
  }

  Future<void> deleteProject({String projectId}) async {
    return _db
        .collection("projects")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("userProjects")
        .doc(projectId)
        .delete();
  }

  Stream<QuerySnapshot> getUserProject() {
    return _db
        .collection("projects")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("userProjects")
        .snapshots();
  }

  Future<Group> getSingleProject({String projectId}) {
    return _db
        .collection("projects")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("userProjects")
        .doc(projectId)
        .get()
        .then((DocumentSnapshot documentSnapshot) =>
            Group.fromDataSnapshot(documentSnapshot));
  }

  Stream<List<Received>> getProjectsCashIn({String projectId}) {
    return _db
        .collection("received")
        .doc(projectId)
        .collection("projectReceived")
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot doc) => Received.fromDocumentSnapshot(doc))
            .toList());
  }

  // Stream<QuerySnapshot> getProjectsCashIn({String projectId}) {
  //   return _db
  //       .collection("received")
  //       .doc(projectId)
  //       .collection("projectReceived")
  //       .snapshots();
  // }

  Future<void> deleteProjectsCashIn({String projectId, String transactionId}) {
    return _db
        .collection("received")
        .doc(projectId)
        .collection("projectReceived")
        .doc(transactionId)
        .delete();
  }
}
