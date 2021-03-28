import 'package:rasic_player/core/enums_and_variables/variables.dart';
import 'package:rasic_player/core/models/player.dart';
import 'package:rasic_player/core/viewmodels/init_model.dart';
import 'package:rasic_player/core/viewmodels/player_view_model.dart';
import 'package:rasic_player/locator.dart';

class Track {
  final int id;
  final String title;
  final bool onlineTrack;

  MusicPlayer _player = locator<InitModel>().getMusicPlayer;

  Track({this.id, this.title, this.onlineTrack});

  bool get isOnlineTrack => onlineTrack;

  @override
  String toString() {
    return "ID : $id Title : $title\n";
  }

  factory Track.fromJson({Map<String, dynamic> json, bool isOnline}) {
    return Track(
        id: json["track_id"],
        title: json["track_title"],
        onlineTrack: isOnline);
  }

  void play() async {
    if (id > 0) {
      await _player.setSource(
          url: Vars.BASE_URL + Vars.BASE_API + "/track/$id");
      _player.play();
      locator<PlayerViewModel>().setCurrentTrack(this);
    }
  }
}
