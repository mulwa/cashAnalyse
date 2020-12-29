import 'package:flutter/material.dart';
import 'package:mpesa_ledger/utils/color.dart';
import 'package:mpesa_ledger/utils/currencyUtil.dart';

class TotalWidget extends StatelessWidget {
  final String total;
  final String title;
  final Color bgColor;
  const TotalWidget({
    Key key,
    @required this.total,
    @required this.title,
    this.bgColor: colorPrimaryDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      color: bgColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(CurrencyUtils.formatCurrency(total),
              style: TextStyle(color: Colors.white, fontSize: 26.0)),
          SizedBox(
            height: 5.0,
          ),
          Text(
            title,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
