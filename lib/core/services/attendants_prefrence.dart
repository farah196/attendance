import 'package:shared_preferences/shared_preferences.dart';

class AttendantsSharedPreference {
  static Future<SharedPreferences> sharedPref = SharedPreferences.getInstance();
  static String userAuthKey = "authentication";
  static String expireDateOfSession = "expire";
  static String userIDKey = "userID";
  static setAuth(String auth) async {
    final SharedPreferences prefs = await sharedPref;
    prefs.setString(userAuthKey, auth);
  }

  static Future<String> getAuth() async {
    final SharedPreferences prefs = await sharedPref;
    final value = prefs.getString(userAuthKey) ?? "";
    return value;
  }


  static Future<void> setExpireSession(DateTime dateTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(expireDateOfSession, dateTime.toIso8601String());
  }

  static Future<DateTime?> getExpireSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dateString = prefs.getString(expireDateOfSession);
    if (dateString != null) {
      DateTime dateTime = DateTime.parse(dateString);
      return dateTime;
    }
    return null;
  }

  static setUserID(int auth) async {
    final SharedPreferences prefs = await sharedPref;
    prefs.setInt(userIDKey, auth);
  }

  static Future<int> getUserID() async {
    final SharedPreferences prefs = await sharedPref;
    final value = prefs.getInt(userIDKey) ?? 0;
    return value;
  }




  static saveUserInPreference(int userID, String email, String password) async {
    final SharedPreferences prefs = await sharedPref;

    prefs.setInt('userID', userID);
    prefs.setString('email', email);
    prefs.setString('password', password);
  }
  static Future<String> getEmail() async {
    final SharedPreferences prefs = await sharedPref;
    final value = prefs.getString('email') ?? '';
    return value;
  }

  static Future<String> getPassword() async {
    final SharedPreferences prefs = await sharedPref;
    final value = prefs.getString('password') ?? '';
    return value;
  }
  static logout() async {
    final SharedPreferences prefs = await sharedPref;
    saveUserInPreference(0, "", "");
    prefs.clear();
  }
}