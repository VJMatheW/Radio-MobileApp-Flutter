class TracksInfoModel{
  TrackInfoModel lastTrackInfo;
  TrackInfoModel currentTrackInfo;
  TrackInfoModel nextTrackInfo;

  TracksInfoModel({this.lastTrackInfo, this.currentTrackInfo, this.nextTrackInfo});

  @override
  String toString(){
    return "last : ${lastTrackInfo.getTitle}\n"
          +"current: ${currentTrackInfo.getTitle}\n"
          +"next: ${nextTrackInfo.getTitle}\n";          
  }

  factory TracksInfoModel.init(){
    return TracksInfoModel(
      lastTrackInfo: TrackInfoModel(),
      currentTrackInfo: TrackInfoModel(),
      nextTrackInfo: TrackInfoModel(),
    );
  }

  factory TracksInfoModel.fromJson(Map<String, dynamic> _map){
    print(_map);
    print("---------next Track INfo : ${_map['nextTrackInfo']}");
    return TracksInfoModel(      
      lastTrackInfo: _map['lastTrackInfo'] != null ?  TrackInfoModel.fromJson(_map['lastTrackInfo']) : TrackInfoModel(),
      currentTrackInfo: _map['currentTrackInfo'] != null ? TrackInfoModel.fromJson(_map['currentTrackInfo']) : TrackInfoModel(),
      nextTrackInfo: _map['nextTrackInfo'] != null ? TrackInfoModel.fromJson(_map['nextTrackInfo']) : TrackInfoModel()
    );
  }
}

class TrackInfoModel {
    String _title;
    String _album;
    String _year;
    String _composer;
    String _artist;

    TrackInfoModel(){
      _title = "";
      _album = "";
      _year = "";
      _composer = "";
      _artist = "";
    }

    String get getTitle => _title;
    String get getAlbum => _album;
    String get getYear => _year;
    String get getComposer => _composer;
    String get getArtist => _artist;

    TrackInfoModel.fromJson(Map<String, dynamic> obj){
      print("TITLE : ${obj["title"]}");
      this._title = obj['title'] != null ? obj['title'] : "";
      this._album = obj['album'] != null ? obj['album'] : "";
      this._year = obj['year'] != null ? "(${obj['year']})" : "";
      this._composer = obj['composer'] != null ? obj['composer'] : "";
      this._artist = obj['artist'] != null ? obj['artist'] : "";
    }
}