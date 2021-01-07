import 'package:flutter/material.dart';
import 'package:mpesa_ledger/models/group.model.dart';
import 'package:mpesa_ledger/pages/transaction/money_in_page.dart';
import 'package:mpesa_ledger/pages/transaction/money_out_page.dart';
import 'package:mpesa_ledger/pages/transaction/payments_page.dart';
import 'package:mpesa_ledger/pages/widgets/drawer.dart';

class TransactionPage extends StatelessWidget {
  final Group group;

  const TransactionPage({Key key, @required this.group}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "${group.title} Transactions",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              IconButton(
                  icon: Icon(Icons.picture_as_pdf),
                  onPressed: () {
                    print("Pull messages again");
                  })
            ],
            bottom: TabBar(tabs: <Widget>[
              Tab(
                text: "Cash In",
                icon: Icon(Icons.arrow_downward),
              ),
              Tab(
                text: "Cash Out",
                icon: Icon(Icons.arrow_upward),
              ),
              // Tab(
              //   text: "Payments",
              //   icon: Icon(Icons.account_balance_wallet),
              // )
            ]),
          ),
          body: TabBarView(children: <Widget>[
            MoneyInPage(
              group: group,
            ),
            MoneyOutPage(group: group),
            // PaymentPage(group: group)
          ])),
    );
  }
}
