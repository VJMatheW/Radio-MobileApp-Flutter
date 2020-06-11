import 'package:flutter/cupertino.dart';
import 'package:radio_app/core/enums_and_variables/variables.dart';
import 'package:radio_app/core/models/message.dart';
import 'package:radio_app/core/models/tracksinfo.dart';
import 'package:radio_app/core/viewmodels/home_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

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
    if(socket.connected){
      print("Already Connected and registered events, Please disconnect and connect");
    }else{
      print("Creating new connection");
      socket.connect();
      registerEvents();
    }
  }

  void disconnect(){
    if(socket.disconnected){
      print("Already disconnected");      
    }else{
      if(socket.connected){
        print("Disconnecting: Executing ");
        socket.disconnect();
        socket = null;
        socket = IO.io(URL, <String, dynamic>{
          'transports': ['websocket'],
          'autoConnect': false,
          'extraHeaders': {'user_id': 'dart'} // optional
        });
      }else{
        print("No connection exists for the socket");
      }      
    }
  }

  void registerEvents(){
       
    socket.on('connect', (_) {
      print('connect');
    });    

    socket.on('connect_error', (_) {
      print('connect_error');    
    });

    socket.on('disconnect', (_){
      print('disconnect');
    });    

    socket.on("trackinfo", (data){
      print("Got Track Info");
      Map<String, dynamic> tracksInfo = data;
      // print(tracksInfo);
      model.getTracksInfo(tracksInfo: TracksInfoModel.fromJson(tracksInfo));      
    });

    socket.on("message", (data){   
      print("Got new Message");
      Map<String, dynamic> message = data;    
      print("Message Event $message");
      model.addMessage(message: Message.fromJson(message));      
    });
  }  
}