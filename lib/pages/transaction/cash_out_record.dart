import 'package:flutter/material.dart';
import 'package:mpesa_ledger/models/expenditure.model.dart';
import 'package:mpesa_ledger/models/group.model.dart';
import 'package:mpesa_ledger/pages/transaction/widgets/confirm_expenditure.dart';
import 'package:mpesa_ledger/pages/widgets/custom_input_decoration.dart';
import 'package:mpesa_ledger/pages/widgets/dialogs_class.dart';
import 'package:mpesa_ledger/pages/widgets/progress_dialog.dart';
import 'package:mpesa_ledger/pages/widgets/roundedApealBtn.dart';
import 'package:mpesa_ledger/services/firestore_service.dart';
import 'package:mpesa_ledger/utils/color.dart';
import 'package:mpesa_ledger/utils/constants.dart';

class CashOutPage extends StatefulWidget {
  final Group group;

  CashOutPage({Key key, @required this.group}) : super(key: key);

  @override
  _CashOutPageState createState() => _CashOutPageState();
}

class _CashOutPageState extends State<CashOutPage> {
  int _selectedOption = 1;
  TextEditingController _amountController = TextEditingController();
  TextEditingController _mpesaController = TextEditingController();
  TextEditingController _expenditureDescController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  TextEditingController _phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DatabaseService _databaseService = DatabaseService();

  final FocusNode _nameFocusNode = FocusNode();

  final FocusNode _mobileNoFocusNode = FocusNode();

  final FocusNode _amountFocusNode = FocusNode();

  final FocusNode _mpesaFocusNode = FocusNode();

  void _expenditureEditingComplete() {
    FocusScope.of(context)
        .requestFocus(_selectedOption == 1 ? _mpesaFocusNode : _nameFocusNode);
  }

  void _nameEditingComplete() {
    FocusScope.of(context).requestFocus(_mobileNoFocusNode);
  }

  void _mobileNoEditingComplete() {
    FocusScope.of(context).requestFocus(_amountFocusNode);
  }

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

  Widget _buildExpenditureField() {
    return TextFormField(
      decoration: CustomInputDecoration(
          hintText: 'Transport Cost', labelText: 'Expenditure description'),
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      onEditingComplete: _expenditureEditingComplete,
      controller: _expenditureDescController,
      validator: (String value) {
        if (value.isEmpty) {
          return "Expenditure description";
        }
        return null;
      },
      onSaved: (String value) {},
    );
  }

