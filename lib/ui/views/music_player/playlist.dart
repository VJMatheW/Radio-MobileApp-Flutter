import 'package:flutter/material.dart';

import '../../../core/viewmodels/player_view_model.dart';
import '../../../locator.dart';

class Playlist extends StatefulWidget {
  @override
  _PlaylistState createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  @override
  void initState() {
    locator<PlayerViewModel>().setCachedTab(2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO check internet and
    // if off show warning message
    // else fetch from local or online and populate list
    return Center(
      child: Text("Will be implemented soon"),
    );
  }
}
