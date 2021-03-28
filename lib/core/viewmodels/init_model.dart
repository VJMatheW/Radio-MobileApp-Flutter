import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rasic_player/core/models/player.dart';
import '../../core/enums_and_variables/info_state.dart';
import '../../core/viewmodels/base_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitModel extends BaseModel {
  ThemeData _themeData;
  bool _isDark = true;
  AudioPlayer _player;
  MusicPlayer musicPlayer;

  InitModel() {
    _player = AudioPlayer();
    musicPlayer = MusicPlayer(player: _player);
    getThemeDataPreference();
  }

  // GETTERS
  ThemeData get getTheme => _themeData;
  bool get isDark => _isDark;
  AudioPlayer get getAudioPlayer => _player;
  MusicPlayer get getMusicPlayer => musicPlayer;

  /// Get Theme
  void getThemeDataPreference() async {
    setState(ViewState.Busy);
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    if (_preferences.getBool("darkTheme") != null &&
        _preferences.getBool("darkTheme")) {
      _themeData = ThemeData.dark();
      _isDark = true;
    } else {
      _themeData = ThemeData.light();
      _isDark = false;
    }
    setState(ViewState.Idle);
  }

  /// Set Dark Theme
  Future<void> setDarkTheme() async {
    print("Setting dark theme");
    setState(ViewState.Busy);
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setBool("darkTheme", true);
    _themeData = ThemeData.dark();
    _isDark = true;
    setState(ViewState.Idle);
  }

  /// Remove Dark Theme
  Future<void> removeDarkTheme() async {
    setState(ViewState.Busy);
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setBool("darkTheme", false);
    _themeData = ThemeData.light();
    _isDark = false;
    setState(ViewState.Idle);
  }
}
