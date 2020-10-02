import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paap_punya/shared/constants.dart';

class DeedForm extends StatefulWidget {
  @override
  _DeedFormState createState() => _DeedFormState();
}

class _DeedFormState extends State<DeedForm> {
  final _formKey = GlobalKey<FormState>();

// form values
  String _currentDeedName;
  String _currentDeedDesc;
  bool _currentDeedType;
  int _currentDeedStrength;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Text(
            'Enter your deed',
            style: GoogleFonts.aladin(
              fontSize: 24.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            decoration: textInputDecoration.copyWith(labelText: 'Deed Name'),
            validator: (val) =>
                val.isEmpty ? 'Please enter the deed name' : null,
            onChanged: (val) => setState(() => _currentDeedName = val),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            decoration:
                textInputDecoration.copyWith(labelText: 'Deed Description'),
            validator: (val) =>
                val.isEmpty ? 'Please enter the deescriptioned name' : null,
            onChanged: (val) => setState(() => _currentDeedDesc = val),
          ),
          SizedBox(
            height: 20,
          ),
          
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            color: Colors.cyan[400],
            child: Text(
              'Add',
              style: GoogleFonts.aladin(
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            onPressed: () async {
              print(_currentDeedName);
              print(_currentDeedDesc);
              print(_currentDeedType);
              print(_currentDeedStrength);
            },
          )
        ],
      ),
    );
  }
}
