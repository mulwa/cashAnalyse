import 'package:flutter/material.dart';
import 'package:mpesa_ledger/models/payment.model.dart';
import 'package:mpesa_ledger/providers/app_state.dart';
import 'package:mpesa_ledger/repositories/ledger_repository.dart';

class PaymentProvider extends ChangeNotifier {
  List<Payments> payments = [];
  double totalPayments = 0.0;
  AppStateStatus status;
  RecievedRepository _recievedRepository = RecievedRepository();

  static PaymentProvider instance = PaymentProvider();

  PaymentProvider() {
    this.getPaymentMessages();
  }

  getPaymentMessages() async {
    print("payment messages called");
    status = AppStateStatus.Loading;
    notifyListeners();
    try {
      status = AppStateStatus.DoneLoading;
      var res = await _recievedRepository.getPayments();
      if (res.success) {
        payments = res.payments;
        calculateTotalPayment(payments);
        notifyListeners();
      }
    } catch (error) {
      status = AppStateStatus.ErrorFound;
      print("an error you");
      print(error);
    }
    notifyListeners();
  }

  calculateTotalPayment(List<Payments> array) {
    this.totalPayments =
        array.map((e) => e.amount).reduce((value, element) => value + element);
    notifyListeners();
  }
}
