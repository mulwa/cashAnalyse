import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mpesa_ledger/models/expenditure.model.dart';
import 'package:mpesa_ledger/models/group.model.dart';
import 'package:mpesa_ledger/models/received.model.dart';
import 'package:mpesa_ledger/pages/group/create_group.dart';
import 'package:mpesa_ledger/pages/group/group_details.dart';
import 'package:mpesa_ledger/pages/main_entry.dart';
import 'package:mpesa_ledger/pages/widgets/drawer.dart';
import 'package:mpesa_ledger/pages/widgets/error_message.dart';
import 'package:mpesa_ledger/pages/widgets/pop_up_option_menu.dart';
import 'package:mpesa_ledger/pages/widgets/progress_dialog.dart';
import 'package:mpesa_ledger/services/firestore_service.dart';
import 'package:mpesa_ledger/utils/color.dart';
import 'package:provider/provider.dart';

class GroupListPage extends StatelessWidget {
  DatabaseService _databaseService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text(
            "My Projects",
            style: TextStyle(color: Colors.white),
          ),
          actions: [PopupOptionMenu()],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: StreamBuilder(
              stream: _databaseService.getUserProject(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return ErrorMessage(
                    errorMessage: snapshot.error,
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.data == null)
                  return Center(child: CircularProgressIndicator());

                List<Group> _groups = snapshot.data.docs
                    .map((DocumentSnapshot doc) => Group.fromDataSnapshot(doc))
                    .toList();
                print(_groups.length);

                return _groups.length > 0
                    ? ListView.separated(
                        separatorBuilder: (context, index) => Divider(),
                        itemCount: _groups.length,
                        itemBuilder: (context, index) => ListTile(
                              leading: CircleAvatar(
                                  backgroundColor: colorPrimary,
                                  child: Text("${index + 1}")),
                              title: Text(_groups[index].title),
                              subtitle: Text(_groups[index].description),
                              trailing: IconButton(
                                  icon: Icon(Icons.more_vert),
                                  onPressed: () => _optionSelection(context,
                                      group: _groups[index])),
                              onTap: () => {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return MultiProvider(
                                    providers: [
                                      StreamProvider<List<Received>>.value(
                                        value: DatabaseService()
                                            .getProjectsCashIn(
                                                projectId: _groups[index].id),
                                      ),
                                      StreamProvider<List<Expenditure>>.value(
                                        value: DatabaseService()
                                            .getProjectExpenditure2(
                                                projectId: _groups[index].id),
                                      ),
                                      FutureProvider<Group>.value(
                                          value: DatabaseService()
                                              .getSingleProject(
                                                  projectId: _groups[index].id))
                                    ],
                                    child: MainEntryPage(
                                      group: _groups[index],
                                    ),
                                  );
                                }))
                              },
                            ))
                    : Center(
                        child: ErrorMessage(
                            errorMessage:
                                "No Project Found Create one an start adding Contributions"),
                      );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // _showNotificationWithDefaultSound();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateGroup()));
          },
          child: Icon(
            Icons.add_circle,
            color: Colors.white,
          ),
        ));
  }

  _optionSelection(BuildContext parentContext, {Group group}) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Options"),
          children: [
            SimpleDialogOption(
              child: Row(
                children: [
                  Icon(Icons.info),
                  SizedBox(
                    width: 10,
                  ),
                  Text("About this group")
                ],
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GroupDetails(
                              group: group,
                            )));
              },
            ),
            Divider(),
            SimpleDialogOption(
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Edit")
                ],
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateGroup(
                              group: group,
                            )));
              },
            ),
            Divider(),
            SimpleDialogOption(
              child: Row(
                children: [
                  Icon(Icons.delete_forever),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Delete")
                ],
              ),
              onPressed: () => _handleGroupDelete(context, group: group),
            ),
            Divider(),
            SizedBox(
              height: 10,
            ),
            Center(
              child: SimpleDialogOption(
                child: Text(
                  "Cancel",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            )
          ],
        );
      },
    );
  }

  _handleGroupDelete(BuildContext context, {Group group}) {
    // Navigator.pop(context);
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () async {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => ProgressDialog(
            status: "Deleting ${group.title}",
          ),
        );
        try {
          await _databaseService.deleteProject(projectId: group.id);
          Navigator.pop(context);
          Navigator.pop(context);
        } catch (e) {
          print("deleting error $e");
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("Are you sure you want to delete ${group.title}"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
