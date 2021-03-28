import 'package:get_it/get_it.dart';

import 'core/viewmodels/player_view_model.dart';
import 'core/viewmodels/track_list_model.dart';
import 'core/viewmodels/init_model.dart';
import 'core/viewmodels/home_model.dart';
import 'core/viewmodels/message_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  print("Setuping LOCATOR");
  locator.registerSingleton<InitModel>(InitModel());
  locator.registerLazySingleton<HomeModel>(() => HomeModel());
  locator.registerLazySingleton<MessageModel>(() => MessageModel());
  locator.registerLazySingleton<TrackListModel>(() => TrackListModel());
  locator.registerLazySingleton<PlayerViewModel>(() => PlayerViewModel());
}
