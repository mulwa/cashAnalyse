import 'package:flutter/material.dart';
import 'package:mpesa_ledger/models/group.model.dart';
import 'package:mpesa_ledger/pages/analysis_page.dart';
import 'package:mpesa_ledger/pages/transaction_page.dart';

class MainEntryPage extends StatefulWidget {
  final Group group;

  const MainEntryPage({Key key, @required this.group}) : super(key: key);
  @override
  _MainEntryPageState createState() => _MainEntryPageState();
}

class _MainEntryPageState extends State<MainEntryPage> {
  int _selectedIndex = 0;

  void _onBarItemTap(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        TransactionPage(group: widget.group),
        AnalysisPage(group: widget.group)
      ].elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              title: Text("Transactions"), icon: Icon(Icons.history)),
          BottomNavigationBarItem(
              title: Text("Analysis"), icon: Icon(Icons.graphic_eq)),
        ],
        onTap: _onBarItemTap,
        currentIndex: _selectedIndex,
      ),
    );
  }
}
