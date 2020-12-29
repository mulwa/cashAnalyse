import 'package:flutter/material.dart';
import 'package:mpesa_ledger/models/received.model.dart';
import 'package:mpesa_ledger/repositories/ledger_repository.dart';
import 'package:mpesa_ledger/utils/constants.dart';

enum AppStateStatus {
  Loading,
  ErrorFound,
  DoneLoading,
}

class AppState extends ChangeNotifier {
  List<Received> _received = [];
  RecievedRepository _recievedRepository = RecievedRepository();
  AppStateStatus _appStateStatus;
  double totalReceived = 0.00;

  // bool _postingTransaction = false;
  // bool get

  List<Received> get receivedMessages => _received;
  AppStateStatus get loadingStatus => _appStateStatus;

  AppState() {
    print("app state constructor");
    this.getReceivedMessages();
  }

  getReceivedMessages() async {
    print("received messages called");
    _appStateStatus = AppStateStatus.Loading;
    notifyListeners();
    try {
      _appStateStatus = AppStateStatus.DoneLoading;
      var res = await _recievedRepository.getReceived("received");
      print(res);
      if (res.success) {
        _received = res.received;
        calculateTotalCashIn(_received);

        notifyListeners();
      }
    } catch (error) {
      _appStateStatus = AppStateStatus.ErrorFound;
      print("an error you");
      print(error);
      notifyListeners();
    }
    notifyListeners();
  }

  calculateTotalCashIn(List<Received> array) {
    this.totalReceived =
        array.map((e) => e.amount).reduce((value, element) => value + element);
    notifyListeners();
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

    var res = await _recievedRepository.postReceived(
        amount: double.parse(amount),
        senderMobile: phoneNumber,
        senderName: name,
        transferDate: date,
        transactionRef: "YYYY",
        projectId: 2);

    print(res);

    // if (res.statusCode == 201) {}
    notifyListeners();
  }
}
