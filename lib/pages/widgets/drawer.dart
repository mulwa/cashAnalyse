import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: Text(""),
            accountName: Text(""),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.laughWink),
            title: Text("Terms & Conditions"),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.infoCircle),
            title: Text("About"),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.paperPlane),
            title: Text("Other Apps"),
          ),
          Divider(),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: ListTile(
                leading: Icon(FontAwesomeIcons.cog),
                title: Text("Settings"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
