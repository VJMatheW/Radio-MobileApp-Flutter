class Track{
  final int id;
  final String title;

  Track({this.id, this.title});

  @override
  String toString(){
    return "ID : $id Title : $title\n";
  }

  factory Track.fromJson(Map<String, dynamic> json){
    return Track(
      id: json["track_id"],
      title: json["track_title"]  
    );
  }
}