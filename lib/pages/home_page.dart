import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:mpesa_ledger/bloc/received.bloc.dart';
import 'package:mpesa_ledger/models/received.model.dart';
import 'package:mpesa_ledger/providers/app_state.dart';
import 'package:mpesa_ledger/services/firestore_service.dart';
import 'package:mpesa_ledger/utils/constants.dart';
import 'package:mpesa_ledger/services/auth_service.dart';
import 'package:mpesa_ledger/utils/color.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SmsQuery query = new SmsQuery();
  List messages = new List();
  @override
  void initState() {
    var received =
        Provider.of<AppState>(context, listen: false).receivedMessages;
    print(received);

    super.initState();
  }

  void dispose() {
    receivedBloc.dispose();
    super.dispose();
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
      var phonenumber = matches.elementAt(0).group(3);
      var date = matches.elementAt(0).group(4);

      DatabaseService.storeReceived(
          amount: amount,
          date: date,
          receiverName: name,
          phoneNumber: phonenumber,
          uid: FirebaseAuth.instance.currentUser.uid);
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
    // receivedBloc.eventSink.add(ReceivedActions.read);
    var received =
        Provider.of<AppState>(context, listen: false).receivedMessages;
    print('received messages');
    print(received);

    return Scaffold(
      appBar: AppBar(
        title: Text("Smsm"),
      ),
      body: ListView.separated(
          separatorBuilder: (context, index) => Divider(
                color: Colors.black,
              ),
          itemCount: received.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(
                  Icons.markunread,
                  color: Colors.pink,
                ),
                title: Text(
                    "${received[index].senderName.toString()} ${received[index].senderName.toString()}"),
                subtitle: Text(
                  received[index].amount.toString(),
                  maxLines: 3,
                  style: TextStyle(),
                ),
                trailing: Text(received[index].transferDate),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorPrimaryDark,
        onPressed: () => AuthService.logOut(),
        child: Icon(
          Icons.undo,
        ),
      ),
    );
  }
}
