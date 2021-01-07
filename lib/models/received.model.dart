import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mpesa_ledger/utils/currencyUtil.dart';

class Received {
  final String id;
  final String amount;
  final String transactionDate;
  final String phoneNumber;
  final String senderName;
  final dynamic timestamp;
  final String mode;

  Received(
      {this.timestamp,
      this.id,
      this.amount,
      this.transactionDate,
      this.phoneNumber,
      this.mode,
      this.senderName});

  factory Received.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data();
    return Received(
        id: snapshot.id,
        amount: data['amount'],
        phoneNumber: data['phoneNumber'],
        senderName: data['senderName'],
        transactionDate: data['transactionDate'],
        mode: data['mode'] ?? 'Mpesa',
        timestamp: data['timestamp']);
  }
  String getIndex(int index) {
    switch (index) {
      case 0:
        return index.toString();
      case 1:
        return senderName;
      case 2:
        return mode == "Cash"
            ? CurrencyUtils.formatUtc(transactionDate).split(" ")[0]
            : transactionDate.replaceAll("/", "-");
      case 3:
        return mode;
      case 4:
        return CurrencyUtils.formatCurrency(amount);
    }
    return '';
  }
}
