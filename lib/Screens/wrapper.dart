import 'package:flutter/material.dart';
import 'package:paap_punya/Screens/authenticate/authenticate.dart';
import 'package:paap_punya/Screens/home/startpage.dart';
import 'package:paap_punya/models/user.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<OurUser>(context);

    //return either home or authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return StartPage();
    }
  }
}
