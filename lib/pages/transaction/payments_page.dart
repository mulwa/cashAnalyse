import 'package:flutter/material.dart';
import 'package:mpesa_ledger/pages/widgets/error_message.dart';
import 'package:mpesa_ledger/pages/widgets/total_display_widget.dart';
import 'package:mpesa_ledger/providers/app_state.dart';
import 'package:mpesa_ledger/utils/color.dart';
import 'package:mpesa_ledger/utils/currencyUtil.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TotalWidget(
            title: "Cash spend on payments",
            total: "2000",
            bgColor: colorPrimary,
          ),
          Expanded(
            child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) => Divider(
                      color: Colors.grey,
                    ),
                itemCount: 1,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: colorPrimary,
                      child: Text("cm"),
                    ),
                    title: Text("Christopher Mulwa"),
                    trailing: Text(
                      CurrencyUtils.formatCurrency("45800"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: secondaryPrimaryDark),
                    ),
                    subtitle: Text("14/52/2021"),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
