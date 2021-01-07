import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mpesa_ledger/pages/wrapper.dart';
import 'package:mpesa_ledger/providers/app_state.dart';
import 'package:mpesa_ledger/utils/color.dart';
import 'package:mpesa_ledger/utils/routes.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'pesa analytica',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: colorPrimary,
            accentColor: colorAccent,
            tabBarTheme: TabBarTheme(
                labelStyle: GoogleFonts.montserrat(fontSize: 16),
                unselectedLabelStyle: GoogleFonts.montserrat(fontSize: 16)),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: AppBarTheme(
              textTheme:
                  GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
            ),
            textTheme:
                GoogleFonts.montserratTextTheme(Theme.of(context).textTheme)),
        home: Wrapper(),
        routes: routes,
      ),
    );
  }
}
