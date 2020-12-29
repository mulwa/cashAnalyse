import 'package:flutter/material.dart';
import 'package:mpesa_ledger/models/sent.model.dart';
import 'package:mpesa_ledger/providers/app_state.dart';
import 'package:mpesa_ledger/repositories/ledger_repository.dart';

class CashOutProvider extends ChangeNotifier {
  List<Sends> cashOut = [];
  double totalCashOut = 00.0;
  List<Sends> sortedcashOut = [];

  RecievedRepository _recievedRepository = RecievedRepository();
  AppStateStatus status;

  static CashOutProvider instance = CashOutProvider();

  CashOutProvider() {
    this.getCashOutMessages();
  }

  getCashOutMessages() async {
    print("Cash Out messages called");
    status = AppStateStatus.Loading;
    notifyListeners();
    try {
      status = AppStateStatus.DoneLoading;
      var res = await _recievedRepository.getSents();
      if (res.success) {
        cashOut = res.sends;
        calculateTotalCashOut(cashOut);
        sortedcashOut = cashOut;
        sortedcashOut.sort((a, b) => b.amount.compareTo(a.amount));
        sortedcashOut.take(5);
        print('Sort by amount: ' + sortedcashOut.toString());

        notifyListeners();
      }
    } catch (error) {
      status = AppStateStatus.ErrorFound;
      print("an error you");
      print(error);
    }
    notifyListeners();
  }

  calculateTotalCashOut(List<Sends> array) {
    this.totalCashOut =
        array.map((e) => e.amount).reduce((value, element) => value + element);
    notifyListeners();
  }
}
