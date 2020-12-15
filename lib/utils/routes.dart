import 'package:flutter/material.dart';
import 'package:mpesa_ledger/pages/home_page.dart';
import 'package:mpesa_ledger/pages/loginPage.dart';
import 'package:mpesa_ledger/pages/signupPage.dart';
import 'package:mpesa_ledger/pages/wrapper.dart';

var routes = <String, WidgetBuilder>{
  "/home": (BuildContext context) => HomePage(),
  "/login": (BuildContext context) => LoginPage(),
  "/signUp": (BuildContext context) => SignUpPage(),
  "/wrapper": (BuildContext context) => Wrapper(),
};
