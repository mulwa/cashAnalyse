import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  final String id;
  final String title;
  final String description;
  final dynamic timestamp;
  final int totalCashInCount;
  final int totalCashOutCount;

  Group(
      {this.id,
      this.title,
      this.description,
      this.totalCashInCount,
      this.totalCashOutCount,
      this.timestamp});

  factory Group.fromDataSnapshot(DocumentSnapshot doc) {
    Map data = doc.data();
    return Group(
        id: doc.id,
        title: data['title'],
        description: data['description'],
        totalCashInCount: data['totalCashInCount'],
        totalCashOutCount: data['totalCashOutCount'],
        timestamp: data['timestamp']);
  }
}
