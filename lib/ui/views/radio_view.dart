import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:radio_app/core/enums_and_variables/variables.dart';
import 'package:radio_app/core/models/message.dart';
import 'package:radio_app/core/models/tracksinfo.dart';
import 'package:radio_app/core/viewmodels/home_model.dart';
import 'package:radio_app/locator.dart';

import '../utils.dart';
import 'base_view.dart';

const String RADIO_URL = Vars.RADIO_URL;

class RadioView extends StatefulWidget {

  @override
  _RadioViewState createState() => _RadioViewState();
}

class _RadioViewState extends State<RadioView> {

  @override
  void initState() {  
    print("Radio View Init override"); 
    setupLocator();
    print(locator<HomeModel>().toString());
    locator<HomeModel>().setSocket();  
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: "GetNostalgic - Radio",
      child: MultiProvider(
        providers:[
          ChangeNotifierProvider<HomeModel>(create: (context) => locator<HomeModel>()), // (context) => 
        ] ,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 10,), 
            dedicateIcons(context),
            SizedBox(height: 10,), 
            Expanded(flex: 1,  child: dedicateMessage(context)),
            Expanded(flex: 3, child: RadioButton()),            
          ],
        ),
      ),
    );
  }
}

class RadioButton extends StatefulWidget {
  @override
  _RadioButtonState createState() => _RadioButtonState();
}

/// PLAY / PAUSE BUTTON 
class _RadioButtonState extends State<RadioButton> {
  AudioPlayer _player;
  bool initialPlayFlag = true;
  HomeModel homeModel;

  @override
  void initState() {
    super.initState();    
    // setupLocator();
    print("Running init RADIOBUTTON");
    _player = AudioPlayer();
    initRadio();
    
  }

    @override
  void deactivate() {
    print("Running deactivate RADIOBUTTON");
    _player.dispose(); 
    super.deactivate();
  }

  @override
  void dispose() {
    print("RADIO BUTTON Dispose called");
    _player.dispose();
    disposeLocator();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeModel>(
      builder: (context, model, child){
        // print("Model from UI :\n ${model.toString()}");
        homeModel = model;
        TrackInfoModel currentTrackInfo = model.getCurrentTrackInfo;
        TrackInfoModel lastTrackInfo = model.getLastTrackInfo;
        TrackInfoModel nextTrackInfo = model.getNextTrackInfo;
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              flex: 1,
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[                
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text("${currentTrackInfo.getTitle}", style: Theme.of(context).textTheme.headline6,),
                      SizedBox(height: screenAwareSize(5.0, context)),
                      Text("${currentTrackInfo.getAlbum} ${currentTrackInfo.getYear}", style: Theme.of(context).textTheme.bodyText1),
                      Text("${currentTrackInfo.getComposer}", style: Theme.of(context).textTheme.bodyText1),
                    ],
                  )
                ],
              ),
            ),
            
            /** Play Pause Button */
            Expanded(
              flex: 3, 
              child: radioInfo()
            ),
            
            /** Prvious and next track icon and text */
            Expanded(
              flex: 1, 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(flex: 1,child: Icon(Icons.skip_previous),),
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
                  Expanded(flex: 1, child: Icon(Icons.skip_next),),
                ],
              )
            )
          ],
        );
      }
    );
  }

  Future<void> initRadio() async {
    print("Running init radio");
    
    await _player.setUrl(RADIO_URL).catchError((error) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(error),
      ));
    });
    if(homeModel != null){
      homeModel.getTracksInfo();
    }else{
      print("Init Radio : homemodel NUll ");
    }    
  }

  Widget radioInfo() {
    final double iconSize = screenAwareSize(110, context);

    return StreamBuilder<FullAudioPlaybackState>(
      stream: _player.fullPlaybackStateStream,
      builder: (context, snapshot) {
        final fullState = snapshot.data;
        final state = fullState?.state;
        final buffering = fullState?.buffering;

        // for autoplay
        if (state == AudioPlaybackState.stopped && initialPlayFlag) {
          initialPlayFlag = false;
          _player.play();
        }

        // for loading
        if (state == AudioPlaybackState.connecting || buffering == true) {
          return LayoutBuilder(builder: (context, constraints) {
            return Container(              
              child: Center(
                // child: CircularProgressIndicator(
                //   strokeWidth: 7.0,
                // ),
                child: CupertinoActivityIndicator(
                  radius: screenAwareSize(20, context),                  
                )
              ),
            );
          });
        }

        if (state == AudioPlaybackState.playing) {          
          return GestureDetector(
            child: Icon(
              Icons.pause_circle_filled,
              size: iconSize,
              color: Theme.of(context).accentColor
            ),
            onTap: () {
              _player.stop();
            //  _player.dispose();
              print("Stop Button Pressed");
              homeModel.getInitialTracksInfo();              
            },
          );
        } else {
          // setting TRACKSINFO to empty        
          return GestureDetector(
            child: Icon(
              Icons.play_circle_filled,
              color: Theme.of(context).accentColor,
              size: iconSize,
            ),
            onTap: () async {
              initialPlayFlag = true;              
              await initRadio();
              _player.play();
              homeModel.getTracksInfo();
              print("Play Button Pressed");
            },
          );
        }
      },
    );
  }  
}

Widget dedicateIcons(BuildContext context){
  return Row(
    children: <Widget>[
      Expanded(
        child: IconButton(
          icon: Icon(Icons.message, color: Theme.of(context).accentColor),        
          iconSize: screenAwareSize(20.0, context),
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
          iconSize: screenAwareSize(20.0, context),
          onPressed: () {
            print("Search button pressed ");
            Navigator.pushNamed(context, "/dedicate/song");
          },
        ),
      ),

    ],
  );
}

Widget dedicateMessage(BuildContext context){
  return Consumer<HomeModel>(
      builder: (BuildContext context, model, Widget child) { 
        Message message = model.showing;
        if(message == null){
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
                  icon: Icon(Icons.send, size: 40, color: Theme.of(context).accentColor),                          
                  iconSize: screenAwareSize(25.0, context),
                  onPressed: () {
                    print("Message button pressed ");
                    Navigator.pushNamed(context, "/dedicate/message");
                  },
                ),
                SizedBox(height: 10,),
              Text("Send your Message", style: Theme.of(context).textTheme.headline6 ) // TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
            ],)
          );
        }else{
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("${message.getMessage}", style: TextStyle(fontSize: screenAwareSize(12, context))),
                  SizedBox(height: 5,),
                  Text("${message.getSender}", style: TextStyle(fontSize: screenAwareSize(12, context), fontWeight: FontWeight.bold, color: Colors.grey)),
                ]
              ),
            ),
          );
        }        
      },      
  );
}
