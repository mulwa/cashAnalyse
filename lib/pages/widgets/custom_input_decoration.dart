import 'package:flutter/material.dart';
import 'package:mpesa_ledger/utils/color.dart';

class CustomInputDecoration extends InputDecoration {
  final String labelText;
  final String hintText;

  CustomInputDecoration({this.hintText, this.labelText})
      : super(
            labelText: labelText,
            hintText: hintText,
            hintStyle: TextStyle(color: hintColor, fontSize: 18.0),
            border: InputBorder.none,
            fillColor: inputBackground,
            filled: true);
}
