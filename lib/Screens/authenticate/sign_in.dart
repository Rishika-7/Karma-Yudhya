import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paap_punya/services/auth.dart';
import 'package:paap_punya/shared/constants.dart';
import 'package:paap_punya/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.cyan[50],
            appBar: AppBar(
              backgroundColor: Colors.cyan,
              elevation: 0.0,
              title: Text(
                'Sign in to Paap & Punya',
                style: GoogleFonts.aladin(
                  fontSize: 32,
                  color: Colors.black,
                ),
              ),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Image(
                        image: AssetImage('images/coins.png'),
                        width: 150,
                        height: 150,
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      TextFormField(
                          decoration:
                              textInputDecoration.copyWith(labelText: 'Email'),
                          validator: (val) =>
                              val.isEmpty ? 'Enter an email' : null,
                          onChanged: (val) {
                            setState(() => email = val);
                          }),
                      SizedBox(
                        height: 30.0,
                      ),
                      TextFormField(
                          decoration: textInputDecoration.copyWith(
                              labelText: 'Password'),
                          validator: (val) => val.length < 6
                              ? 'Enter a password 6+ chars long'
                              : null,
                          obscureText: true,
                          onChanged: (val) {
                            setState(() => password = val);
                          }),
                      SizedBox(
                        height: 40.0,
                      ),
                      RaisedButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: 120, vertical: 15),
                          materialTapTargetSize:
                              MaterialTapTargetSize.values[0],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Colors.cyan[400],
                          child: Text(
                            'Submit',
                            style: GoogleFonts.aladin(
                                color: Colors.black, fontSize: 26),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);
                              dynamic result = await _auth
                                  .signInWithEmailAndPassword(email, password);
                              if (result == null) {
                                setState(() {
                                  loading = false;
                                  error =
                                      'Could not sign in with those credentials';
                                });
                              }
                            }
                          }),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(error, style: TextStyle(color: Colors.red)),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Don't have an account?",
                              style: TextStyle(color: Colors.black),
                            ),
                            FlatButton.icon(
                              icon: Icon(
                                Icons.input,
                                color: Colors.cyan,
                              ),
                              label: Text('Register',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.cyan,
                                  )),
                              onPressed: () {
                                widget.toggleView();
                              },
                            )
                          ])
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
