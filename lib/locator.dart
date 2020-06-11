import 'package:get_it/get_it.dart';
import 'package:radio_app/core/viewmodels/dedicate_track_model.dart';
import 'package:radio_app/core/viewmodels/theme_model.dart';

import 'core/viewmodels/home_model.dart';
import 'core/viewmodels/message_model.dart';

GetIt locator = GetIt.instance;

void setupLocator(){
  print("Setuping LOCATOR");

  /** always keep home model first because Message Model Depends on it */  
  locator.registerLazySingleton<HomeModel>(() => HomeModel());
  locator.registerLazySingleton<MessageModel>(() => MessageModel());
  locator.registerLazySingleton<DedicateTrackModel>(() => DedicateTrackModel());
}

void disposeLocator(){
  if(locator.isRegistered<HomeModel>()){
    locator.unregister(instance: locator<HomeModel>());  
  }
  if(locator.isRegistered<MessageModel>()){
    locator.unregister(instance: locator<MessageModel>());
  }
  if(locator.isRegistered<DedicateTrackModel>()){
    locator.unregister(instance: locator<DedicateTrackModel>());
  }
  
}