  Widget _buildMpesaField() {
    return TextFormField(
      decoration: CustomInputDecoration(
        hintText:
            'Paste  Mpesa transaction here (only Payment and Sent messages)',
      ),
      maxLines: 7,
      textInputAction: TextInputAction.done,
      showCursor: true,
      focusNode: _mpesaFocusNode,
      controller: _mpesaController,
      style: TextStyle(fontSize: 18.0),
      validator: (String value) {
        if (value.isEmpty) {
          return "Mpesa Message is Required";
        }
        return null;
      },
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      decoration: CustomInputDecoration(
        hintText: 'Paid To',
      ),
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      focusNode: _nameFocusNode,
      onEditingComplete: _nameEditingComplete,
      controller: _nameController,
      validator: (String value) {
        if (value.isEmpty) {
          return "Who received Payment";
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
      onSaved: (String value) {},
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      decoration: InputDecoration(
          hintText: 'Amount Paid',
          border: InputBorder.none,
          fillColor: inputBackground,
          filled: true),
      controller: _amountController,
      focusNode: _amountFocusNode,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      validator: (String value) {
        if (value.isEmpty) {
          return "Amount to paid is required";
        }
        return null;
      },
      onSaved: (String value) {},
      onChanged: (value) {},
    );
  }

  Widget _cashUi() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildNameField(),
          SizedBox(
            height: 10,
          ),
          _buildPhoneNumberField(),
          SizedBox(
            height: 10,
          ),
          _buildAmountField()
        ],
      ),
    );
  }

  Widget _mpesaUi() {
    return Column(
      children: [
        Text(
            "If You Paid Through Buy Goods, Pay Bill or Sent Via Mpesa Paste Message Bellow",
            style: TextStyle(fontSize: 18.0, color: Colors.black54)),
        SizedBox(
          height: 10,
        ),
        _mpesaController.text.isNotEmpty
            ? Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  child: IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: colorPrimary,
                      ),
                      onPressed: () {
                        _mpesaController.clear();
                      }),
                ),
              )
            : Container(),
        _buildMpesaField(),
      ],
    );
  }

  void _handleMpesaUpload(BuildContext context, {String mpesaMsg}) {
    if (mpesaMsg.isNotEmpty) {
      var amount;
      var name;
      var phoneNumber;
      var date;
      if (mpesaMsg.contains("sent") || mpesaMsg.contains("paid")) {
        if (mpesaMsg.contains("sent")) {
          RegExp regExp = new RegExp(Constants.sentRegex);
          print("..............Sent..................");
          var matches = regExp.allMatches(mpesaMsg);
          amount = matches.elementAt(0).group(1);
          name = matches.elementAt(0).group(2);
          phoneNumber = matches.elementAt(0).group(3);
          date = matches.elementAt(0).group(4);
        } else if (mpesaMsg.contains("paid")) {
          RegExp regExp = new RegExp(Constants.paidRegex);
          print("..............paid..................");
          var matches = regExp.allMatches(mpesaMsg);
          amount = matches.elementAt(0).group(1);
          name = matches.elementAt(0).group(2);
          phoneNumber = "070000000";
          date = matches.elementAt(0).group(3);
        }
        Expenditure expenditure = Expenditure(
            amount: amount,
            mode: "Mpesa",
            phoneNumber: phoneNumber,
            receiverName: name,
            transactionDate: date,
            title: _expenditureDescController.text.trim());
        showDialog(
            context: context,
            builder: (dialogContext) => ConfirmExpenditure(
                okayPress: () {
                  Navigator.of(dialogContext).pop();
                  postExpenditure(context, expenditure: expenditure);
                },
                expenditure: expenditure));
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
              "Invalid Mpesa Message, only Send Money and Lipa na Mpesa Message Support "),
          duration: Duration(seconds: 4),
        ));
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Please Paste Mpesa Message"),
        duration: Duration(seconds: 3),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Expenditure",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: ListView(
          children: [
            Text(
              "Select Mode Of Payment",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 10.0,
            ),
            _buildOptions(),
            SizedBox(height: 10),
            _buildExpenditureField(),
            SizedBox(
              height: 10,
            ),
            Container(
              child: _selectedOption == 1 ? _mpesaUi() : _cashUi(),
            ),
            SizedBox(
              height: 10,
            ),
            RoundedApealBtn(
              text: "Continue",
              press: () {
                FocusScope.of(context).requestFocus(FocusNode());
                print(_selectedOption);
                if (_selectedOption == 2) {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    Expenditure expenditure = Expenditure(
                        amount: _amountController.text.trim(),
                        mode: "Cash",
                        phoneNumber: _phoneNumberController.text.trim(),
                        receiverName: _nameController.text.trim(),
                        transactionDate: DateTime.now().toString(),
                        title: _expenditureDescController.text.trim());
                    showDialog(
                        context: context,
                        builder: (dialogContext) => ConfirmExpenditure(
                            okayPress: () {
                              Navigator.of(dialogContext).pop();
                              postExpenditure(context,
                                  expenditure: expenditure);
                            },
                            expenditure: expenditure));
                  } else {
                    print("validations Error");
                  }
                } else {
                  _handleMpesaUpload(context, mpesaMsg: _mpesaController.text);
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void postExpenditure(BuildContext context,
      {@required Expenditure expenditure}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProgressDialog(
        status: "Uploading Expenditure..",
      ),
    );

    try {
      var res = await DatabaseService().storeExpenditure(
          projectId: widget.group.id, expenditure: expenditure);
      Navigator.pop(context);
      if (res != null) {
        Navigator.pop(context);
        // _formKey.currentState.reset();
        // _expenditureDescController.clear();
        // _mpesaController.clear();
      }
    } catch (error) {
      print("An error $error");
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Unable to Submit Expenditure"),
        duration: Duration(seconds: 3),
      ));
    }
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _selectedOption = value;
    });
  }
}
