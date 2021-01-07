import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mpesa_ledger/models/expenditure.model.dart';
import 'package:mpesa_ledger/models/group.model.dart';
import 'package:mpesa_ledger/pages/transaction/cash_out_record.dart';
import 'package:mpesa_ledger/pages/widgets/error_message.dart';
import 'package:mpesa_ledger/pages/widgets/total_display_widget.dart';
import 'package:mpesa_ledger/services/firestore_service.dart';
import 'package:mpesa_ledger/utils/color.dart';
import 'package:mpesa_ledger/utils/currencyUtil.dart';

class MoneyOutPage extends StatelessWidget {
  final Group group;

  const MoneyOutPage({Key key, @required this.group}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            StreamBuilder(
                stream: DatabaseService()
                    .getProjectExpenditure(projectId: group.id),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return ErrorMessage(errorMessage: "An error Has Occurred");
                  }
                  if (snapshot.hasData) {
                    List<Expenditure> _expenditure = snapshot.data.docs
                        .map((DocumentSnapshot doc) =>
                            Expenditure.fromDocumentSnapshot(doc))
                        .toList();
                    return Expanded(
                        child: _expenditure.length > 1
                            ? Column(
                                children: [
                                  TotalWidget(
                                    title: "Total cash out",
                                    total: _expenditure
                                        .map((e) => double.parse(e.amount
                                            .toString()
                                            .replaceAll(",", "")))
                                        .reduce(
                                            (value, element) => value + element)
                                        .toString(),
                                  ),
                                  Expanded(
                                      child: ListView.separated(
                                          itemBuilder: (context, index) {
                                            return ExpenditureWidget(
                                                expenditure:
                                                    _expenditure[index],
                                                group: group);
                                          },
                                          separatorBuilder: (context, index) =>
                                              Divider(),
                                          itemCount: _expenditure.length))
                                ],
                              )
                            : ErrorMessage(
                                errorMessage:
                                    "No Expenditure has been recorded"));
                  }
                  return Expanded(
                      child: Center(child: CircularProgressIndicator()));
                })
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // _showNotificationWithDefaultSound();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CashOutPage(
                          group: group,
                        )));
          },
          child: Icon(
            Icons.add_circle,
            color: Colors.white,
          ),
        ));
  }
}

class ExpenditureWidget extends StatelessWidget {
  final Expenditure expenditure;
  final Group group;

  const ExpenditureWidget({Key key, this.expenditure, this.group})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: secondaryPrimaryDark,
        child: Icon(
          Icons.arrow_upward,
          color: Colors.white,
        ),
      ),
      title: Text(expenditure.receiverName),
      trailing: Text(
        CurrencyUtils.formatCurrency(
            expenditure.amount.toString().replaceAll(",", "")),
        style:
            TextStyle(fontWeight: FontWeight.bold, color: secondaryPrimaryDark),
      ),
      subtitle: Text(expenditure.title ?? ''),
      // subtitle: expenditure.mode == "Mpesa"
      //     ? Text(expenditure.transactionDate.replaceAll("/", "-"))
      //     : Text(CurrencyUtils.formatUtc(expenditure.transactionDate)
      //         .split(" ")[0]),
    );
  }
}
