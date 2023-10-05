import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/services/attendants_prefrence.dart';
import '../pages/login_page.dart';

class AppBarWidget {
  static BuildContext? _context;
  static bool? _showBack;

  static void init(BuildContext context,bool showBack) {
    _context = context;
    _showBack = showBack;
  }

  static PreferredSizeWidget mainAppBarSharedWidget() {
    return AppBar(


      leading: Visibility(
          visible: (Navigator.canPop(_context!) == true ? true : false) && _showBack == true,
          child: IconButton(
              icon:
              const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              onPressed: () {
                if (Navigator.canPop(_context!) == true) {

                  Navigator.pop(_context!);
                } else {
                  SystemNavigator.pop();
                }
              })),
      actions: [     PopupMenuButton<String>(
        onSelected:((v){
          handleClick();
        }),
        itemBuilder: (BuildContext context) {
          return {'logout'}.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(
                "خروج",
                style: TextStyle(
                    color: Colors.black38,
                    fontFamily: 'Cairo',
                    fontSize: 13),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
            );
          }).toList();
        },
      ) ],
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

  static  void handleClick() {
    AttendantsSharedPreference.logout();
    Navigator.pushAndRemoveUntil(
        _context!,
        MaterialPageRoute(builder: (BuildContext context) => const LoginPage()),
        ModalRoute.withName('/'));
  }
}
