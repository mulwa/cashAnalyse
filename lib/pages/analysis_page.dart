import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mpesa_ledger/models/expenditure.model.dart';
import 'package:mpesa_ledger/models/group.model.dart';
import 'package:mpesa_ledger/models/received.model.dart';
import 'package:mpesa_ledger/pages/analysisPrint.dart';
import 'package:mpesa_ledger/utils/color.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:mpesa_ledger/utils/currencyUtil.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

class AnalysisPage extends StatelessWidget {
  final Group group;

  AnalysisPage({Key key, @required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Group _group = Provider.of<Group>(context);
    List<Received> _received = Provider.of<List<Received>>(context);
    List<Expenditure> _expenditure = Provider.of<List<Expenditure>>(context);

    return Scaffold(
      backgroundColor: screenBackground,
      appBar: AppBar(
        title: Text(
          "${group.title} Dashboard",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.all(10.0),
                    width: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black38,
                              blurRadius: 15.0,
                              spreadRadius: 0.1,
                              offset: Offset(0.7, 0.7))
                        ]),
                    child: IconButton(
                        icon: Icon(
                          Icons.picture_as_pdf,
                          color: colorPrimaryDark,
                        ),
                        onPressed: () {
                          AnalysisPrint(
                            group: _group,
                            received: _received,
                            expenditure: _expenditure,
                            totalCashIn: _received
                                .map((e) => double.parse(
                                    e.amount.toString().replaceAll(",", "")))
                                .reduce((value, element) => value + element)
                                .toString(),
                            totalCashOut: _expenditure
                                .map((e) => double.parse(
                                    e.amount.toString().replaceAll(",", "")))
                                .reduce((value, element) => value + element)
                                .toString(),
                          ).generatePdf(context);
                        }),
                  ),
                ),
                DashboardCard(
                  title: "Total cash in",
                  icon: Icons.arrow_downward,
                  iconBg: colorPrimaryDark,
                  amount: _received
                      .map((e) =>
                          double.parse(e.amount.toString().replaceAll(",", "")))
                      .reduce((value, element) => value + element)
                      .toString(),
                ),
                SizedBox(
                  height: 6.0,
                ),
                DashboardCard(
                  title: "Total cash out",
                  icon: Icons.arrow_upward,
                  iconBg: colorPrimary,
                  amount: _expenditure
                      .map((e) =>
                          double.parse(e.amount.toString().replaceAll(",", "")))
                      .reduce((value, element) => value + element)
                      .toString(),
                ),

                SizedBox(
                  height: 10.0,
                ),

                // LineChartPage(),
                SizedBox(
                  height: 10.0,
                ),
                TopCashIn(),
                SizedBox(
                  height: 10.0,
                ),
                TopExpenditure()
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TopCashIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20.0, left: 10, right: 10, bottom: 10),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              "Top Cash In",
              style: TextStyle(color: colorPrimaryDark),
            ),
            SizedBox(
              height: 5.0,
            ),
            Divider(),
            SizedBox(
              height: 5.0,
            ),
            PercentageIndicatorWidget(),
            PercentageIndicatorWidget(),
            PercentageIndicatorWidget(),
          ],
        ),
      ),
    );
  }
}

class TopExpenditure extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20.0, left: 10, right: 10, bottom: 10),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              "Top Expenditure",
              style: TextStyle(color: colorPrimaryDark),
            ),
            SizedBox(
              height: 5.0,
            ),
            Divider(),
            SizedBox(
              height: 5.0,
            ),
            PercentageIndicatorWidget(
              progressColor: colorPrimary,
            ),
            PercentageIndicatorWidget(progressColor: colorPrimary),
            PercentageIndicatorWidget(progressColor: colorPrimary),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String amount;
  final Color iconBg;
  const DashboardCard(
      {Key key, this.icon, this.title, this.amount, this.iconBg})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.0),
      // height: 70.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 15.0,
                spreadRadius: 0.1,
                offset: Offset(0.7, 0.7))
          ]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15.0,
                        offset: Offset(0.7, 0.7))
                  ]),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 6.0,
            ),
            Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                      fontSize: 14.0,
                    )),
                SizedBox(
                  height: 6.0,
                ),
                Text(
                  CurrencyUtils.formatCurrency(amount),
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: secondaryPrimaryDark),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PercentageIndicatorWidget extends StatelessWidget {
  final String name;
  final String amount;
  final double percentage;
  final Color progressColor;

  const PercentageIndicatorWidget(
      {Key key,
      this.name,
      this.amount,
      this.percentage,
      this.progressColor = colorPrimaryDark})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Christopher Mulwa",
                style:
                    TextStyle(color: colorPrimary, fontWeight: FontWeight.w400),
              ),
              Text(
                CurrencyUtils.formatCurrency("1000"),
                style: TextStyle(fontWeight: FontWeight.w400),
              )
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Padding(
              padding: EdgeInsets.all(1.0),
              child: new LinearPercentIndicator(
                width: MediaQuery.of(context).size.width - 50,
                animation: true,
                lineHeight: 20.0,
                animationDuration: 2000,
                percent: 0.9,
                center: Text(
                  "90.0%",
                  style: TextStyle(color: Colors.white),
                ),
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: progressColor,
              )),
          SizedBox(
            height: 10.0,
          )
        ],
      ),
    );
  }
}
