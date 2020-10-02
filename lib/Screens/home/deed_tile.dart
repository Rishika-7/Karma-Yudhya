import 'package:flutter/material.dart';
import 'package:paap_punya/models/deed.dart';

class DeedTile extends StatelessWidget {
  final Deed deed;
  DeedTile({this.deed});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: ListTile(
            leading: CircleAvatar(
                radius: 25.0,
                backgroundColor: deed.deedType
                    ? Colors.green[deed.deedStrength]
                    : Colors.red[deed.deedStrength]),
            title: Text(deed.deedName),
            subtitle: Text('${deed.deedStrength}'),
          ),
        ));
  }
}
