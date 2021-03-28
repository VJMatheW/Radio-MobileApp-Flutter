import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/viewmodels/player_view_model.dart';
import '../../../locator.dart';
import '../../../ui/views/music_player/local_player.dart';
import '../../../ui/views/music_player/online_player.dart';
import '../../../ui/views/music_player/player_controls.dart';
import '../../../ui/views/music_player/playlist.dart';
import '../base_view.dart';

class PlayerView extends StatefulWidget {
  @override
  _PlayerViewState createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
        length: 3,
        vsync: this,
        initialIndex: locator<PlayerViewModel>().getCachedTab);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
        title: "Music Player",
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<PlayerViewModel>.value(
                value: locator<PlayerViewModel>())
          ],
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              resizeToAvoidBottomPadding: false,
              body: Column(
                children: <Widget>[
                  TabBar(
                      labelColor: Theme.of(context).accentColor,
                      controller: _tabController,
                      tabs: [
                        Tab(
                          text: "Local",
                        ),
                        Tab(text: "Online"),
                        Tab(text: "Playlist")
                      ]),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        LocalPlayer(),
                        OnlinePlayer(),
                        Playlist(),
                      ],
                    ),
                  ),
                  PlayerControls()
                ],
              ),
            ),
          ),
        ));
  }
}
