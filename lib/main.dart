import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './ui/router.dart';
import './core/viewmodels/init_model.dart';
import 'locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  ThemeData theme;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<InitModel>.value(
      value: locator<InitModel>(),
      child: Consumer<InitModel>(
        builder: (context, model, child) {
          theme = model.getTheme;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Radio App',
            theme: theme,
            onGenerateRoute: Router.generateRoute,
            initialRoute: '/',
          );
        },
      ),
    );
  }
}

// TAB VIEW SAMPLE
//
// home: DefaultTabController(
//         length: 2,
//         child: Scaffold(
//           appBar: AppBar(
//             leading: Icon(Icons.camera_alt),
//             title: Text("GetNostalgic"),
//             actions: <Widget>[
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 15) ,
//                 child: Icon(Icons.share)
//               )
//             ],
//             bottom: TabBar(
//               tabs: <Widget>[
//                 Tab(child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Icon(Icons.radio),
//                     SizedBox(width: 10,),
//                     Text("Radio", style: TextStyle(fontSize: 20),)
//                   ]
//                   ),
//                 ),
//                 Tab(child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Icon(Icons.queue_music),
//                     SizedBox(width: 10,),
//                     Text("Music Player", style: TextStyle(fontSize: 20),)
//                   ]
//                   ),
//                 ),
//                 // Tab(icon: Icon(Icons.music_note),),
//               ]
//             ),
//           ),
//           body: TabBarView(
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: RadioView(),
//               ),
//               Text("Content Second Tab"),
//             ],
//           ),
//         ),
//       ),
