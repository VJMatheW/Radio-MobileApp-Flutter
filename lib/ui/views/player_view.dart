import 'package:flutter/material.dart';

import 'base_view.dart';

class PlayerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: "Music Player",
      child: Center(
        child: Text("Player view"),
      ),
    );
  }
}