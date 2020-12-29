import 'dart:convert';

import 'package:mpesa_ledger/models/payment.model.dart';
import 'package:mpesa_ledger/models/received.model.dart';
import 'package:http/http.dart' as http;
import 'package:mpesa_ledger/models/sent.model.dart';
import 'package:mpesa_ledger/utils/constants.dart';

class RecievedRepository {
  Future<ReceivedRespond> getReceived(String url) async {
    var receivedRespond;
    // print("repository called");
    try {
      var res = await http.get("${Constants.apiUrl}received");
      receivedRespond =
          ReceivedRespond.fromJson(json.decode(res.body.toString()));
      print(receivedRespond);
    } catch (error) {
      print(error);
      print('an error hase occured:');
      // receivedRespond = "Eroor";
    }
    return receivedRespond;
  }

  Future<http.Response> postReceived(
      {String senderName,
      String senderMobile,
      double amount,
      String transferDate,
      String transactionRef,
      int projectId}) async {
    var body = {
      "senderName": senderName,
      "senderMobile": senderMobile,
      "amount": amount,
      "transferDate": transferDate,
      "transactionRef": transactionRef,
      "userId": projectId,
    };
    var res = await http.post("${Constants.apiUrl}received", body: body);
    return res;
  }

  Future<PaymentModel> getPayments({int userId}) async {
    var paymentsResponse;
    // print("repository called");
    try {
      var res = await http.get("${Constants.apiUrl}paid");
      paymentsResponse =
          PaymentModel.fromJson(json.decode(res.body.toString()));
      print(paymentsResponse);
    } catch (error) {
      print(error);
      print('an error hase occured:');
      // receivedRespond = "Eroor";
    }
    return paymentsResponse;
  }

  Future<SentModel> getSents({int userId}) async {
    var sendResponse;
    // print("repository called");
    try {
      var res = await http.get("${Constants.apiUrl}send");
      sendResponse = SentModel.fromJson(json.decode(res.body.toString()));
    } catch (error) {
      print(error);
      print('an error hase occured:');
      // receivedRespond = "Eroor";
    }
    return sendResponse;
  }
}
