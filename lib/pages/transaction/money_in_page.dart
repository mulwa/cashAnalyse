import 'package:flutter/material.dart';
import 'package:mpesa_ledger/models/received.model.dart';
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
            Consumer<AppState>(
              builder: (context, value, child) {
                if (value.loadingStatus == AppStateStatus.Loading) {
                  return Expanded(child: CircularProgressIndicator());
                } else if (value.loadingStatus == AppStateStatus.ErrorFound) {
                  return ErrorMessage(
                      errorMessage: "An error has Occurred try later");
                } else {
                  return Expanded(
                    child: ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => Divider(
                              color: Colors.grey,
                            ),
                        itemCount: value.receivedMessages.length,
                        itemBuilder: (context, index) {
                          return ReceivedWidget(
                            received: value.receivedMessages[index],
                          );
                        }),
                  );
                }
              },
            ),
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
  final Received received;
  const ReceivedWidget({
    Key key,
    @required this.received,
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
      title: Text(
          "${received.senderName.toString()} ${received.senderName.toString()}"),
      trailing: Text(
        CurrencyUtils.formatCurrency(received.amount.toString()),
        style:
            TextStyle(fontWeight: FontWeight.bold, color: secondaryPrimaryDark),
      ),
      subtitle: Text(
        received.transferDate,
      ),
    );
  }
}
