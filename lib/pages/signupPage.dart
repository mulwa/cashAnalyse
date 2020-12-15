import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mpesa_ledger/pages/loginPage.dart';
import 'package:mpesa_ledger/pages/widgets/app_card.dart';
import 'package:mpesa_ledger/pages/widgets/custom_input_decoration.dart';
import 'package:mpesa_ledger/pages/widgets/progress_dialog.dart';
import 'package:mpesa_ledger/pages/widgets/roundedApealBtn.dart';
import 'package:mpesa_ledger/pages/widgets/vertical_spacing.dart';
import 'package:mpesa_ledger/services/firestore_service.dart';
import 'package:mpesa_ledger/utils/color.dart';
import 'package:mpesa_ledger/services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  static const String routeName = '/signup';
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final FocusNode _snameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  final TextEditingController _passWordCtrl = TextEditingController();
  final TextEditingController _firstNameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_phoneFocusNode);
  }

  void _passwordEditingComplete() {
    FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
  }

  void _showError(String error) {
    final snackBar = SnackBar(
      content: Text(error),
      backgroundColor: Theme.of(context).errorColor,
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  String validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter mail';
    }
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String validatePassword(String value) {
    if (value.isEmpty) return 'Please Enter password';
    if (value.length < 8) return 'Password should be more than 8 characters';
    return null;
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: CustomInputDecoration(
        labelText: 'Email Address',
      ),
      focusNode: _emailFocusNode,
      textInputAction: TextInputAction.next,
      controller: _emailCtrl,
      onEditingComplete: _emailEditingComplete,
      keyboardType: TextInputType.emailAddress,
      validator: validateEmail,
      onSaved: (String value) {},
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: CustomInputDecoration(
        labelText: 'Password',
      ),
      obscureText: true,
      controller: _passWordCtrl,
      focusNode: _passwordFocusNode,
      textInputAction: TextInputAction.next,
      onEditingComplete: _passwordEditingComplete,
      validator: validatePassword,
      onSaved: (String value) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 250.0,
              decoration: BoxDecoration(color: colorPrimaryDark),
            ),
            Padding(
              padding: EdgeInsets.only(top: 60.0, left: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Grow Your Savings",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24.0,
                        color: textColor),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 150.0, right: 10.0, left: 10.0),
              height: MediaQuery.of(context).size.height,
              child: AppCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      VerticalSpacing(
                        height: 15,
                      ),
                      Text("Sign Up",
                          style: TextStyle(color: textColor, fontSize: 20.0)),
                      VerticalSpacing(
                        height: 15,
                      ),
                      _buildEmailField(),
                      VerticalSpacing(),
                      _buildPasswordField(),
                      VerticalSpacing(),
                      RoundedApealBtn(
                        text: "create account",
                        press: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            try {
                              showDialog(
                                context: context,
                                builder: (context) => ProgressDialog(
                                  status: "Creating Account Please Wait ....",
                                ),
                              );
                              UserCredential userCredential =
                                  await AuthService.signUpWithEmail(
                                      email: _emailCtrl.text,
                                      password: _passWordCtrl.text);
                              Navigator.pop(context);

                              if (userCredential.user != null) {
                                print("registered successfully");
                                scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text(
                                  "Registered Successfully",
                                  textAlign: TextAlign.center,
                                )));
                                DatabaseService.storeUser(
                                  uid: userCredential.user.uid,
                                  email: userCredential.user.email,
                                );

                                Navigator.of(context)
                                    .pushReplacementNamed('/home');
                              } else {
                                print("unable to create user");
                              }
                            } catch (e) {
                              FirebaseAuthException fAE = e;
                              _showError(fAE.message);
                              Navigator.pop(context);
                              print(e);
                            }
                          }
                          return;
                        },
                      ),
                      VerticalSpacing(),
                      Center(
                        child: RichText(
                          text: TextSpan(
                              text: "Already have an account?",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                              children: <TextSpan>[
                                TextSpan(
                                    text: " Login",
                                    style: TextStyle(
                                        color: colorPrimaryDark,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w400),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        print("login clicked");
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginPage()));
                                      })
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
