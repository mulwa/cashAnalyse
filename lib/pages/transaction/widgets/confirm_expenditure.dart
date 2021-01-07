import 'package:flutter/material.dart';
import 'package:mpesa_ledger/models/expenditure.model.dart';
import 'package:mpesa_ledger/pages/widgets/roundedApealBtn.dart';
import 'package:mpesa_ledger/utils/color.dart';
import 'package:mpesa_ledger/utils/currencyUtil.dart';

class ConfirmExpenditure extends StatelessWidget {
  final Function okayPress;
  final Expenditure expenditure;

  const ConfirmExpenditure(
      {Key key, @required this.okayPress, @required this.expenditure})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(4.0)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Confirm Paid", style: titleStyle),
                SizedBox(
                  height: 10.0,
                ),
                Divider(),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        expenditure.receiverName,
                        style: subtitleStyle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        expenditure?.phoneNumber,
                        style: subtitleStyle,
                      ),
                    ),
                  ],
                ),
                Divider(),
                SizedBox(
                  height: 6,
                ),
                Text(
                  expenditure.title,
                  style: subtitleStyle,
                ),
                SizedBox(
                  height: 6,
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Amount:",
                          style: titleStyle,
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          CurrencyUtils.formatCurrency(expenditure.amount
                              .toString()
                              .replaceAll(",", "")),
                          style: subtitleStyle,
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text("Payed Via: ", style: titleStyle),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          expenditure.mode,
                          style: subtitleStyle,
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: RoundedApealBtn(
                          text: "Cancel",
                          color: Colors.grey,
                          press: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: RoundedApealBtn(
                          text: "Post",
                          press: okayPress,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const TextStyle titleStyle = TextStyle(
    fontSize: 16, color: Colors.black, decoration: TextDecoration.none);

const TextStyle subtitleStyle = TextStyle(
    fontSize: 16,
    color: colorPrimaryDark,
    decoration: TextDecoration.none,
    fontWeight: FontWeight.w400);
