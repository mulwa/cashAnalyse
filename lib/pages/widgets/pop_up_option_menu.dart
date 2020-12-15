import 'package:flutter/material.dart';

enum MenuOption { LogOut, TermsCondition }

class PopupOptionMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuOption>(
      onSelected: (value) => print(value),
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<MenuOption>>[
          PopupMenuItem(
            child: Text("Sign out"),
            value: MenuOption.TermsCondition,
          ),
          PopupMenuItem(
            child: Text("Terms & Conditions"),
            value: MenuOption.TermsCondition,
          ),
        ];
      },
    );
  }
}
