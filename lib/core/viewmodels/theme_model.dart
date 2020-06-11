import 'package:flutter/material.dart';
import 'package:radio_app/core/enums_and_variables/info_state.dart';
import 'package:radio_app/core/viewmodels/base_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModel extends BaseModel{  
  ThemeData themeData;  

  Future<ThemeData> getThemeData() async {
    setState(ViewState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getBool("darkTheme")){
      themeData = ThemeData.dark();
    }else{
      themeData = ThemeData.light();
    }
    setState(ViewState.Idle);
  }

  Future<void> setDarkTheme() async{
    setState(ViewState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("darkTheme", true);
    setState(ViewState.Idle);
  }

  Future<void> removeDarkTheme() async{
    setState(ViewState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("darkTheme", false);
    setState(ViewState.Idle);
  }
}