import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/platform_channels/notification_radio.dart';
import '../../../lifecyclemanager.dart';
import '../../../core/enums_and_variables/variables.dart';
import '../../../core/models/message.dart';
import '../../../core/viewmodels/init_model.dart';
import '../../../core/viewmodels/home_model.dart';
import '../../../locator.dart';
import 'radio_button.dart';
import '../../utils.dart';
import '../base_view.dart';

const String RADIO_URL = Vars.RADIO_URL;

class RadioView extends StatefulWidget {
  @override
  _RadioViewState createState() => _RadioViewState();
}

class _RadioViewState extends State<RadioView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    print("Disposing Audio Player from Radio View");
    NotificationChannel.removeAllNotification();
  }

  @override
  Widget build(BuildContext context) {
    return LifeCycleManager(
      child: BaseView(
        title: "GetNostalgic - Radio",

        /// TODO
        /// WillPopScope is workaround to capture the exit of app by pressing back button in ANDROID from the HomePage (Radio)
        /// Pressing back button releases the current FlutterViewController from FlutterEngine but FlutterEnginer still present
        child: WillPopScope(
          onWillPop: () async {
            print("WIll POP SCOPE CALLED");
            NotificationChannel.hideRadioNotificationControls();
            await locator<InitModel>().getAudioPlayer.stop();
            return Future.value(true);
          },
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider<HomeModel>.value(
                  value: locator<HomeModel>()), // (context) =>
            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                dedicateIcons(context),
                SizedBox(
                  height: 10,
                ),
                Expanded(flex: 1, child: dedicateMessage(context)),
                Expanded(flex: 3, child: RadioButton()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget dedicateIcons(BuildContext context) {
  return Row(
    children: <Widget>[
      Expanded(
        child: IconButton(
          icon: Icon(Icons.message, color: Theme.of(context).accentColor),
          iconSize: screenAwareSize(25.0, context),
          onPressed: () {
            print("Message button pressed ");
            Navigator.pushNamed(context, "/dedicate/message");
          },
        ),
        flex: 1,
      ),
      Expanded(flex: 3, child: Text("")),
      Expanded(
        flex: 1,
        child: IconButton(
          icon: Icon(Icons.search, color: Theme.of(context).accentColor),
          iconSize: screenAwareSize(25.0, context),
          onPressed: () {
            print("Search button pressed ");
            Navigator.pushNamed(context, "/dedicate/song");
          },
        ),
      ),
    ],
  );
}

Widget dedicateMessage(BuildContext context) {
  return Consumer<HomeModel>(
    builder: (BuildContext context, model, Widget child) {
      Message message = model.showing;
      if (message == null) {
        // return Card(
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: <Widget>[
        //         Text("Babe I love you \u2796", style: TextStyle(fontSize: screenAwareSize(12, context))),
        //         Text("Vijay", style: TextStyle(fontSize: screenAwareSize(12, context), fontWeight: FontWeight.bold, color: Colors.grey),),
        //       ]
        //     ),
        //   ),
        // );
        return Card(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.send, color: Theme.of(context).accentColor),
              iconSize: screenAwareSize(25.0, context),
              onPressed: () {
                print("Message button pressed ");
                Navigator.pushNamed(context, "/dedicate/message");
              },
            ),
            SizedBox(
              height: 10,
            ),
            Text("Send your Message",
                style: Theme.of(context)
                    .textTheme
                    .headline6) // TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
          ],
        ));
      } else {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("${message.getMessage}",
                      style: TextStyle(fontSize: screenAwareSize(12, context))),
                  SizedBox(
                    height: 5,
                  ),
                  Text("${message.getSender}",
                      style: TextStyle(
                          fontSize: screenAwareSize(12, context),
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                ]),
          ),
        );
      }
    },
  );
}
