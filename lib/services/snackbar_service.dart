import 'package:flutter/material.dart';

class SnackBarService {
  BuildContext _buildContext;
  static SnackBarService instance = SnackBarService();
  SnackBarService();
  set buildContext(BuildContext _context) {
    _buildContext = _context;
  }

  void showSnackBarError({String message}) {
    Scaffold.of(_buildContext).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white, fontSize: 15.0),
      ),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    ));
  }

  void showSnackBarSuccess({String message}) {
    Scaffold.of(_buildContext).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white, fontSize: 15.0),
      ),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
    ));
  }
}
