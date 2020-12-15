import 'package:flutter/material.dart';
import 'package:mpesa_ledger/pages/transaction/money_in_page.dart';
import 'package:mpesa_ledger/pages/transaction/money_out_page.dart';
import 'package:mpesa_ledger/pages/transaction/payments_page.dart';
import 'package:mpesa_ledger/pages/widgets/drawer.dart';

class TransactionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          drawer: AppDrawer(),
          appBar: AppBar(
            title: Text(
              "Transaction",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              IconButton(
                  icon: Icon(Icons.refresh),
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
              Tab(
                text: "Payments",
                icon: Icon(Icons.account_balance_wallet),
              )
            ]),
          ),
          body: TabBarView(children: <Widget>[
            MoneyInPage(),
            MoneyOutPage(),
            PaymentPage()
          ])),
    );
  }
}
