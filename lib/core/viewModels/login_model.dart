import 'package:flutter/material.dart';
import '../../locator.dart';
import '../base_model.dart';
import '../services/api_services.dart';
import '../services/attendants_prefrence.dart';
import '../viewstate.dart';


class LoginModel extends BaseModel {
  final ApiService _api = locator<ApiService>();

  bool? isValid;

  var msg = "";
  bool isLoggedIn = false;

  var auth;


  setAuth(String sessionID) {
    auth = sessionID;
    notifyListeners();
  }

  Future<bool> login(
      String email,
      String password,
      BuildContext context,
      ) async {
    setState(ViewState.busy);

    var loginResponse = await _api.login(email, password,context);

    var success = loginResponse.result != null;

    if (loginResponse.result != null) {

      auth = ApiService.auth;
      AttendantsSharedPreference.setUserID(loginResponse.result!.uid!);
      ApiService.userID = loginResponse.result!.uid!.toString();
    }

    setState(ViewState.idle);
    return success;
  }
}
