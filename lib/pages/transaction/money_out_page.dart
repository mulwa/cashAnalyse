import 'package:flutter/material.dart';
import 'package:mpesa_ledger/pages/widgets/total_display_widget.dart';
import 'package:mpesa_ledger/utils/color.dart';
import 'package:provider/provider.dart';
import 'package:mpesa_ledger/utils/currencyUtil.dart';

class MoneyOutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TotalWidget(
            title: "Total cash out",
            total: "000",
          ),
          Expanded(
            child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) => Divider(
                      color: Colors.grey,
                    ),
                itemCount: 0,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: secondaryPrimaryDark,
                      child: Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                      ),
                    ),
                    title: Text("Mulwa christopher"),
                    trailing: Text(
                      CurrencyUtils.formatCurrency(100000000),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: secondaryPrimaryDark),
                    ),
                    subtitle: Text("124/12/52"),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
