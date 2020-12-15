import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mpesa_ledger/pages/loginPage.dart';
import 'package:mpesa_ledger/pages/main_entry.dart';
import 'package:mpesa_ledger/providers/app_state.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ChangeNotifierProvider(
                create: (context) => AppState(), child: MainEntryPage());
          }
          return LoginPage();
        });
  }
}
