import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../../../core/platform_channels/notification_radio.dart';
import '../../../locator.dart';
import '../../utils.dart';
import '../../../core/enums_and_variables/variables.dart';
import '../../../core/models/tracksinfo.dart';
import '../../../core/viewmodels/home_model.dart';
import '../../../core/viewmodels/init_model.dart';

class RadioButton extends StatefulWidget {
  @override
  _RadioButtonState createState() => _RadioButtonState();
}

// PLAY / PAUSE BUTTON
class _RadioButtonState extends State<RadioButton> {
  AudioPlayer _player;
  bool initialPlayFlag = true;

  NotificationChannel notificationChannel;

  @override
  void initState() {
    super.initState();

    _player = locator<InitModel>().getAudioPlayer;
    _player.setUrl(Vars.RADIO_URL).catchError((error) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Could Not Connect to Server " + error),
      ));
    });

    notificationChannel = NotificationChannel(
        channelName: "getnostalgic.com/radio",
        platformMethodHandler: _didReceiveCall);
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopRadio();
  }

  Future<void> _didReceiveCall(MethodCall call) async {
    print("RECEIVED METHOD CALL from ANDROID : ${call.method}");
    switch (call.method) {
      case "playRadio":
        _playRadio();
        break;
      case "stopRadio":
        _stopRadio();
        break;
      default:
        print("Unimplemented Method Called");
    }
  }

  void _playRadio() async {
    // initialPlayFlag = true;
    await _player.setUrl(Vars.RADIO_URL).catchError((error) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Could Not Connect to Server " + error),
      ));
    });
    _player.play();
    locator<HomeModel>().setTracksInfoFromAPI();
    notificationChannel.setRadioStatus(true);
  }

  Future<void> _stopRadio() async {
    await _player.stop();
    notificationChannel.setRadioStatus(false);
    locator<HomeModel>().setInitialTracksInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeModel>(builder: (context, model, child) {
      TrackInfoModel currentTrackInfo = model.getCurrentTrackInfo;
      TrackInfoModel lastTrackInfo = model.getLastTrackInfo;
      TrackInfoModel nextTrackInfo = model.getNextTrackInfo;
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          /** Current Track Info */
          currentTrackInfoWidget(currentTrackInfo),

          /** Play Pause Button */
          radioInfo(model),

          /** Prvious and next track icon and text */
          previousAndNextTrackInfoWidget(lastTrackInfo, nextTrackInfo)
        ],
      );
    });
  }

  Widget radioInfo(HomeModel model) {
    final double iconSize = screenAwareSize(110, context);

    return Expanded(
      flex: 3,
      child: StreamBuilder<FullAudioPlaybackState>(
        stream: _player.fullPlaybackStateStream,
        builder: (context, snapshot) {
          final fullState = snapshot.data;
          final state = fullState?.state;
          final buffering = fullState?.buffering;

          // for autoplay
          if (state == AudioPlaybackState.stopped && initialPlayFlag) {
            initialPlayFlag = false;
            _playRadio();
          }

          // for loading
          if (state == AudioPlaybackState.connecting || buffering == true) {
            return LayoutBuilder(builder: (context, constraints) {
              return Container(
                child: Center(
                    child: CupertinoActivityIndicator(
                  radius: screenAwareSize(20, context),
                )),
              );
            });
          }

          // for playing state
          if (state == AudioPlaybackState.playing) {
            return GestureDetector(
              child: Icon(Icons.pause_circle_filled,
                  size: iconSize, color: Theme.of(context).accentColor),
              onTap: () {
                _stopRadio();
              },
            );
          } else {
            return GestureDetector(
              child: Icon(
                Icons.play_circle_filled,
                color: Theme.of(context).accentColor,
                size: iconSize,
              ),
              onTap: () async {
                _playRadio();
              },
            );
          }
        },
      ),
    );
  }

  Widget currentTrackInfoWidget(TrackInfoModel currentTrackInfo) {
    return Expanded(
      flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                "${currentTrackInfo.getTitle}",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontSize: screenAwareSize(18, context)),
              ),
              SizedBox(height: screenAwareSize(5.0, context)),
              Text("${currentTrackInfo.getAlbum} ${currentTrackInfo.getYear}",
                  style: Theme.of(context).textTheme.bodyText1),
              Text("${currentTrackInfo.getComposer}",
                  style: Theme.of(context).textTheme.bodyText1),
            ],
          )
        ],
      ),
    );
  }

  Widget previousAndNextTrackInfoWidget(
      TrackInfoModel lastTrackInfo, TrackInfoModel nextTrackInfo) {
    return Expanded(
        flex: 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Icon(Icons.skip_previous),
            ),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "${lastTrackInfo.getTitle}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${nextTrackInfo.getTitle}",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Icon(Icons.skip_next),
            ),
          ],
        ));
  }
}
