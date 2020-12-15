import 'package:flutter/material.dart';
import 'package:mpesa_ledger/providers/app_state.dart';
import 'package:mpesa_ledger/utils/color.dart';
import 'package:mpesa_ledger/utils/currencyUtil.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var send = Provider.of<AppState>(context, listen: false).sendMessages;
    return Scaffold(
      body: ListView.separated(
          separatorBuilder: (context, index) => Divider(
                color: Colors.grey,
              ),
          itemCount: send.length,
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
                  "${send[index].receiverName.toString()} ${send[index].receiverName.toString()}"),
              trailing: Text(
                CurrencyUtils.formatCurrency(send[index].amount.toString()),
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: secondaryPrimaryDark),
              ),
              subtitle: Text(
                send[index].transferDate,
              ),
            );
          }),
    );
  }
}
