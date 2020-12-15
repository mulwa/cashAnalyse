import 'package:flutter/material.dart';
import 'package:mpesa_ledger/pages/graphs/linechart.dart';
import 'package:mpesa_ledger/utils/color.dart';

class LineChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        color: secondaryPrimaryDark,
        child: Padding(
          padding: EdgeInsets.only(top: 16),
          child: LinearChartWidget(),
        ),
      );
}
