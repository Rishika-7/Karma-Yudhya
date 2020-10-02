import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:paap_punya/Screens/wrapper.dart';
import 'package:paap_punya/models/user.dart';
import 'package:paap_punya/services/auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(PaapPunya());
}

class PaapPunya extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: missing_required_param
    return StreamProvider<OurUser>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
    );
  }
}
