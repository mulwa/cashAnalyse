import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mpesa_ledger/models/group.model.dart';
import 'package:mpesa_ledger/models/received.model.dart';
import 'package:mpesa_ledger/pages/transaction/widgets/confirm_cash_recevied.dart';
import 'package:mpesa_ledger/pages/widgets/custom_input_decoration.dart';
import 'package:mpesa_ledger/pages/widgets/dialogs_class.dart';
import 'package:mpesa_ledger/pages/widgets/progress_dialog.dart';
import 'package:mpesa_ledger/pages/widgets/roundedApealBtn.dart';
import 'package:mpesa_ledger/services/firestore_service.dart';
import 'package:mpesa_ledger/utils/color.dart';
import 'package:mpesa_ledger/utils/constants.dart';
import 'package:uuid/uuid.dart';

class PostReceivedCash extends StatefulWidget {
  final Group group;

  PostReceivedCash({Key key, @required this.group}) : super(key: key);

  @override
  _PostReceivedCashState createState() => _PostReceivedCashState();
}

class _PostReceivedCashState extends State<PostReceivedCash> {
  int _selectedOption = 1;

  Widget _buildOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Radio(
          value: 1,
          groupValue: _selectedOption,
          onChanged: _handleRadioValueChange,
        ),
        Text('Mpesa'),
        Radio(
          value: 2,
          groupValue: _selectedOption,
          onChanged: _handleRadioValueChange,
        ),
        Text('Cash'),
      ],
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
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "Select Mode Your Received Money",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(
              height: 4.0,
            ),
            _buildOptions(),
            Expanded(
              child: _selectedOption == 1
                  ? MpesaUiWidget(
                      group: widget.group,
                    )
                  : CashUiWidget(
                      group: widget.group,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _selectedOption = value;
    });
  }
}

class MpesaUiWidget extends StatelessWidget {
  TextEditingController _textController = TextEditingController();
  DatabaseService _databaseService = DatabaseService();
  final Group group;

  MpesaUiWidget({
    Key key,
    @required this.group,
  }) : super(key: key);
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ListView(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10.0,
          ),
          Text(
            "Paste the Mpesa Message you received Below  ",
            style: TextStyle(fontSize: 18.0, color: Colors.black54),
          ),
          SizedBox(height: 10),
          _buildTicketDescField(),
          SizedBox(
            height: 20.0,
          ),
          RoundedApealBtn(
            text: "Continue",
            press: () {
              FocusScope.of(context).requestFocus(FocusNode());
              if (_textController.text.contains("received")) {
                RegExp regExp = new RegExp(Constants.newReceivedRegex);
                var matches = regExp.allMatches(_textController.text);
                print("${matches.length}");
                var transactionRef = matches.elementAt(0).group(1).trim();
                var amount = matches.elementAt(0).group(2).trim();
                var name = matches.elementAt(0).group(3).trim();
                var phoneNumber = matches.elementAt(0).group(4).trim();
                var date = matches.elementAt(0).group(5).trim();
                Received received = Received(
                    transactionRef: transactionRef,
                    amount: amount,
                    mode: "Mpesa",
                    senderName: name,
                    phoneNumber: phoneNumber,
                    transactionDate: date);

                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (dialogContext) => ConfirmCashReceived(
                    received: received,
                    okayPress: () {
                      Navigator.pop(dialogContext);
                      _postReceived(context, received: received);
                    },
                  ),
                );
              } else {
                CustomDialogs.showDialogBox(
                    title: "Error Invalid Message !",
                    message:
                        "The message you pasted is invalid,Copy the transaction message from Mpesa",
                    context: context);
              }
            },
          )
        ],
      ),
    );
  }

  void _postReceived(BuildContext context,
      {@required Received received}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProgressDialog(
        status: "Submitting your transaction message..",
      ),
    );
    try {
      _databaseService.storeReceived(
          transactionRef: received.transactionRef,
          projectId: group.id,
          amount: received.amount,
          senderName: received.senderName,
          phoneNumber: received.phoneNumber,
          mode: received.mode,
          transactionDate: received.transactionDate);

      Navigator.pop(context);

      _textController.clear();

      Timer(Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    } catch (error) {
      Navigator.pop(context);
      print("error $error");
    }
  }
}

