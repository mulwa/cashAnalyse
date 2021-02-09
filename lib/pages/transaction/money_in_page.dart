import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mpesa_ledger/models/group.model.dart';
import 'package:mpesa_ledger/models/received.model.dart';
import 'package:mpesa_ledger/pages/transaction/post_received_cash.dart';
import 'package:mpesa_ledger/pages/widgets/customdialog.dart';
import 'package:mpesa_ledger/pages/widgets/error_message.dart';
import 'package:mpesa_ledger/pages/widgets/progress_dialog.dart';
import 'package:mpesa_ledger/pages/widgets/total_display_widget.dart';
import 'package:mpesa_ledger/services/firestore_service.dart';
import 'package:mpesa_ledger/utils/color.dart';
import 'package:mpesa_ledger/utils/currencyUtil.dart';
import 'package:provider/provider.dart';

class MoneyInPage extends StatelessWidget {
  final Group group;
  final DatabaseService _databaseService = DatabaseService();

  MoneyInPage({Key key, @required this.group}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Received> _received = Provider.of<List<Received>>(context);
    return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: (_received?.length ?? 0) > 0
                  ? Column(
                      children: [
                        TotalWidget(
                          title: "Total Cash Received",
                          total: _received
                              .map((e) => double.parse(
                                  e.amount.toString().replaceAll(",", "")))
                              .reduce((value, element) => value + element)
                              .toString(),
                          bgColor: colorPrimary,
                        ),
                        Expanded(
                          child: ListView.separated(
                              shrinkWrap: true,
                              separatorBuilder: (context, index) => Divider(
                                    color: Colors.grey,
                                  ),
                              itemCount: _received.length,
                              itemBuilder: (context, index) {
                                return ReceivedWidget(
                                  received: _received[index],
                                  group: group,
                                );
                              }),
                        ),
                      ],
                    )
                  : ErrorMessage(
                      errorMessage:
                          "No  Transaction Recorded has been recorded"),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // _showNotificationWithDefaultSound();
            (group.totalCashInCount ?? 0) > 2
                ? showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (dialogContext) => CustomDialog(
                          icon: FontAwesome.info_circle,
                          title: "Payment required",
                          description:
                              "Hey ! , You have reached the maximum free recording to continue adding records  please make payment",
                          okayButtonText: "Proceed to Payment",
                          okayPress: () async {
                            Navigator.pop(dialogContext);
                          },
                        ))
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PostReceivedCash(
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

class ReceivedWidget extends StatelessWidget {
  final Received received;
  final Group group;
  DatabaseService _databaseService = DatabaseService();
  ReceivedWidget({
    Key key,
    @required this.received,
    @required this.group,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: colorPrimary,
        child: Icon(
          Icons.arrow_downward,
          color: Colors.white,
        ),
      ),
      title: Text(received.senderName.trim()),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            received.mode,
            style: TextStyle(color: colorPrimary),
          ),
          SizedBox(
            height: 6.0,
          ),
          Text(
            CurrencyUtils.formatCurrency(
                received.amount.toString().replaceAll(",", "")),
            style: TextStyle(
                fontWeight: FontWeight.bold, color: secondaryPrimaryDark),
          ),
        ],
      ),
      subtitle: received.mode == "Mpesa"
          ? Text(received.transactionDate.replaceAll("/", "-"))
          : Text(
              CurrencyUtils.formatUtc(received.transactionDate).split(" ")[0]),
      onLongPress: () =>
          _handelTransactionDelete(context, transactionId: received.id),
    );
  }

  _handelTransactionDelete(BuildContext context, {String transactionId}) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text("Option"),
          children: [
            Divider(),
            SimpleDialogOption(
                child: Row(
                  children: [
                    Icon(Icons.delete_forever),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Delete")
                  ],
                ),
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) => ProgressDialog(
                      status: "Deleting transaction",
                    ),
                  );
                  Navigator.pop(context);
                  try {
                    await _databaseService.deleteProjectsCashIn(
                        projectId: group.id, transactionId: transactionId);
                    Navigator.pop(context);
                  } catch (error) {
                    Navigator.pop(context);

                    print(error);
                  }
                }),
            Divider(),
            SizedBox(
              height: 10,
            ),
            Center(
              child: SimpleDialogOption(
                child: Text(
                  "Cancel",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            )
          ],
        );
      },
    );
  }
}
