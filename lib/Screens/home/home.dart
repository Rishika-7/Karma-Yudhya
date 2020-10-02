import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paap_punya/Screens/home/deed_form.dart';
import 'package:paap_punya/services/auth.dart';
import 'package:paap_punya/services/database.dart';
import 'package:provider/provider.dart';
import 'package:paap_punya/Screens/home/deed_list.dart';
import 'package:paap_punya/models/deed.dart';

class Home extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Paap & Punya',
        theme: ThemeData(
          primarySwatch: Colors.cyan,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(title: 'Paap & Punya'));
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    void _showDeedForm() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: DeedForm(),
            );
          });
    }

    return StreamProvider<List<Deed>>.value(
        value: DatabaseService().deeds,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.title,
              style: GoogleFonts.aladin(
                fontSize: 32,
              ),
            ),
            actions: <Widget>[
              //IconButton(
              //icon: Icon(Icons.account_circle),
              //tooltip: 'My Profile',
              //onPressed: null,
              //),
              FlatButton.icon(
                icon: Icon(Icons.add_box),
                label: Text('Deed'),
                onPressed: () => _showDeedForm(),
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                    curve: Curves.decelerate,
                    padding: EdgeInsets.only(left: 20.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFF00838F),
                          Color(0xFF00ACC1),
                          Color(0xFF26C6DA),
                        ],
                      ),
                    ),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: Image(
                              image: AssetImage('images/lotus.png'),
                              height: 100,
                              width: 100,
                            ),
                          ),
                        ],
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Username',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                    ),
                                  ),
                                  Text(
                                    'email',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ])
                          ])
                    ])),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text('Home', style: TextStyle(fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.account_balance_wallet),
                      title: Text('My Wallet', style: TextStyle(fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.info),
                      title: Text('About Us', style: TextStyle(fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Divider(
                      color: Colors.black54,
                      height: 20,
                      thickness: 2,
                      indent: 10,
                      endIndent: 10,
                    ),
                    ListTile(
                      leading: Icon(Icons.input),
                      title: Text('Log Out', style: TextStyle(fontSize: 20)),
                      onTap: () async {
                        await _auth.signOut();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: DeedList(),
          //Center(
          //child: Column(
          //mainAxisSize: MainAxisSize.min,
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          //        crossAxisAlignment: CrossAxisAlignment.center,
          //      children: <Widget>[
          //      RaisedButton(
          //      onPressed: () {
          //Navigator.push(
          //context,
          //MaterialPageRoute(builder: (context) => LoginPage()),
          //);
          //    },
          //  textColor: Colors.black,
          //                  padding: const EdgeInsets.all(0.0),
          //                child: Container(
          //                decoration: const BoxDecoration(
          //                gradient: LinearGradient(
          //                colors: <Color>[
          //                Color(0xFF00838F),
          //              Color(0xFF00ACC1),
          //            Color(0xFF26C6DA),
          //        ],
          //    ),
          //),
          //                   padding: const EdgeInsets.all(10.0),
          //                 child: const Text("Begin",
          //                 style: TextStyle(
          //                     fontSize: 30,
          //                )),
          //            ),
          //           ),
          //        ],
          //       ),
          //     ),
          //bottomNavigationBar: BottomAppBar(
          //shape: const CircularNotchedRectangle(),
          //child: Container(
          // height: 50.0,
          //),
          //),
          //floatingActionButton: FloatingActionButton(
          //onPressed: () => _showDeedForm,
          //tooltip: 'Add Deed',
          //child: Icon(Icons.add),
          //),
        ));
  }
}
