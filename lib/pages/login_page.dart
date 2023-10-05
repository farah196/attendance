
import 'package:attendance/pages/calendar_page.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../constants/app_strings.dart';
import '../core/viewModels/login_model.dart';
import '../core/viewstate.dart';
import '../shared_widget/app_theme.dart';
import '../shared_widget/button_widget.dart';
import '../shared_widget/curve_bottom.dart';
import '../shared_widget/curve_top.dart';
import '../shared_widget/snackbar.dart';
import '../shared_widget/text_field_widget.dart';
import 'base_view.dart';
import 'main_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String username = "";
  String password = "";

  double leftPosition = -200;
  double topPosition = 0;
@override
  void initState() {
  SnackbarShare.init(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return WillPopScope(
        onWillPop: () async => false,
        child:

        BaseView<LoginModel>(
            onModelReady: (model) => model.msg,
            builder: (context, model, child) {
              return model.state == ViewState.busy
                  ?  Container(
               alignment: Alignment.center,
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.white,
                      child:LoadingAnimationWidget.discreteCircle(
                          color: theme.primaryColor,
                          size: 30,
                          secondRingColor: theme.hintColor,
                          thirdRingColor: theme.primaryColor.withOpacity(0.5)))
                  :  Scaffold(
                resizeToAvoidBottomInset: false,


                        body: SafeArea(
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: SizedBox(

                                  width: double.maxFinite,
                                  height: MediaQuery.of(context).size.height * 0.3,
                                  child: CustomPaint(
                                    painter: CurveTop(),
                                  ),
                                ),
                              ),

                              Align(
                                alignment: Alignment.bottomRight,
                                child: SizedBox(
                                  width: double.maxFinite,
                                  height: MediaQuery.of(context).size.height * 0.35,
                                  child: CustomPaint(
                                    painter: CurveBottom(),
                                  ),
                                ),
                              ),


                             Container(alignment: Alignment.center,
                               margin: const EdgeInsets.only(top: 110),
                               child: Column(
                                      children: [
                                        Image.asset(
                                          "assets/images/aicsk_logo1.png",
                                          width:
                                              MediaQuery.of(context).size.width * 0.5,
                                          fit: BoxFit.cover,
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  MediaQuery.of(context).size.width *
                                                      0.1),
                                          child: Column(
                                            children: [
                                              Container(
                                                margin:
                                                    const EdgeInsets.only(top: 15),
                                                child: SharedEditText(
                                                  textEditingController:
                                                      usernameController,
                                                  label: Strings.email,icon: const Icon(Icons.email,size: 20,),
                                                  onChange: (value) {
                                                    username = value;
                                                    // usernameController.text = value;
                                                  },
                                                  onSubmit: (value) {
                                                    username = value;
                                                    usernameController.text = value;
                                                  },
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(top: 15),
                                                child: SharedEditText(
                                                  textEditingController:
                                                      passwordController,
                                                  label: Strings.password,icon: const Icon(Icons.lock,size: 20,),
                                                  isObscureText: true,
                                                ),
                                              ),
                                              Container(
                                                width:
                                                    MediaQuery.of(context).size.width,
                                                margin:
                                                    const EdgeInsets.only(top: 25),
                                                child: SharedButton(
                                                  buttonLabel: Strings.login,
                                                  onClick: () {
                                                    usernameController
                                                                .text.isNotEmpty &&
                                                            passwordController
                                                                .text.isNotEmpty
                                                        ? loginProcess(model, context)
                                                        : SnackbarShare.showMessage(
                                                            Strings.emptyField);
                                                  }, color: AppTheme.primaryColor,
                                                  canClick: true,
                                                  msgCantClick: "",
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                             ),

                            ],
                          ),
                        ),

                    );
            }));
  }

  Future<void> loginProcess(LoginModel model, BuildContext context) async {
    await model
        .login(
      usernameController.text,
      passwordController.text,
      context,
    ).then((value) {

      if (value == true) {
        // model.changeState();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => const CalendarPage()),
        );

      } else {
        SnackbarShare.showMessage("البريد الالكتروني او كلمة السر غير صحيح");
      }
    });
  }
}
