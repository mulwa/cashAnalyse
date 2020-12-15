import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: Text("mulwatech@gmail.com"),
            accountName: Text("Christopher Mulwa"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://media-exp1.licdn.com/dms/image/C4D03AQHR1bSfU2yM4g/profile-displayphoto-shrink_100_100/0?e=1598486400&v=beta&t=_hv2cMjpASJNYwCPntDGOYPIvWZUO6Bo6DpC8bdxEjU"),
            ),
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
