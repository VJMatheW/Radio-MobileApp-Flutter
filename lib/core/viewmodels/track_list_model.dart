import '../../core/enums_and_variables/info_state.dart';
import '../../core/models/tracks.dart';
import '../../core/services/apis.dart';
import '../../core/viewmodels/base_model.dart';

class TrackListModel extends BaseModel {
  List<Track> _onlineTracks = [];
  List<Track> _localTracks = [];
  List<Track> _onlineSuggestion = [];
  List<Track> _localSuggestion = [];
  int offset = 0;
  bool _isGetTracksLengthIsZero = false;

  List<Track> get getOnlineTracksList => _onlineTracks;
  List<Track> get getLocalTracksList => _localTracks;

  List<Track> get getOnlineTrackSuggestionList => _onlineSuggestion;
  List<Track> get getLocalTrackSuggestionList => _localSuggestion;

  bool get isOnlineSuggestionEmpty =>
      _onlineSuggestion.length > 0 ? false : true;
  bool get isLocalSuggestionEmpty => _localSuggestion.length > 0 ? false : true;

  bool get isGetTracksLenghtZero => _isGetTracksLengthIsZero;

  Future<void> getOnlineTracks() async {
    print("Get Online Tracks Triggered");
    List<Track> newTracks = await Api.getTracks(offset);
    _isGetTracksLengthIsZero = newTracks.length > 0 ? false : true;
    for (Track t in newTracks) {
      _onlineTracks.add(t);
    }
    offset = offset + newTracks.length;
    notifyListeners();
  }

  void clearOnlineSuggestion() {
    setState(ViewState.Busy);
    _onlineSuggestion = [];
    setState(ViewState.Idle);
  }

  void clearLocalSuggestion() {
    setState(ViewState.Busy);
    _localSuggestion = [];
    setState(ViewState.Idle);
  }

  Future<void> getOnlineTracksSuggestion(String text) async {
    print("Get Online suggestion triggered");
    setState(ViewState.Busy);
    _onlineSuggestion = await Api.getTrackSuggestion(text);
    setState(ViewState.Idle);
  }

  Future<void> getLocalTracksSuggestion(String text) async {
    print("Get Local suggestion triggered");
    setState(ViewState.Busy);
    _localSuggestion = await Api.getTrackSuggestion(text);
    // print("After Fetching Text : $text \n Suggestion : $_suggestion");
    setState(ViewState.Idle);
  }
}
