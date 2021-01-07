import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:mpesa_ledger/services/firestore_service.dart';
import 'package:mpesa_ledger/utils/constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SmsQuery query = new SmsQuery();
  List messages = new List();
  DatabaseService databaseService = DatabaseService();
  @override
  void initState() {
    super.initState();
  }

  fetchSMS() async {
    messages =
        await query.querySms(kinds: [SmsQueryKind.Inbox], address: "MPESA");
    String sms = messages[2].body;
    print(messages[2].body);

    if (sms.contains("received")) {
      RegExp regExp = new RegExp(Constants.receivedRegex);
      print("..............Received..................");

      var matches = regExp.allMatches(sms);
      print("${matches.length}");
      var amount = matches.elementAt(0).group(1);
      var name = matches.elementAt(0).group(2);
      var phoneNumber = matches.elementAt(0).group(3);
      var date = matches.elementAt(0).group(4);

      // databaseService.storeReceived(
      //   projectId: ,
      //   amount: amount,
      //   transactionDate: date,
      //   senderName: name,
      //   phoneNumber: phoneNumber,
      // );
    } else if (sms.contains("sent")) {
      RegExp regExp = new RegExp(Constants.sentRegex);
      print("..............Sent..................");
      var matches = regExp.allMatches(sms);
      print("${matches.length}");
      print("Sent Amount :=== ${matches.elementAt(0).group(1)}");
      print("Sent to Name :====${matches.elementAt(0).group(2)}");
      print("PhoneNumber :=== ${matches.elementAt(0).group(3)}");
      print("Date :========${matches.elementAt(0).group(4)}");
    } else if (sms.contains("paid")) {
      RegExp regExp = new RegExp(Constants.paidRegex);
      print("..............paid..................");
      var matches = regExp.allMatches(sms);
      print("${matches.length}");
      print("Amount :=== ${matches.elementAt(0).group(1)}");
      print("Name :====${matches.elementAt(0).group(2)}");
      print("Date :========${matches.elementAt(0).group(3)}");
    } else {
      print("Scenario not captured");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text("Smsm"),
    ));
  }
}
