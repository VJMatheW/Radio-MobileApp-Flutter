import 'package:rasic_player/ui/views/music_player/playlist.dart';

import '../../core/models/tracks.dart';
import '../enums_and_variables/info_state.dart';
import 'base_model.dart';

class PlayerViewModel extends BaseModel {
  bool _showPlayerControls = true;
  int _cachedTab;
  Track _currentTrack;
  bool _playingFromPlaylist = false;
  Playlist _currentPlaylist;

  bool get getShowPlayerControls => _showPlayerControls;
  int get getCachedTab => _cachedTab ?? 2;
  Track get getCurrentTrack => _currentTrack ?? Track(id: -1, title: "");
  bool get isPlayingFromPlaylist => _playingFromPlaylist;
  Playlist get getCurrentPlaylist => _currentPlaylist;

  void setCachedTab(int val) {
    _cachedTab = val;
  }

  void setCurrentPlaylist(Playlist playlist) {
    _currentPlaylist = playlist;
  }

  void setCurrentTrack(Track track) {
    setState(ViewState.Busy);
    _currentTrack = track;
    setState(ViewState.Idle);
  }

  void showPlayerControls() {
    setState(ViewState.Busy);
    _showPlayerControls = true;
    setState(ViewState.Idle);
  }

  void hidePlayerControls() {
    setState(ViewState.Busy);
    _showPlayerControls = false;
    setState(ViewState.Idle);
  }
}
