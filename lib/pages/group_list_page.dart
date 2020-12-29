import 'package:flutter/material.dart';

class GroupListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Projects"),
      ),
      body: Column(
        children: [
          Center(
            child: Text("Project List"),
          )
        ],
      ),
    );
  }
}
