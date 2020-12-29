import 'package:flutter/material.dart';
import 'package:mpesa_ledger/pages/transaction/post_received_cash.dart';
import 'package:mpesa_ledger/pages/widgets/error_message.dart';
import 'package:mpesa_ledger/pages/widgets/total_display_widget.dart';
import 'package:mpesa_ledger/providers/app_state.dart';
import 'package:mpesa_ledger/utils/color.dart';
import 'package:mpesa_ledger/utils/currencyUtil.dart';
import 'package:provider/provider.dart';

class MoneyInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var received =
    //     Provider.of<AppState>(context, listen: false).receivedMessages;
    return Scaffold(
        body: Column(
          children: [
            TotalWidget(
              title: "Total Cash Received",
              total: "633333",
              bgColor: colorGreen,
            ),
            Expanded(
                child: ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => Divider(
                          color: Colors.grey,
                        ),
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return ReceivedWidget();
                    })),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // _showNotificationWithDefaultSound();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PostReceivedCash()));
          },
          child: Icon(
            Icons.add_circle,
            color: Colors.white,
          ),
        ));
  }
}

class ReceivedWidget extends StatelessWidget {
  const ReceivedWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: colorGreen,
        child: Icon(
          Icons.arrow_downward,
          color: Colors.white,
        ),
      ),
      title: Text("mulea"),
      trailing: Text(
        CurrencyUtils.formatCurrency(14000),
        style:
            TextStyle(fontWeight: FontWeight.bold, color: secondaryPrimaryDark),
      ),
      subtitle: Text("5666/452/2020"),
    );
  }
}
