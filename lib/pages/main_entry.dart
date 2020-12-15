import 'package:flutter/material.dart';
import 'package:mpesa_ledger/pages/analysis_page.dart';
import 'package:mpesa_ledger/pages/transaction_page.dart';
import 'package:mpesa_ledger/pages/widgets/drawer.dart';

class MainEntryPage extends StatefulWidget {
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
      drawer: AppDrawer(),
      body: [AnalysisPage(), TransactionPage()].elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              title: Text("Analysis"), icon: Icon(Icons.graphic_eq)),
          BottomNavigationBarItem(
              title: Text("Transactions"), icon: Icon(Icons.history)),
          // BottomNavigationBarItem(
          //     title: Text("Calender"), icon: Icon(Icons.calendar_today)),
        ],
        onTap: _onBarItemTap,
        currentIndex: _selectedIndex,
      ),
    );
  }
}
