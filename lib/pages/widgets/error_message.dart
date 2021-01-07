import 'package:flutter/material.dart';
import 'package:mpesa_ledger/utils/color.dart';

class ErrorMessage extends StatelessWidget {
  final String errorMessage;

  const ErrorMessage({Key key, @required this.errorMessage}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        errorMessage,
        style: TextStyle(color: colorPrimary, fontSize: 18.0),
        textAlign: TextAlign.center,
      ),
    );
  }
}
