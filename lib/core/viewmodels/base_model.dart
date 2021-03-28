import 'package:flutter/cupertino.dart';

import '../enums_and_variables/info_state.dart';

class BaseModel extends ChangeNotifier{
  ViewState _state = ViewState.Idle;

  String _errorMessage;  

  ViewState get getState => _state;
  String get getErrorMessage => _errorMessage;

  setState(ViewState viewState){
    _state = viewState;
    notifyListeners();
  }

  setErrorMessage(String msg){
    _errorMessage = msg;
    notifyListeners();
  }
}