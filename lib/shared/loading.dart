import 'package:flutter/material.dart';
//import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.cyan[50],
      child: Container(
        constraints: BoxConstraints.tightFor(width: 30, height: 30),
        child: Image(image: AssetImage("images/spincoin.gif"), fit: BoxFit.values[6],
        )
      )
    );
  }
}
