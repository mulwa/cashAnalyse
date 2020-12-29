import 'package:flutter/material.dart';
import 'package:mpesa_ledger/pages/widgets/custom_input_decoration.dart';
import 'package:mpesa_ledger/pages/widgets/roundedApealBtn.dart';

class CreateGroup extends StatelessWidget {
  Widget _buildGroupNameField() {
    return TextFormField(
      decoration: CustomInputDecoration(
        hintText: 'Group Name',
      ),
      textInputAction: TextInputAction.next,
      validator: (String value) {
        if (value.isEmpty) {
          return "Group Name is required";
        }
        return null;
      },
      onSaved: (String value) {},
    );
  }

  Widget _buildGroupDescriptionField() {
    return TextFormField(
      decoration: CustomInputDecoration(
        hintText: 'Group description',
      ),
      textInputAction: TextInputAction.next,
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
        title: Text("Create Group"),
      ),
      body: Column(
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
            text: "Create Group",
            press: () {
              print("Creating group");
            },
          )
        ],
      ),
    );
  }
}
