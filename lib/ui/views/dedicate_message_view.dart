import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_app/core/enums_and_variables/info_state.dart';
import 'package:radio_app/core/models/tracks.dart';
import 'package:radio_app/core/viewmodels/message_model.dart';
import 'package:radio_app/locator.dart';

import '../utils.dart';

class DedicateMessageView extends StatefulWidget { 

  Track track;
  
  DedicateMessageView(Object object){
    track = object;
  }

  @override
  _DedicateMessageViewState createState() => _DedicateMessageViewState();
}


class _DedicateMessageViewState extends State<DedicateMessageView> {

  TextEditingController messageController;
  TextEditingController senderController;
  Track track;

  bool valid = false;

  @override
  void initState() {
    super.initState();    
    messageController = TextEditingController();
    senderController = TextEditingController();
  }

  @override
  void dispose(){
    print("Message dispose called");
    messageController.dispose();
    senderController.dispose();
    super.dispose();
  }

  Widget trackInfoIfExists(){
    if(widget.track != null){
      track = widget.track;
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                "Track", 
                style: TextStyle(color: Colors.grey[600], fontSize: screenAwareSize(10, context), fontWeight: FontWeight.w700)
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Icon(Icons.music_note, color: Theme.of(context).accentColor),
              ),
            ],
          ),
          Row(          
            children: <Widget>[              
              Expanded(
                child: Text(
                  track.title, 
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.headline6),
              ),
            ],
          ),
        ],
    );
    }    
  }

  @override
  Widget build(BuildContext context) {    

    return ChangeNotifierProvider<MessageModel>.value(
      value: locator<MessageModel>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Message"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(          
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[              
                
                SizedBox(height: screenAwareSize(25, context)),

                Container(
                  child: trackInfoIfExists()                  
                ),

                SizedBox(height: screenAwareSize(25, context)),
                
                /** Heading  */
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Message \u2764", style: Theme.of(context).textTheme.headline4, ),
                    Icon(Icons.mail, size: 45, color: Theme.of(context).accentColor,)
                  ],
                ),
                
                SizedBox(height: 20,),
                
                /**   Message Paragraph     */
                TextField(
                  controller: messageController,  
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),          
                  autofocus: true,
                  maxLines: 7,
                  maxLength: 150,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(                
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        // topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0)
                        ),
                      ),
                    labelText: "Enter a Your Message${track == null ? " *" : ""}",                    
                  ),
                ),

                SizedBox(height: 20.0),
                
                /**   Input name   */
                TextField(
                  controller: senderController,
                  maxLength: 50,
                  maxLengthEnforced: true,
                  // textAlign: TextAlign.center,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),              
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        // bottomRight: Radius.circular(20.0)
                        ),
                      ),
                    labelText: "Enter a Your Name${track == null ? " *" : ""}"
                  ),
                ),
                
                SizedBox(height: 20.0),

                /**  Submit Button    */              
                Container(
                  child: Consumer<MessageModel>(
                    builder: (context, model, child) {
                      ViewState state = model.getState;
                      
                      if(state == ViewState.Busy){
                        return Center(
                          // child: CircularProgressIndicator(),
                          child: CupertinoActivityIndicator(),
                        );
                      }

                      if(state == ViewState.Idle){
                        return RaisedButton(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            // child: Icon(Icons.flight_takeoff),
                            child: Text("Send", style: Theme.of(context).primaryTextTheme.headline6)
                          ),
                          color: Theme.of(context).accentColor,   
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),                              
                          ),  
                          onPressed: () async {
                            if(track == null){ 
                              /** Dedicate Message Only */
                              if(messageController.text.isEmpty || senderController.text.isEmpty){
                                Scaffold.of(context).showSnackBar(SnackBar(content: Text("Fill all the fields")));
                                return;
                              }
                              
                              bool result = await model.postMessage(
                                message: messageController.text, 
                                sender: senderController.text
                              );

                              if(result){                              
                                print("Navigating to Radio Page");
                                Navigator.pop(context);
                              }else{
                                Scaffold.of(context).showSnackBar(SnackBar(content: Text("Unknown error occurred")));
                              }
                            }else{
                              /** Dedicate Message with TrackID 
                               * In this message can be null or both message and name should be filled
                               */                              
                              bool result = await model.postTrackAndMessage(
                                message: messageController.text, 
                                sender: senderController.text, 
                                trackId: track.id
                              );

                              if(result){                              
                                print("Navigating to Radio Page");
                                // Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);  
                                int count = 0;
                                Navigator.popUntil(context, (route){
                                  return count++ == 2;
                                });                              
                              }else{
                                Scaffold.of(context).showSnackBar(SnackBar(content: Text("Unknown error occurred")));
                              }
                            }
                          },
                        );
                      }

                      if(state == ViewState.Error){
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Some error occurred"),
                        ));
                      }
                    },
                  )
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
              ],
            ),
          ),
        )
      ),
    );
  }
}