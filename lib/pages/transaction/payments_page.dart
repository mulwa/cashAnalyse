import 'package:flutter/material.dart';
import 'package:mpesa_ledger/pages/widgets/error_message.dart';
import 'package:mpesa_ledger/pages/widgets/total_display_widget.dart';
import 'package:mpesa_ledger/providers/app_state.dart';
import 'package:mpesa_ledger/providers/payment_provider.dart';
import 'package:mpesa_ledger/utils/color.dart';
import 'package:mpesa_ledger/utils/currencyUtil.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _paymentProvider = Provider.of<PaymentProvider>(context);
    var _payments = _paymentProvider.payments;
    return Scaffold(
      body: Column(
        children: [
          TotalWidget(
            title: "Cash spend on payments",
            total: _paymentProvider.totalPayments.toString(),
            bgColor: colorPrimary,
          ),
          Expanded(
            child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) => Divider(
                      color: Colors.grey,
                    ),
                itemCount: _payments.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: colorPrimary,
                      child: Text(
                          "${_payments[index].receiverName.substring(0, 2).toUpperCase()}"),
                    ),
                    title: Text(
                        "${_payments[index].receiverName.toString()} ${_payments[index].receiverName.toString()}"),
                    trailing: Text(
                      CurrencyUtils.formatCurrency(
                          _payments[index].amount.toString()),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: secondaryPrimaryDark),
                    ),
                    subtitle: Text(
                      _payments[index].transferDate,
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
