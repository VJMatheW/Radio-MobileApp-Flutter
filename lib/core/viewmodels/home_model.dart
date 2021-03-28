import 'dart:async';

import '../../core/enums_and_variables/info_state.dart';
import '../../core/models/message.dart';
import '../../core/models/tracksinfo.dart';
import '../../core/platform_channels/notification_radio.dart';
import '../../core/services/apis.dart';
import '../../core/services/sockets.dart';
import '../../core/viewmodels/base_model.dart';

class HomeModel extends BaseModel{
  
  Socket socket;
  TracksInfoModel _tracksInfoModel;  
  bool _viewSocketInfo = false;
  
  Message showing;
  List<Message> _messages = [];  
  Timer timer;  

  HomeModel(){
    print("Home MODEL Constructor executed");
    _tracksInfoModel = TracksInfoModel.init();
    socket = Socket(model: this);    
  }

  // GETTERS 
  TrackInfoModel get getCurrentTrackInfo => _tracksInfoModel.currentTrackInfo;
  TrackInfoModel get getLastTrackInfo => _tracksInfoModel.lastTrackInfo;
  TrackInfoModel get getNextTrackInfo => _tracksInfoModel.nextTrackInfo;


  @override
  String toString(){
    return "last : ${_tracksInfoModel.lastTrackInfo.getTitle}\n"
          +"current: ${_tracksInfoModel.currentTrackInfo.getTitle}\n"
          +"next: ${_tracksInfoModel.nextTrackInfo.getTitle}\n"
          +"viewSocketInfo: $_viewSocketInfo";
  }

  @override
  void dispose(){
    print("------------############### HomeModel DISPOSE CALLED ------------------");
    socket.dispose();
    socket = null;
    super.dispose();
  }

  void setSocket(){
    socket = Socket(model: this);
  }

  /// For setting trackInfo empty
  void setInitialTracksInfo() {    
    setTracksInfo(tracksInfo: TracksInfoModel.init());
    _viewSocketInfo = false;
    socket.disconnect();
  }

  /// to get tracks info from API
  void setTracksInfoFromAPI() async { 
    TracksInfoModel temp = await Api.fetchTrackInfo();
    if(temp != null){
      setTracksInfo(tracksInfo: temp);
      _viewSocketInfo = true;
      socket.connectAndRegisterEvents();
    }
  }

  /// Set TracksInfo from Socket
  void setTracksInfoFromSocket({ TracksInfoModel tracksInfo }) async {
    setTracksInfo(tracksInfo: tracksInfo);
  }

  void setTracksInfo({TracksInfoModel tracksInfo}){    
    setState(ViewState.Busy);
    _tracksInfoModel = tracksInfo; 
    NotificationChannel.setTracksInfo(_tracksInfoModel.currentTrackInfo.asMap());
    setState(ViewState.Idle);
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
      setState(ViewState.Busy);
      Message toShow = shift();
      if(toShow == null){
        showing = null;
        print("No message to show");                
      }else{
        print("showing message in UI -- ${toShow.toString()}");
        showing = toShow;
        timer = startTimeout(toShow.displayTime);
      }
      setState(ViewState.Idle);
    }
  }

  Timer startTimeout(int millis) {
    Duration duration = Duration(milliseconds: millis);
    return Timer(duration, nextMessage);
  }

}