import 'package:flutter/material.dart';
import 'package:mpesa_ledger/models/payment.model.dart';
import 'package:mpesa_ledger/models/received.model.dart';
import 'package:mpesa_ledger/models/sent.model.dart';
import 'package:mpesa_ledger/repositories/ledger_repository.dart';

enum AppStateStatus {
  Loading,
  ErrorFound,
  DoneLoading,
}

class AppState extends ChangeNotifier {
  List<Received> _received = [];
  List<Payments> _payments = [];
  List<Sends> _sends = [];
  RecievedRepository _recievedRepository = RecievedRepository();
  AppStateStatus _appStateStatus;

  List<Received> get receivedMessages => _received;
  List<Payments> get paymentMessages => _payments;
  List<Sends> get sendMessages => _sends;
  AppStateStatus get loadingStatus => _appStateStatus;

  AppState() {
    print("app state constructor");
    this.getReceivedMessages();
    this.getPaymentMessages();
    this.getSendsMessages();
  }

  getReceivedMessages() async {
    print("received messages called");
    _appStateStatus = AppStateStatus.Loading;
    notifyListeners();
    try {
      _appStateStatus = AppStateStatus.DoneLoading;
      var res = await _recievedRepository.getReceived("received");
      if (res.success) {
        _received = res.received;

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

  getPaymentMessages() async {
    print("payment messages called");
    _appStateStatus = AppStateStatus.Loading;
    notifyListeners();
    try {
      _appStateStatus = AppStateStatus.DoneLoading;
      var res = await _recievedRepository.getPayments();
      if (res.success) {
        _payments = res.payments;

        notifyListeners();
      }
    } catch (error) {
      _appStateStatus = AppStateStatus.ErrorFound;
      print("an error you");
      print(error);
    }
    notifyListeners();
  }

  getSendsMessages() async {
    print("send messages called");
    _appStateStatus = AppStateStatus.Loading;
    notifyListeners();
    try {
      _appStateStatus = AppStateStatus.DoneLoading;
      var res = await _recievedRepository.getSents();
      if (res.success) {
        _sends = res.sends;
        print(_sends);

        notifyListeners();
      }
    } catch (error) {
      _appStateStatus = AppStateStatus.ErrorFound;
      print("an error you");
      print(error);
    }
    notifyListeners();
  }
}
