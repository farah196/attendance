


import 'package:attendance/core/viewstate.dart';
import 'package:flutter/material.dart';


class BaseModel with ChangeNotifier {
  ViewState _state = ViewState.idle;
  ViewState get state => _state;
  bool systemError = false;
  bool reload = false;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }
  void reloadPage() {
    reload= true;
    notifyListeners();
  }


}