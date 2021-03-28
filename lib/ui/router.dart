import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'views/radio/dedicate_message_view.dart';
import '../ui/views/radio/dedicate_song_view.dart';
import 'views/music_player/player_view.dart';
import '../ui/views/radio/radio_view.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => RadioView());
      case "/player":
        return MaterialPageRoute(builder: (_) => PlayerView());
      case "/dedicate/song":
        return MaterialPageRoute(builder: (_) => DedicateSongView());
      case "/dedicate/message":
        return MaterialPageRoute(
            builder: (_) => DedicateMessageView(settings.arguments));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text("No router defined for ${settings.name}")),
                ));
    }
  }
}
