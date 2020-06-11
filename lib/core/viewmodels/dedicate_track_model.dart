import 'package:radio_app/core/enums_and_variables/info_state.dart';
import 'package:radio_app/core/models/tracks.dart';
import 'package:radio_app/core/services/apis.dart';
import 'package:radio_app/core/viewmodels/base_model.dart';

class DedicateTrackModel extends BaseModel{
  List<Track> _tracks = [];
  List<Track> _suggestion = [];
  int offset = 0;

  List<Track> get getTracksList => _tracks;
  List<Track> get getTrackSuggestionList => _suggestion;
  bool get isSuggestionEmpty => _suggestion.length > 0 ? false : true;

  Future<void> getTracks() async {
    print("Get Tracks Triggered");
    List<Track> newTracks = await Api.getTracks(offset);
    for(Track t in newTracks){
      _tracks.add(t);
    }
    offset = offset + newTracks.length;
    notifyListeners();
  }

  void clearSuggestion(){
    _suggestion = [];
    notifyListeners();
  }

  Future<void> getTracksSuggestion(String text) async {
    print("Get suggestion triggered");
    setState(ViewState.Busy);
    _suggestion = await Api.getTrackSuggestion(text);
    // print("After Fetching Text : $text \n Suggestion : $_suggestion");
    setState(ViewState.Idle);
  }
}