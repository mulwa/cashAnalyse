import 'package:flutter/material.dart';
import 'package:mpesa_ledger/providers/app_state.dart';
import 'package:mpesa_ledger/utils/color.dart';
import 'package:provider/provider.dart';
import 'package:mpesa_ledger/utils/currencyUtil.dart';

class MoneyOutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var payments =
        Provider.of<AppState>(context, listen: false).paymentMessages;
    return Scaffold(
      body: ListView.separated(
          separatorBuilder: (context, index) => Divider(
                color: Colors.grey,
              ),
          itemCount: payments.length,
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
                  "${payments[index].receiverName.toString()} ${payments[index].receiverName.toString()}"),
              trailing: Text(
                CurrencyUtils.formatCurrency(payments[index].amount.toString()),
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: secondaryPrimaryDark),
              ),
              subtitle: Text(
                payments[index].transferDate,
              ),
            );
          }),
    );
  }
}
