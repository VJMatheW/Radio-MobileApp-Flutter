import 'package:flutter/material.dart';
import 'package:rasic_player/core/viewmodels/init_model.dart';
import 'package:rasic_player/locator.dart';
import 'core/platform_channels/notification_radio.dart';

class LifeCycleManager extends StatefulWidget {

  final Widget child;

  LifeCycleManager({Key key, this.child}) : super(key: key);

  @override
  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager> with WidgetsBindingObserver {


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {    
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    NotificationChannel.removeAllNotification();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {    
    super.didChangeAppLifecycleState(state);
    print("LifeCycleState : $state");
    if(state == AppLifecycleState.resumed){
      NotificationChannel.hideRadioNotificationControls();
    }

    if(state == AppLifecycleState.paused){
      NotificationChannel.showRadioNotificationControls();
    }

    // when user repeatedly clicked the back button
    if(state == AppLifecycleState.detached){
      // NotificationChannel.removeAllNotification();
      NotificationChannel.hideRadioNotificationControls();    
      locator<InitModel>().getAudioPlayer.stop();
    }
  }
}