import 'package:flutter/material.dart';
import 'package:mpesa_ledger/utils/constants.dart';

class AppState extends ChangeNotifier {
  AppState() {
    print("app state constructor");
  }

  addCashReceived({String mpesaMessage}) async {
    print("AppState $mpesaMessage");
    RegExp regExp = new RegExp(Constants.receivedRegex);
    print("..............Received..................");
    var matches = regExp.allMatches(mpesaMessage);
    print("${matches.length}");
    var amount = matches.elementAt(0).group(1);
    var name = matches.elementAt(0).group(2);
    var phoneNumber = matches.elementAt(0).group(3);
    var date = matches.elementAt(0).group(4);

    // var res = await _recievedRepository.postReceived(
    //     amount: double.parse(amount),
    //     senderMobile: phoneNumber,
    //     senderName: name,
    //     transferDate: date,
    //     transactionRef: "YYYY",
    //     projectId: 2);

    // if (res.statusCode == 201) {}
    notifyListeners();
  }
}
