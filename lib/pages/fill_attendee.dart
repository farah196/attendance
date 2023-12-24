import 'package:attendance/core/model/attendee_model.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../constants/app_strings.dart';
import '../core/viewModels/attendee_v_model.dart';
import '../core/viewstate.dart';
import '../main.dart';
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
    AppBarWidget.init(false, " الحضور والغياب / ${widget.obj.date!}");
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
                      thirdRingColor: theme.hintColor.withOpacity(0.5)))
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
                  flex: 3,
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
                              title: Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  model.filterStudents[index].name.toString(),
                                  style: theme.textTheme.bodyLarge,
                                ),
                              ),
                              value: model.selectedStudents
                                  .contains(model.filterStudents[index]),
                              secondary: model.unSelectedStudents
                                      .contains(model.filterStudents[index])
                                  ? const Icon(
                                      Icons.cancel_rounded,
                                      color: Colors.redAccent,
                                      size: 20,
                                    )
                                  : const CircleAvatar(
                                      backgroundColor: Colors.green,
                                      radius: 8,
                                      child: Icon(
                                        Icons.done,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
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
                                      .contains(model.filterStudents[index])
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
                                            if (value.isNotEmpty) {
                                              String rsn = returnReasonKey(
                                                  model.reasons.indexOf(value));
                                              model
                                                  .setAbsent(
                                                      model
                                                          .filterStudents[index]
                                                          .id!,
                                                      rsn)
                                                  .then((success) {
                                                if (success == false) {
                                                  SnackbarShare.showMessage(
                                                      Strings.systemError);
                                                }
                                              });
                                            } else {
                                              SnackbarShare.showMessage(
                                                  Strings.absentReason);
                                            }
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
                                  : const SizedBox(),
                              controlAffinity: ListTileControlAffinity.trailing,
                              activeColor: theme.primaryColor,
                              checkboxShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            const Divider(),
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
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.only(right: 25),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Colors.green,
                                    radius: 8,
                                    child: Icon(
                                      Icons.done,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    Strings.num_of_attendee,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  Text(
                                    model.selectedStudents.length.toString(),
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.cancel_rounded,
                                    color: Colors.redAccent,
                                    size: 20,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    Strings.num_of_absent,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "${model.filterStudents.length - model.selectedStudents.length}",
                                    style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
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
                                    if (model.unSelectedStudents.isNotEmpty) {
                                      showAbsentDialog(context, theme, model);
                                    } else {
                                      confirmSheet(model,theme);
                                    }
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
                                          Strings.setDayOff);
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

  confirmSheet(AttendeeVModel model,ThemeData theme) {
    model.confirmSheet(widget.obj.id!).then((value) {
      if (value == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => const CalendarPage()),
        );
      //  SnackbarShare.showMessage(Strings.confirmSheet);
        showConfirmDialog( theme);
      } else {
        SnackbarShare.showMessage(Strings.systemError);
      }
    });
  }

  showAbsentDialog(
      BuildContext context, ThemeData theme, AttendeeVModel model) {
    Widget cancelButton = TextButton(
      child: Container(
          width: MediaQuery.of(context).size.width * 0.18,
          padding: const EdgeInsets.all(5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: theme.primaryColor, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            Strings.cancel,
            style: TextStyle(color: Colors.black),
          )),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget confirmButton = TextButton(
      child: Container(
          width: MediaQuery.of(context).size.width * 0.26,
          padding: const EdgeInsets.all(5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: theme.primaryColor, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            Strings.confirmSheet,
            style: TextStyle(color: Colors.black),
          )),
      onPressed: () {
        confirmSheet(model,theme);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      scrollable: true,
      title: const Text(Strings.absentSheet, textAlign: TextAlign.right),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        width: double.maxFinite,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ListView.builder(
              itemCount: model.unSelectedStudents.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.09,
                  child: Column(
                    children: [
                      Text(
                        model.unSelectedStudents[index].name.toString(),
                        style: theme.textTheme.displayMedium,
                        textAlign: TextAlign.center,
                      ),
                      index != model.unSelectedStudents.length - 1
                          ? Divider()
                          : SizedBox(),
                    ],
                  ),
                );
              }),
        ),
      ),
      actions: [cancelButton, confirmButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showConfirmDialog(ThemeData theme) {

    AlertDialog alert = AlertDialog(
      scrollable: true,
      title:  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                navigatorKey.currentState!.pop();
              },
              icon: Icon(Icons.close)),
          Text(Strings.confirmSheet, textAlign: TextAlign.right),
        ],
      ),
      content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          width: double.maxFinite,
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset("assets/images/confirm.png"),
              Text("تم تأكيد القائمة بنجاح",style: theme.textTheme.displayMedium,),
            ],
          )),
      actions: [],

    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );






  }

  String returnReasonKey(int index) {
    String reason = "other";
    switch (index) {
      case 1:
        reason = "illness";
      case 2:
        reason = "travel";
      case 3:
        reason = "day_off";
      case 4:
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
