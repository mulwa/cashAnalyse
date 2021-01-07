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

  // final products = <Product>[
  //   Product('19874', pw.LoremText().word(), 3.99, 2),
  //   Product('98452', pw.LoremText().sentence(6), 15, 2),
  //   Product('28375', pw.LoremText().sentence(4), 6.95, 3),
  //   Product('95673', pw.LoremText().sentence(3), 49.99, 4),
  //   Product('23763', pw.LoremText().sentence(2), 560.03, 1),
  //   Product('55209', pw.LoremText().sentence(5), 26, 1),
  //   Product('09853', pw.LoremText().sentence(5), 26, 1),
  //   Product('23463', pw.LoremText().sentence(5), 34, 1),
  //   Product('56783', pw.LoremText().sentence(5), 7, 4),
  //   Product('78256', pw.LoremText().sentence(5), 23, 1),
  //   Product('23745', pw.LoremText().sentence(5), 94, 1),
  //   Product('07834', pw.LoremText().sentence(5), 12, 1),
  //   Product('23547', pw.LoremText().sentence(5), 34, 1),
  //   Product('98387', pw.LoremText().sentence(5), 7.99, 2),
  // ];

  @override
  Widget build(BuildContext context) {
    List<Received> _received = Provider.of<List<Received>>(context);
    List<Expenditure> expenditure = Provider.of<List<Expenditure>>(context);
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
                DashboardCard(
                  title: "Total cash in",
                  icon: Icons.arrow_downward,
                  amount: "Ksh 60,200.00",
                ),
                SizedBox(
                  height: 6.0,
                ),
                DashboardCard(
                    title: "Total cash out",
                    icon: Icons.arrow_upward,
                    amount: "Ksh 35,200.00"),

                SizedBox(
                  height: 10.0,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      icon: Icon(Icons.picture_as_pdf),
                      onPressed: () {
                        AnalysisPrint(
                                received: _received, expenditure: expenditure)
                            .generatePdf(context);
                      }),
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
  const DashboardCard({
    Key key,
    this.icon,
    this.title,
    this.amount,
  }) : super(key: key);

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
            Icon(
              icon,
              color: secondaryPrimaryDark,
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
                  amount,
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
