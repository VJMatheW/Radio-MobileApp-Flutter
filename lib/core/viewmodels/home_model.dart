import 'dart:async';

import 'package:radio_app/core/models/message.dart';
import 'package:radio_app/core/models/tracksinfo.dart';
import 'package:radio_app/core/services/apis.dart';
import 'package:radio_app/core/services/sockets.dart';
import 'package:radio_app/core/viewmodels/base_model.dart';

class HomeModel extends BaseModel{
  
  Socket socket;
  TracksInfoModel _tracksInfoModel;  
  bool _viewSocketInfo = false;

  String _errorMessage;
  
  Message showing;
  List<Message> _messages = [];  
  Timer timer;  

  HomeModel(){
    print("Home MODEL Constructor executed");
    _tracksInfoModel = TracksInfoModel.init();
    _viewSocketInfo = true;    
    notifyListeners();
  }

  // GETTERS 
  String get getErrorMessage => _errorMessage;
  TrackInfoModel get getCurrentTrackInfo => _tracksInfoModel.currentTrackInfo;
  TrackInfoModel get getLastTrackInfo => _tracksInfoModel.lastTrackInfo;
  TrackInfoModel get getNextTrackInfo => _tracksInfoModel.nextTrackInfo;

  @override
  String toString(){
    // return ("Home Model TO String Called");
    return "last : ${_tracksInfoModel.lastTrackInfo.getTitle}\n"
          +"current: ${_tracksInfoModel.currentTrackInfo.getTitle}\n"
          +"next: ${_tracksInfoModel.nextTrackInfo.getTitle}\n"
          +"viewSocketInfo: $_viewSocketInfo";
  }

  @override
  void dispose(){
    print("------------############### DISPOSE CALLED ------------------");
    socket.dispose();
    socket = null;
    super.dispose();
  }

  void setSocket(){
    print("Setting Socket");
    socket = Socket(model: this);
    print("Socket TO STRING : "+socket.toString());
  }

  void getInitialTracksInfo() {
    _tracksInfoModel = TracksInfoModel.init();
    // print(_tracksInfoModel);
    _viewSocketInfo = false; 
    // print("getInitialTracksInfo -- --- $_viewSocketInfo");
    notifyListeners();

    // Unsubscribe from the socket event
    socket.disconnect();
  }

  void getTracksInfo({TracksInfoModel tracksInfo}) async {    
    if(tracksInfo == null){      
      TracksInfoModel temp = await Api.fetchTrackInfo();
      if(temp != null){
        _tracksInfoModel = temp;
        // print("Setting tracks from API --- ${_tracksInfoModel.toString()} ");
      }else{
        print("API returned Null");
      }
    }else{      
      // print("Before Setting tracks from Socket ---- ${_tracksInfoModel.toString()}");
      _tracksInfoModel = tracksInfo;
      print("Setting tracks from Socket ---- ${_tracksInfoModel.toString()}");
    }
    
    _viewSocketInfo = true;    
    // print("getTracksInfo -- --- $_viewSocketInfo");    
    notifyListeners();

    // Subscribe to socket events
    socket.connectAndRegisterEvents();
  }

  void setTracksInfo(TracksInfoModel tracksInfoModel){    
    _tracksInfoModel = tracksInfoModel; 
    if(_viewSocketInfo){ // which means update the Listeners
      print("Notifying listeners for the model from the socket");
      notifyListeners();
    }
  }  

  void addMessage({Message message}){
    _messages.add(message);
    nextMessage();
  }

  // For messages 
  Message shift(){
    if(_messages.length >= 1){
      Message cur = _messages.elementAt(0);
      _messages = _messages.sublist(1, _messages.length);      
      return cur;
    }
    return null;
  }

  void nextMessage(){
    // this check because we dont want to interupt the exisitng message queue
    if(timer == null || !timer.isActive){
      Message toShow = shift();
      if(toShow == null){
        showing = null;
        print("No message to show");                
      }else{
        print("showing message in UI -- ${toShow.toString()}");
        showing = toShow;
        timer = startTimeout(toShow.displayTime);
      }      
      notifyListeners();
    }
  }

  Timer startTimeout(int millis) {
    Duration duration = Duration(milliseconds: millis);
    return Timer(duration, nextMessage);
  }

}