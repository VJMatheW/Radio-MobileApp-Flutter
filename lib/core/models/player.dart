// import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rasic_player/core/viewmodels/player_view_model.dart';
import 'package:rasic_player/locator.dart';
import '../enums_and_variables/info_state.dart';

class MediaPlayer {
  setSource({String url, String file}) {}
  play() {}
  pause() {}
  seek(Duration position) {}
  setShuffle() {}
  setRepeat(RepeatState state) {}
  next() {}
  previous() {}
}

class MusicPlayer implements MediaPlayer {
  AudioPlayer player;
  bool shuffle;
  RepeatState repeat;

  bool get getShuffle => shuffle;
  RepeatState get getRepeatState => repeat;

  /** Streams  */
  Stream<Duration> get getDurationStream => player.durationStream;
  Stream get getPositionStream => player.getPositionStream();
  Stream get getPlayBackStream => player.fullPlaybackStateStream;

  MusicPlayer({@required this.player, this.repeat, this.shuffle});

  @override
  void setRepeat(RepeatState state) {
    // TODO: implement onRepeat
  }

  @override
  void seek(Duration position) {
    player.seek(position);
  }

  @override
  void setShuffle() {
    // TODO: implement onShuffle
  }

  @override
  void pause() {
    player.pause();
  }

  @override
  void play() {
    player.play();
  }

  @override
  Future<void> setSource({String url, String file}) async {
    // TODO: implement setSource
    try {
      await player.setUrl(url);
      return;
    } catch (e) {
      print("Error Occurred Setting Source : $e");
    }
  }

  @override
  void next() {
    // locator<PlayerViewModel>().
  }

  @override
  void previous() {
    // TODO: implement previous
  }
}
