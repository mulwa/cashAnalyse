import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  final String id;
  final String title;
  final String description;
  final dynamic timestamp;

  Group({this.id, this.title, this.description, this.timestamp});

  factory Group.fromDataSnapshot(DocumentSnapshot doc) {
    Map data = doc.data();
    return Group(
        id: doc.id,
        title: data['title'],
        description: data['description'],
        timestamp: data['timestamp']);
  }
}
