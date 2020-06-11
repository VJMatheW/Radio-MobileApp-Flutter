import 'package:flutter/material.dart';

class BaseView extends StatelessWidget {

  final Widget child;
  final String title;

  BaseView({@required this.child, this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(title: Text(title),),
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                DrawerHeader(                  
                  child: Text("Get\nNostalgic", style: Theme.of(context).accentTextTheme.headline3),
                  decoration: BoxDecoration(color: Theme.of(context).accentColor)
                ),
                ListTile(              
                  leading: Icon(Icons.radio, size: 30.0, color: Theme.of(context).accentColor,),  
                  title: Text("Radio", style: Theme.of(context).textTheme.headline5,),
                  onTap: (){
                    print("Navigate to Radio");
                    Navigator.pushReplacementNamed(context, "/");
                  },
                ),
                ListTile(
                  leading: Icon(Icons.queue_music, size: 30.0, color: Theme.of(context).accentColor,),
                  title: Text("Music Player", style: Theme.of(context).textTheme.headline5,),
                  onTap: (){
                    print("Navigate to Music Player");
                    Navigator.pushReplacementNamed(context, "/player");                   
                  },
                ),
              ]
            ),
          ),
          body: Padding (
            padding: EdgeInsets.all(5.0),
            child: child
          ),
        ),
      );
  }
}