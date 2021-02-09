import 'package:flutter/material.dart';
import 'package:mpesa_ledger/models/group.model.dart';
import 'package:mpesa_ledger/utils/color.dart';

class GroupDetails extends StatelessWidget {
  final Group group;

  const GroupDetails({Key key, @required this.group}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Group Summary',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildColumn(title: "Group Name", value: group.title),
              Divider(),
              buildColumn(title: "Group Description", value: group.description),
              Divider(),
              buildColumn(title: "Members", value: "20"),
              Divider(),
              buildColumn(
                  title: "Total Cash in Records",
                  value: group.totalCashInCount.toString()),
              Divider(),
              buildColumn(
                  title: "Total Cash Out Records",
                  value: group.totalCashOutCount.toString()),
              Divider(),
              buildColumn(title: "Payment Status", value: "pending"),
              Divider(),
              buildColumn(
                  title: "Payment expire", value: group.timestamp.toString()),
            ],
          ),
        ),
      ),
    );
  }

  Column buildColumn({String title, String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 3.0),
        Text(
          title,
          style: TextStyle(fontSize: 18.0, color: colorPrimary),
        ),
        SizedBox(height: 3.0),
        Text(
          value,
          style: TextStyle(fontSize: 16, color: Colors.grey[25]),
        ),
        SizedBox(height: 3.0),
      ],
    );
  }
}
