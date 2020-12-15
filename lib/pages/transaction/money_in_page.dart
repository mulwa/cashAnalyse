import 'package:flutter/material.dart';
import 'package:mpesa_ledger/pages/widgets/error_message.dart';
import 'package:mpesa_ledger/providers/app_state.dart';
import 'package:mpesa_ledger/utils/color.dart';
import 'package:mpesa_ledger/utils/currencyUtil.dart';
import 'package:provider/provider.dart';

class MoneyInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var received =
        Provider.of<AppState>(context, listen: false).receivedMessages;
    AppStateStatus _loadingStatus =
        Provider.of<AppState>(context, listen: false).loadingStatus;
    return Scaffold(
      body: (_loadingStatus == AppStateStatus.ErrorFound &&
              (_loadingStatus) != AppStateStatus.Loading)
          ? ErrorMessage(errorMessage: "An Error Has Occured Try later")
          : (_loadingStatus == AppStateStatus.Loading)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : received.length > 0
                  ? ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                            color: Colors.grey,
                          ),
                      itemCount: received.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: colorGreen,
                            child: Icon(
                              Icons.arrow_downward,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                              "${received[index].senderName.toString()} ${received[index].senderName.toString()}"),
                          trailing: Text(
                            CurrencyUtils.formatCurrency(
                                received[index].amount.toString()),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: secondaryPrimaryDark),
                          ),
                          subtitle: Text(
                            received[index].transferDate,
                          ),
                        );
                      })
                  : ErrorMessage(
                      errorMessage: "Nothing Found",
                    ),
    );
  }
}
