
import 'package:attendance/pages/calendar_page.dart';
import 'package:attendance/pages/login_page.dart';
import 'package:attendance/pages/main_page.dart';
import 'package:attendance/shared_widget/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'core/services/api_services.dart';
import 'core/services/attendants_prefrence.dart';
import 'locator.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
void main() {
  setupLocator();
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'A.I.C.S.K',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: const [

        Locale('en'),
        Locale('ar'),
      ],

      theme: AppTheme.getAppTheme(),
      home: const MyApp() ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return FutureBuilder<Map<String, dynamic>>(
      future: loadPreferences(),
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {

        if (snapshot.hasData) {
          String auth = snapshot.data!['auth'];
          int userID = snapshot.data!['user_id'];
          bool success = snapshot.data!['success'];

          if (success == true) {
            if (auth.isNotEmpty && userID != 0) {
              ApiService.auth = auth;
              ApiService.userID = userID.toString();

                return const CalendarPage();

            } else {
              return const LoginPage();
            }
          } else {
            if (auth.isNotEmpty) {
              AttendantsSharedPreference.logout();
            }
            return const LoginPage();
          }
        } else {
          //child: Center(child: Image.asset("assets/images/logo.jpg"),)
          return Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: LoadingAnimationWidget.discreteCircle(
                color: theme.primaryColor,
                size: 30,
                secondRingColor: theme.hintColor,
                thirdRingColor: theme.primaryColor.withOpacity(0.5)),
          );
        }
      },
    );
  }

  Future<bool> checkSession(String auth) async {
    ApiService _api = locator<ApiService>();
    var activeSession = await _api.checkSession(auth);
    var success = activeSession.error == null &&
        activeSession.result != null &&
        activeSession.result!.active! == true;
    return success;
  }



  Future<Map<String, dynamic>> loadPreferences() async {
    String auth = await AttendantsSharedPreference.getAuth();
    int userID = await AttendantsSharedPreference.getUserID();
    // DateTime? expireSession = await SchoolSharedPreference.getExpireSession() ;
    var success = await checkSession(auth);

    return {
      'auth': auth,
      'user_id': userID,
      'success': success,
    };
  }
}
