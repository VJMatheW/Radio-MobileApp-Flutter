import 'package:radio_app/core/enums_and_variables/info_state.dart';
import 'package:radio_app/core/models/message.dart';
import 'package:radio_app/core/services/apis.dart';
import 'package:radio_app/core/viewmodels/base_model.dart';

class MessageModel extends BaseModel{  

  Future<bool> postMessage({String message, String sender}) async{
    setState(ViewState.Busy);
    Message msg = Message(message: message, sender: sender);
    String body = msg.toJsonString(dedicateTrack: false);
    int code = await Api.postMessage(body);
    
    if(code != 200){
      setErrorMessage("Unknown Error Occurred");      
      setState(ViewState.Error);
      Future.delayed(Duration(seconds: 1));
      setState(ViewState.Idle);
      return false;           
    }
    setState(ViewState.Idle);
    return true;
  }

  Future<bool> postTrackAndMessage({String message, String sender, int trackId}) async {
    setState(ViewState.Busy);
    Message temp;
    
    if(message != null && message.length > 0){
      temp  = Message(message: message, sender: sender, trackId: trackId);
    }else{
      temp = Message(trackId: trackId);
    }
    String body = temp.toJsonString(dedicateTrack: true);
    int code = await Api.postTrackMessage(body);

    if(code != 200){
      setErrorMessage("Unknown Error Occurred");      
      setState(ViewState.Error);
      Future.delayed(Duration(seconds: 1));
      setState(ViewState.Idle);
      return false;  
    }
    setState(ViewState.Idle);
    return true;

  } 
}