class CashUiWidget extends StatefulWidget {
  final Group group;

  CashUiWidget({Key key, @required this.group}) : super(key: key);

  @override
  _CashUiWidgetState createState() => _CashUiWidgetState();
}

class _CashUiWidgetState extends State<CashUiWidget> {
  TextEditingController _amountController = TextEditingController();

  TextEditingController _nameController = TextEditingController();

  TextEditingController _phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DatabaseService _databaseService = DatabaseService();

  final FocusNode _nameFocusNode = FocusNode();

  final FocusNode _mobileNoFocusNode = FocusNode();

  final FocusNode _amountFocusNode = FocusNode();

  void _nameEditingComplete() {
    FocusScope.of(context).requestFocus(_mobileNoFocusNode);
  }

  void _mobileNoEditingComplete() {
    FocusScope.of(context).requestFocus(_amountFocusNode);
  }

  Widget _buildNameField() {
    return TextFormField(
      decoration: CustomInputDecoration(
        hintText: 'Received From',
      ),
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      focusNode: _nameFocusNode,
      onEditingComplete: _nameEditingComplete,
      controller: _nameController,
      validator: (String value) {
        if (value.isEmpty) {
          return "Full Name is required";
        }
        return null;
      },
      onSaved: (String value) {},
    );
  }

  Widget _buildPhoneNumberField() {
    return TextFormField(
      decoration: CustomInputDecoration(
        hintText: 'Mobile Number',
      ),
      textInputAction: TextInputAction.next,
      onEditingComplete: _mobileNoEditingComplete,
      focusNode: _mobileNoFocusNode,
      keyboardType: TextInputType.number,
      textCapitalization: TextCapitalization.words,
      controller: _phoneNumberController,
      validator: (String value) {
        if (value.isEmpty) {
          return "Mobile Number";
        }
        return null;
      },
      onSaved: (String value) {},
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      decoration: InputDecoration(
          hintText: 'Amount to received',
          border: InputBorder.none,
          fillColor: inputBackground,
          filled: true),
      controller: _amountController,
      focusNode: _amountFocusNode,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      validator: (String value) {
        if (value.isEmpty) {
          return "Amount to send is required";
        }
        return null;
      },
      onSaved: (String value) {},
      onChanged: (value) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30.0),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              "If You Received Contribution Via Cash Option Please Fill the details Below",
              style: TextStyle(fontSize: 18.0, color: Colors.black54),
            ),
            SizedBox(
              height: 15.0,
            ),
            _buildNameField(),
            SizedBox(
              height: 10.0,
            ),
            _buildPhoneNumberField(),
            SizedBox(
              height: 10.0,
            ),
            _buildAmountField(),
            SizedBox(
              height: 10.0,
            ),
            RoundedApealBtn(
              text: "Continue",
              press: () {
                FocusScope.of(context).requestFocus(FocusNode());
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  var amount = _amountController.text.trim();
                  var name = _nameController.text.trim();
                  var phoneNumber = _phoneNumberController.text.trim();
                  var date = DateTime.now().toString();
                  Received received = Received(
                      transactionRef: Uuid().v4(),
                      amount: amount,
                      mode: "Cash",
                      senderName: name,
                      phoneNumber: phoneNumber,
                      transactionDate: date);
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (dialogContext) => ConfirmCashReceived(
                      received: received,
                      okayPress: () {
                        Navigator.pop(dialogContext);
                        _postReceived(context, received: received);
                      },
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void _postReceived(BuildContext context,
      {@required Received received}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProgressDialog(
        status: "Submitting your transaction message..",
      ),
    );
    try {
      await _databaseService.storeReceived(
          projectId: widget.group.id,
          transactionRef: received.transactionRef,
          amount: received.amount,
          senderName: received.senderName,
          phoneNumber: received.phoneNumber,
          mode: received.mode,
          transactionDate: received.transactionDate);
      Navigator.pop(context);
      _formKey.currentState.reset();

      Timer(Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    } catch (error) {
      Navigator.pop(context);
      print("error $error");
    }
  }
}
