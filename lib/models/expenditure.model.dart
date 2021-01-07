import 'package:cloud_firestore/cloud_firestore.dart';

class Expenditure {
  final String id;
  final String title;
  final String amount;
  final String transactionDate;
  final String phoneNumber;
  final String receiverName;
  final dynamic timestamp;
  final String mode;

  Expenditure(
      {this.id,
      this.title,
      this.amount,
      this.transactionDate,
      this.phoneNumber,
      this.receiverName,
      this.timestamp,
      this.mode});

  factory Expenditure.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data();
    return Expenditure(
        id: snapshot.id,
        amount: data['amount'],
        phoneNumber: data['phoneNumber'] ?? 'null',
        receiverName: data['receiverName'],
        transactionDate: data['transactionDate'],
        mode: data['mode'] ?? 'Mpesa',
        timestamp: data['timestamp']);
  }
}
