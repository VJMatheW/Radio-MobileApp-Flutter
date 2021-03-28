import 'dart:convert';

import 'package:http/http.dart' as http;

import '../enums_and_variables/variables.dart';
import '../models/tracksinfo.dart';
import '../models/tracks.dart';

const URL = Vars.BASE_URL + Vars.BASE_API;
const HEADER = {"Content-Type": "application/json"};

class Api {
  static Future<TracksInfoModel> fetchTrackInfo() async {
    final response = await http.get("$URL/track/current");
    if (response.statusCode != 200) {
      int code = response.statusCode;
      print("RESOPONSE CODE : $code");
      return null;
      // throw Exception("Unknown Error : $code");
    }
    // print("--------------CODE 200 --- ${response.body}");
    return TracksInfoModel.fromJson(jsonDecode(response.body));
  }

  static Future<int> postMessage(String jsonMessageString) async {
    http.Response response;
    try {
      response = await http.post("$URL/dedicate/message",
          body: jsonMessageString, headers: HEADER);
      return response.statusCode;
    } catch (e) {
      print("Error Posting Message : $e");
      return 500;
    }
  }

  static Future<int> postTrackMessage(String jsonTrackMessageString) async {
    try {
      http.Response response = await http.post("$URL/dedicate/track",
          body: jsonTrackMessageString, headers: HEADER);
      return response.statusCode;
    } catch (e) {
      print("Error Posting Track Message : $e");
      return 500;
    }
  }

  static Future<List<Track>> getTracks(int offset) async {
    List<Track> tracks = [];
    try {
      offset = offset ?? 0;
      print("Offset : $offset");
      print("API CALL with Offset $offset");
      final response = await http.get("$URL/track/list?offset=$offset");
      if (response.statusCode != 200) {
        print("RESPONSE CODE : ${response.statusCode}");
        return tracks;
      }
      // print("Response : ${response.body}");
      Map<String, dynamic> json = jsonDecode(response.body);
      var trackArray = json["tracks"] as List;
      tracks = trackArray
          .map((track) => Track.fromJson(json: track, isOnline: true))
          .toList();
      // print("TRACKS after deserialized : $tracks");
      return tracks;
    } catch (e) {
      print("Exception $e");
      return tracks;
    }
  }

  static Future<List<Track>> getTrackSuggestion(String text) async {
    List<Track> tracks = [];
    try {
      final response = await http.get("$URL/track/search?query=$text");
      if (response.statusCode != 200) {
        print("RESPONSE CODE : ${response.statusCode}");
        return tracks;
      }
      Future.delayed(Duration(seconds: 3));
      Map<String, dynamic> json = jsonDecode(response.body);
      var trackArray = json["tracks"] as List;
      tracks = trackArray
          .map((track) => Track.fromJson(json: track, isOnline: true))
          .toList();
      return tracks;
    } catch (e) {
      print("Exception : $e");
      return tracks;
    }
  }
}
