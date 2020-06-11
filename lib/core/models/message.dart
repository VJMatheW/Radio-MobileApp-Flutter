// import 'package:flutter/cupertino.dart';

import 'dart:convert';

import 'package:flutter/cupertino.dart';

class Message {
  String message;
  String sender;
  int displayTime;
  bool isDedicated;
  int trackId;  

  Message({this.message, this.sender, this.displayTime, this.isDedicated, this.trackId});

  String get getMessage => message;
  String get getSender => sender;
  int get getTrackId => trackId;

  @override
  String toString(){
    return "Message : $message \t Sender: $sender \t DisplayTime: $displayTime \t IsDedicated: $isDedicated";
  }

  factory Message.fromJson(Map<String, dynamic> jsonObj){
    return Message(
      message: jsonObj["content"],
      sender: jsonObj["name"],
      displayTime: jsonObj["displayTime"],
      isDedicated: jsonObj["isDedicated"]
    );
  }

  String toJsonString({@required bool dedicateTrack}){
    Map<String, String> body;
    if(dedicateTrack){
      /** Message with track dedication */
      body = {
        "track_id": trackId.toString()
      };

      if(this.message != null){
        Map<String, String>  message = {
          "content": this.message,
          "name": this.sender,      
        };
        
        body["message"] = jsonEncode(message);     
      }
    }else{
      /** Message without track dedication */
      body = {
        "content": this.message,
        "name": this.sender,      
      };
    }
    print("Map : $body");        
    return jsonEncode(body);
  }
}