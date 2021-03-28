import 'package:flutter/material.dart';

import '../../../core/viewmodels/player_view_model.dart';
import '../../../core/models/player.dart';
import '../../../core/viewmodels/init_model.dart';
import '../../../locator.dart';
import '../../shared/track_search_list.dart';

class OnlinePlayer extends StatefulWidget {
  @override
  _OnlinePlayerState createState() => _OnlinePlayerState();
}

class _OnlinePlayerState extends State<OnlinePlayer> {
  @override
  void initState() {
    locator<PlayerViewModel>().setCachedTab(1);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO check internet and
    // if off show warning message
    // else fetch from local or online and populate list
    return TrackSearchList();
  }
}
