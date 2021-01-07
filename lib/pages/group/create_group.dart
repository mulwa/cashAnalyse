import 'package:flutter/material.dart';
import 'package:mpesa_ledger/models/group.model.dart';
import 'package:mpesa_ledger/pages/widgets/custom_input_decoration.dart';
import 'package:mpesa_ledger/pages/widgets/progress_dialog.dart';
import 'package:mpesa_ledger/pages/widgets/roundedApealBtn.dart';
import 'package:mpesa_ledger/services/firestore_service.dart';

class CreateGroup extends StatelessWidget {
  final Group group;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  DatabaseService _databaseService = DatabaseService();

  CreateGroup({Key key, this.group}) : super(key: key);

  Widget _buildGroupNameField() {
    return TextFormField(
      decoration: CustomInputDecoration(
        hintText: 'Group Name',
      ),
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      controller: _titleController..text = group != null ? group.title : "",
      validator: (String value) {
        if (value.isEmpty) {
          return "Group Name is required";
        }
        return null;
      },
      onSaved: (String value) {},
    );
  }
  // _titleController.text = "";

  Widget _buildGroupDescriptionField() {
    return TextFormField(
      decoration: CustomInputDecoration(
        hintText: 'Group description',
      ),
      textInputAction: TextInputAction.done,
      controller: _descriptionController
        ..text = group != null ? group.description : "",
      maxLines: 4,
      validator: (String value) {
        if (value.isEmpty) {
          return "Group description is required";
        }
        return null;
      },
      onSaved: (String value) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          group != null ? "Edit ${group.title}" : "Create Group",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16.0),
        child: Column(
          children: [
            _buildGroupNameField(),
            SizedBox(
              height: 15,
            ),
            _buildGroupDescriptionField(),
            SizedBox(
              height: 15,
            ),
            RoundedApealBtn(
                text: group != null ? "Update Group" : "Create Group",
                press: () {
                  group != null
                      ? _handleGroupUpdate(context)
                      : _handleGroupCreation(context);
                })
          ],
        ),
      ),
    );
  }

  _handleGroupCreation(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => ProgressDialog(
        status: "Creating Group",
      ),
    );
    try {
      var res = await _databaseService.createProject(
          title: _titleController.text,
          description: _descriptionController.text);
      Navigator.pop(context);
      Navigator.pop(context);

      if (res != null) {
        _titleController.clear();
        _descriptionController.clear();
      }
    } catch (e) {
      Navigator.pop(context);
      print("Try Catched $e");
    }
  }

  _handleGroupUpdate(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => ProgressDialog(
        status: "Updating Group",
      ),
    );
    try {
      await _databaseService.updateProject(
          projectId: group.id,
          title: _titleController.text,
          description: _descriptionController.text);
      Navigator.pop(context);
      Navigator.pop(context);
      _titleController.clear();
      _descriptionController.clear();
    } catch (e) {
      Navigator.pop(context);
      print("Try Catched $e");
    }
  }
}
