import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mpesa_ledger/pages/graphs/linechart_page.dart';
import 'package:mpesa_ledger/pages/widgets/drawer.dart';
import 'package:mpesa_ledger/utils/color.dart';

class AnalysisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenBackground,
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          ListView(
            // scrollDirection: Axis.horizontal,
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
                height: 6.0,
              ),
              DashboardCard(
                  title: "Payments",
                  icon: Icons.arrow_upward,
                  amount: "Ksh 10,200.00"),
              SizedBox(
                height: 10,
              ),
              LineChartPage(),
            ],
          )
        ],
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
                Text(title, style: TextStyle(fontSize: 14.0)),
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
