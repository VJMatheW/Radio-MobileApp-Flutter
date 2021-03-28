import 'package:flutter/material.dart';
import 'package:rasic_player/core/viewmodels/player_view_model.dart';

import '../../../locator.dart';

class LocalPlayer extends StatefulWidget {
  @override
  _LocalPlayerState createState() => _LocalPlayerState();
}

class _LocalPlayerState extends State<LocalPlayer>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    locator<PlayerViewModel>().setCachedTab(0);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Will be implemented Soon"),
    );
  }
}
