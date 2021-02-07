import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mpesa_ledger/models/expenditure.model.dart';
import 'package:mpesa_ledger/models/group.model.dart';
import 'package:mpesa_ledger/models/received.model.dart';
import 'package:mpesa_ledger/pages/widgets/customdialog.dart';

class DatabaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static storeUser({String email, @required String uid}) async {
    CollectionReference users = _db.collection("users");
    return users.doc(uid).set({"email": email});
  }

  Future<String> storeReceived(
      {String senderName,
      String phoneNumber,
      String amount,
      String transactionDate,
      String transactionRef,
      String mode = 'Mpesa',
      @required String projectId}) async {
    String _result;
    DocumentSnapshot _doc = await _db
        .collection('received')
        .doc(projectId)
        .collection("projectReceived")
        .doc(transactionRef)
        .get();

    if (!_doc.exists) {
      print('does not exist');
      await _doc.reference.set({
        "senderName": senderName,
        "phoneNumber": phoneNumber,
        "transactionRef": transactionRef,
        "amount": amount,
        "transactionDate": transactionDate,
        "timestamp": DateTime.now().toString(),
        "mode": mode,
      });
      // increment total cash In
      await _db
          .collection('projects')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection("userProjects")
          .doc(projectId)
          .update({"totalCashInCount": FieldValue.increment(1)});
      _result = "saved";
      // print('document doesn\'t exists ${_doc.reference}');
    } else {
      print('document  exist ${_doc.reference}');
      _result = 'exist';
    }
    return _result;
  }

  Future<String> storeExpenditure(
      {Expenditure expenditure, @required String projectId}) async {
    String _result;
    DocumentSnapshot doc = await _db
        .collection('expenditure')
        .doc(projectId)
        .collection("projectExpenditure")
        .doc(expenditure.transactionRef)
        .get();

    if (!doc.exists) {
      doc.reference.set({
        "receiverName": expenditure.receiverName,
        "phoneNumber": expenditure.phoneNumber,
        "amount": expenditure.amount,
        "transactionDate": expenditure.transactionDate,
        "timestamp": DateTime.now().toString(),
        "mode": expenditure.mode,
        "title": expenditure.title
      });
      // increment total cash out to change to batch later
      await _db
          .collection('projects')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection("userProjects")
          .doc(projectId)
          .update({"totalCashOutCount": FieldValue.increment(1)});
      _result = 'saved';
    } else {
      _result = 'exist';
    }
    return _result;
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
      "transactionCount": "",
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

  Future<void> deleteProjectsCashIn(
      {String projectId, String transactionId}) async {
    // decrease on cash in delete
    await _db
        .collection('projects')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("userProjects")
        .doc(projectId)
        .update({"totalCashInCount": FieldValue.increment(-1)});
    return await _db
        .collection("received")
        .doc(projectId)
        .collection("projectReceived")
        .doc(transactionId)
        .delete();
  }
}
