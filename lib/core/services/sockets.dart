import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../enums_and_variables/variables.dart';
import '../models/message.dart';
import '../models/tracksinfo.dart';
import '../viewmodels/home_model.dart';

class Socket{
  static const String URL = Vars.BASE_URL+Vars.SOCKET_QUERY;
  // static const String URL = "http://192.168.0.108:3000${Vars.SOCKET_QUERY}";

  IO.Socket socket;
  HomeModel model;  

  Socket({@required this.model}){
    socket = IO.io(URL, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'extraHeaders': {'user_id': 'dart'} // optional
    });    
  }

  @override
  String toString(){
    return "Socket connection ${socket.connected}\n"
          +"Model String ${model.toString()}";
  }

  
  void dispose(){    
    socket.close();
  }
  
  void connectAndRegisterEvents(){   
    print("Conecting socket connection");
    socket = socket.connect();
    registerEvents();
  }

  void disconnect(){
    socket = socket.disconnect();    
  }

  void registerEvents(){
       
    socket.on('connect', (_) {
      print('Socket Event : Connection');
    });    

    socket.on('connect_error', (_) {
      print('Socket Event : Connection Error');    
    });

    socket.on('disconnect', (_){
      print('Socket Event : Disconnection');
    });    

    socket.on("trackinfo", (data){
      print("Got Track Info from via Socket");
      Map<String, dynamic> tracksInfo = data;
      model.setTracksInfoFromSocket(tracksInfo: TracksInfoModel.fromJson(tracksInfo));      
    });

    socket.on("message", (data){   
      print("Got new Message");
      Map<String, dynamic> message = data;    
      print("Message Event $message");
      model.addMessage(message: Message.fromJson(message));      
    });
  }  
}