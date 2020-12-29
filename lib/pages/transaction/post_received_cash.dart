import 'package:flutter/material.dart';
import 'package:mpesa_ledger/pages/widgets/custom_input_decoration.dart';
import 'package:mpesa_ledger/pages/widgets/dialogs_class.dart';
import 'package:mpesa_ledger/pages/widgets/progress_dialog.dart';
import 'package:mpesa_ledger/pages/widgets/roundedApealBtn.dart';
import 'package:mpesa_ledger/providers/app_state.dart';
import 'package:mpesa_ledger/utils/constants.dart';
import 'package:provider/provider.dart';

class PostReceivedCash extends StatelessWidget {
  TextEditingController _textController = TextEditingController();

  Widget _buildTicketDescField() {
    return TextFormField(
      decoration: CustomInputDecoration(
        hintText: 'Paste  Mpesa transaction here message for received Cash ',
      ),
      maxLines: 7,
      textInputAction: TextInputAction.done,
      showCursor: true,
      controller: _textController,
      style: TextStyle(fontSize: 18.0),
      validator: (String value) {
        if (value.isEmpty) {
          return "Mpesa Message is Required";
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Cash In",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildTicketDescField(),
            SizedBox(
              height: 20.0,
            ),
            RoundedApealBtn(
              text: "Post",
              press: () {
                if (_textController.text.contains("received")) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => ProgressDialog(
                      status: "Submitting your transaction message..",
                    ),
                  );
                  Provider.of<AppState>(context, listen: false)
                      .addCashReceived(mpesaMessage: _textController.text);
                } else {
                  CustomDialogs.showDialogBox(
                      title: "Error Invalid Message !",
                      message:
                          "The message you pasted is invalid,Copy the transaction message from Mpesa",
                      context: context);
                }

                // print("..$name....$amount.. $phoneNumber. $date.");
                // context.watch<AppState>()
                //     .addCashReceived(mpesaMessage: _textController.text);
              },
            )
          ],
        ),
      ),
    );
  }
}
