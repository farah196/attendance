import 'package:attendance/pages/complaint_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_strings.dart';
import '../core/services/attendants_prefrence.dart';
import '../main.dart';
import '../pages/login_page.dart';

class AppBarWidget {
  static bool? _showBack;
  static String? _title;

  static void init(bool showBack, String title) {
    _showBack = showBack;
    _title = title;
  }

  static PreferredSizeWidget mainAppBarSharedWidget() {
    return AppBar(
      title: Text(
        _title!,
        style:
            TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Tajawal'),
      ),

      leading: Visibility(
          visible: _showBack == true,
          child: IconButton(
              icon:
                  const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              onPressed: () {
                if (navigatorKey.currentState!.canPop() == true) {
                  navigatorKey.currentState!.pop();
                } else {
                  SystemNavigator.pop();
                }
              })),
      actions: _showBack == true
          ? []
          : [
              PopupMenuButton<String>(
                onSelected: handleClick,
                iconColor: Colors.white,
                itemBuilder: (BuildContext context) {
                  return {'complaint', 'logout'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(
                        choice == "logout" ? Strings.logout : Strings.complaint,
                        style: TextStyle(
                            color: Colors.black38,
                            fontFamily: 'Tajawal',
                            fontSize: 13),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),
                    );
                  }).toList();
                },
              )
            ],
      automaticallyImplyLeading: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
      ),
      // Add any additional properties to customize the AppBar
      // such as background color, text style, etc.
    );
  }

  static void handleClick(String value) {
    switch (value) {
      case 'logout':
        AttendantsSharedPreference.logout();
        navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => const LoginPage()),
            ModalRoute.withName('/'));
        break;
      case 'complaint':
        navigatorKey.currentState!.push(PageRouteBuilder(
          transitionDuration: Duration(seconds: 1),
          pageBuilder: (_, __, ___) => ComplaintPage(),
        ));
        break;
    }
  }
}
