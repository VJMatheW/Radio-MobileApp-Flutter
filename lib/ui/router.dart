import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:radio_app/ui/views/dedicate_message_view.dart';
import 'package:radio_app/ui/views/dedicate_song_view.dart';
import 'package:radio_app/ui/views/player_view.dart';
import 'package:radio_app/ui/views/radio_view.dart';

class Router{
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch (settings.name){
      case "/":
        return MaterialPageRoute(builder: (_)=> RadioView());
      case "/player":
        return MaterialPageRoute(builder: (_)=> PlayerView());
      case "/dedicate/song":
        return MaterialPageRoute(builder: (_)=> DedicateSongView());
      case "/dedicate/message":
        return MaterialPageRoute(builder: (_)=> DedicateMessageView(settings.arguments));
      default:
        return MaterialPageRoute(
          builder: (_)=> Scaffold(
            body: Center(
              child: Text("No router defined for ${settings.name}")
            ),
          ));
    }
  }
}