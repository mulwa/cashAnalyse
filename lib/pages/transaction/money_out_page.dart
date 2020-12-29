import 'package:flutter/material.dart';
import 'package:mpesa_ledger/pages/widgets/total_display_widget.dart';
import 'package:mpesa_ledger/providers/cash_out_provider.dart';
import 'package:mpesa_ledger/utils/color.dart';
import 'package:provider/provider.dart';
import 'package:mpesa_ledger/utils/currencyUtil.dart';

class MoneyOutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _cashOutProvider = Provider.of<CashOutProvider>(context);
    var _cashOut = _cashOutProvider.cashOut;
    print("total money out ${_cashOutProvider.totalCashOut}");

    return Scaffold(
      body: Column(
        children: [
          TotalWidget(
            title: "Total cash out",
            total: context.watch<CashOutProvider>().totalCashOut.toString(),
          ),
          Expanded(
            child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) => Divider(
                      color: Colors.grey,
                    ),
                itemCount: _cashOut.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: secondaryPrimaryDark,
                      child: Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                        "${_cashOut[index].receiverName.toString()} ${_cashOut[index].receiverName.toString()}"),
                    trailing: Text(
                      CurrencyUtils.formatCurrency(
                          _cashOut[index].amount.toString()),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: secondaryPrimaryDark),
                    ),
                    subtitle: Text(
                      _cashOut[index].transferDate,
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
