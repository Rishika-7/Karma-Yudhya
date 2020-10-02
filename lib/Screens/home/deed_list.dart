import 'package:flutter/material.dart';
import 'package:paap_punya/Screens/home/deed_tile.dart';
import 'package:paap_punya/models/deed.dart';
import 'package:provider/provider.dart';

class DeedList extends StatefulWidget {
  @override
  _DeedListState createState() => _DeedListState();
}

class _DeedListState extends State<DeedList> {
  @override
  Widget build(BuildContext context) {
    final deeds = Provider.of<List<Deed>>(context);

    return ListView.builder(
      itemCount: deeds.length,
      itemBuilder: (context, index) {
        return DeedTile(deed: deeds[index]);
      },
    );
  }
}
