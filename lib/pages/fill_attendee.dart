import 'package:attendance/core/model/attendee_model.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../constants/app_strings.dart';
import '../core/viewModels/attendee_v_model.dart';
import '../core/viewstate.dart';
import '../shared_widget/app_bar_widget.dart';
import '../shared_widget/button_widget.dart';
import '../shared_widget/snackbar.dart';
import '../shared_widget/text_field_widget.dart';
import 'base_view.dart';
import 'calendar_page.dart';

class FillAttendee extends StatefulWidget {
  final Sheet obj;

  const FillAttendee({required this.obj, Key? key}) : super(key: key);

  @override
  State<FillAttendee> createState() => _FillAttendeeState();
}

class _FillAttendeeState extends State<FillAttendee> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    AppBarWidget.init(context, false);
    SnackbarShare.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return BaseView<AttendeeVModel>(
        onModelReady: (model) => model.fillFilterStdnt(widget.obj),
        builder: (context, model, child) {
          return model.state == ViewState.busy
              ? Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  child: LoadingAnimationWidget.discreteCircle(
                      color: theme.primaryColor,
                      size: 30,
                      secondRingColor: theme.hintColor,
                      thirdRingColor: theme.primaryColor.withOpacity(0.5)))
              : mainWidget(model, theme);
        });
  }

  Widget mainWidget(AttendeeVModel model, ThemeData theme) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBarWidget.mainAppBarSharedWidget(),
        body: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.09,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: SharedEditText(
                      textEditingController: searchController,
                      label: Strings.search,
                      icon: const Icon(
                        Icons.search,
                        size: 20,
                      ),
                      onChange: model.filterListStudents,
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15, left: 15),
                    child: ListView.builder(
                      itemCount: model.filterStudents.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        // int rsn = returnIndexReason(
                        //     model.selectedStudents[index].aicskAbsentReason!);
                        // print(rsn);

                        for (int i = 0; i < model.filterStudents.length; i++) {
                          model.selectedReason.add("");
                        }
                        return Column(
                          children: [
                            CheckboxListTile(
                              contentPadding: const EdgeInsets.all(6),
                              title:  Align(
                                alignment: Alignment.topRight,
                                child:
                                        Text(
                                          model.filterStudents[index].name.toString(),
                                          style: theme.textTheme.bodyLarge,
                                        ),

                              ),
                              value: model.selectedStudents
                                  .contains(model.filterStudents[index]),
                              onChanged: (bool? value) async {
                                if (model.selectedStudents
                                    .contains(model.filterStudents[index])) {
                                  model.removeFromSelectedStudent(
                                      model.filterStudents[index]);
                                } else {
                                  model.addSelectedStudent(
                                      model.filterStudents[index]);
                                }
                              },
                              subtitle: model.unSelectedStudents
                                      .contains(model.students[index])
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Text(
                                            "حدد سبب الغياب",
                                            style: theme.textTheme.bodyMedium,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        DropdownButton<String>(
                                          value: model.selectedReason[index]
                                              .toString(),
                                          icon: const Icon(
                                              Icons.arrow_drop_down_rounded),
                                          elevation: 16,
                                          alignment: Alignment.center,
                                          style: const TextStyle(
                                              color: Colors.black38),
                                          underline: Container(
                                            height: 2,
                                            color: theme.primaryColor,
                                          ),
                                          onChanged: (String? value) {
                                            model.setSelectedReason(
                                                value!, index);

                                            // String rsn = returnReasonKey(
                                            //     reasons.indexOf(value!));
                                            // model
                                            //     .setAbsent(
                                            //     model.unSelectedStudents[index].id!,
                                            //     rsn)
                                            //     .then((success) {
                                            //   if (success == true) {
                                            //     setState(() {
                                            //       model.unSelectedStudents[index]
                                            //           .state = "absent";
                                            //       model.unSelectedStudents[index]
                                            //           .aicskAbsentReason = rsn;
                                            //       print(rsn);
                                            //     });
                                            //   } else {
                                            //     SnackbarShare.showMessage(
                                            //         Strings.systemError);
                                            //   }
                                          },
                                          items: model.reasons
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontFamily: "Cairo",
                                                    color: Colors.black38),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                      // ),
                                    )
                                  :  SizedBox(),

                              controlAffinity: ListTileControlAffinity.trailing,
                              activeColor: theme.primaryColor,
                              checkboxShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            Divider(),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.only(right: 35),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "عدد الحضور",
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    model.selectedStudents.length.toString(),
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "عدد الغياب",
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "${model.students.length - model.selectedStudents.length}",
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: SharedButton(
                                buttonLabel: Strings.confirmSheet,
                                onClick: () {
                                  if (model.unSelectedStudents.isNotEmpty &&
                                      model.filledReason <
                                          model.unSelectedStudents.length) {
                                    SnackbarShare.showMessage(
                                        Strings.absentReason);
                                  } else {
                                    model
                                        .confirmSheet(widget.obj.id!)
                                        .then((value) {
                                      if (value == true) {
                                        SnackbarShare.showMessage(
                                            "تم تأكيد القائمة");
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  const CalendarPage()),
                                        );
                                      } else {
                                        SnackbarShare.showMessage(
                                            Strings.systemError);
                                      }
                                    });
                                  }
                                },
                                color: theme.hintColor,
                                canClick: true,
                                msgCantClick: "",
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: SharedButton(
                                buttonLabel: Strings.dayOff,
                                onClick: () {
                                  model.setDayOff(widget.obj.id!).then((value) {
                                    if (value == true) {
                                      SnackbarShare.showMessage(
                                          "تم تعيين هذا اليوم انه يوم عطلة");
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const CalendarPage()),
                                      );
                                    } else {
                                      SnackbarShare.showMessage(
                                          Strings.systemError);
                                    }
                                  });
                                },
                                color: Colors.redAccent.withOpacity(0.7),
                                canClick: true,
                                msgCantClick: "",
                              ),
                            ),
                          ],
                        ),

                      ],
                    )),
              ],
            )));
  }

  String returnReasonKey(int index) {
    String reason = "travel";
    switch (index) {
      case 0:
        reason = "illness";
      case 1:
        reason = "travel";
      case 2:
        reason = "day_off";
      case 3:
        reason = "other";
    }
    return reason;
  }

  int returnIndexReason(String key) {
    int reason = 0;
    switch (key) {
      case "illness":
        reason = 0;
      case "travel":
        reason = 1;
      case "day_off":
        reason = 2;
      case "other":
        reason = 3;
    }
    return reason;
  }
}
