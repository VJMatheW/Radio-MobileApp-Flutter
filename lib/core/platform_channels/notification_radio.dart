import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class NotificationChannel {
  static MethodChannel _methodChannel;
  static bool showingNotificationControls = false;

  MethodChannel get getMethodChannel => _methodChannel;

  /// Data to send initially when Notification Pops Up 
  static bool radioStatusCache;
  static Map<String, String> trackInfoCache;

  NotificationChannel({ @required String channelName, @required Function platformMethodHandler}){
    _methodChannel = MethodChannel(channelName);    
    _methodChannel.setMethodCallHandler(platformMethodHandler);
  }

  /// This is used to let android know the playing status of radio so that
  /// when the notification is showed, we can appropriately show play or pause
  void setRadioStatus(bool status) async {
    radioStatusCache = status;
    if(showingNotificationControls){
      invokeMethod(method: "setRadioStatus", boolean: status);
    }
  }

  /// This function is used to set the Track's Information in the Notification
  static void setTracksInfo(Map<String, String> trackInfo){
    trackInfoCache = trackInfo;
    if(showingNotificationControls){
      invokeMethod(method: "setTrackInfo", map: <String,Object>{"trackInfo": trackInfo });
    }
  }

  /// To remove radio notification when switched to Music Player App
  static void removeAllNotification() {
    if(showingNotificationControls){
      showingNotificationControls = false;
      invokeMethod(method: "removeRadioNotification");
    }
  }

  /// show radio notification control
  static void showRadioNotificationControls(){
    showingNotificationControls = true;
    invokeMethod(method: "setRadioStatus", boolean: radioStatusCache);
    invokeMethod(method: "showRadioNotificationControl", map: <String,Object>{"trackInfo": trackInfoCache });
    print("Showing the notification controls");
  }

  /// hide radio notification control
  static void hideRadioNotificationControls(){
    showingNotificationControls = false;
    invokeMethod(method: "hideRadioNotificationControl");
    print("Hiding the notification controls");
  }
  
  /// toggle radio notification
  static void toggleRadiNotificationControls(){    
    if(showingNotificationControls){
      hideRadioNotificationControls();
    }else{
      showRadioNotificationControls();
    }
  }

  /// This is the generalized send method call to talk to Platform
  static void invokeMethod({@required String method, Map<String,Object> map, String string, bool boolean}) async {
    try{
      
      if(map != null){
        await _methodChannel.invokeMethod(method, map);
      }else if(string != null){
        await _methodChannel.invokeMethod(method, string);
      }else if(boolean != null){
        await _methodChannel.invokeMethod(method, boolean); 
      }else{
        await _methodChannel.invokeMethod(method);
      }
      
    }on PlatformException catch (e){
      print("Platform Exception Occurred ('$method') : $e");
    } catch (e){
      print("Platform Exception Occurred ('$method') : $e");
    }
  }
}