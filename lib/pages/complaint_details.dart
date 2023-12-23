import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_strings.dart';
import '../core/model/get_complaint.dart';
import '../core/viewModels/complaint_details.dart';
import '../core/viewstate.dart';
import '../shared_widget/app_bar_widget.dart';
import '../shared_widget/button_widget.dart';
import '../shared_widget/snackbar.dart';
import 'base_view.dart';

class ComplaintDetails extends StatefulWidget {
  // final int requestID;
  final Complaint complaintObj;

  const ComplaintDetails({Key? key, required this.complaintObj})
      : super(key: key);

  @override
  State<ComplaintDetails> createState() => _ComplaintDetailsState();
}

class _ComplaintDetailsState extends State<ComplaintDetails> {
  late int remainingTimeInSeconds;
  late Timer timer;

  @override
  void initState() {
    AppBarWidget.init(true, "");
    SnackbarShare.init(context);
    remainingTimeInSeconds =
        convertTimeStringToSeconds(widget.complaintObj.remainingTime!);
    startCountdown();
    super.initState();
  }

  void startCountdown() {
    const oneSecond = const Duration(seconds: 1);
    timer = Timer.periodic(oneSecond, (Timer t) {
      setState(() {
        if (remainingTimeInSeconds < 1) {
          // Handle when the countdown ends
          timer.cancel();
          print('Countdown ended');
        } else {
          remainingTimeInSeconds--;
        }
      });
    });
  }

  int convertTimeStringToSeconds(String timeString) {
    List<String> timeParts = timeString.split(':');
    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);
    return hours * 3600 + minutes * 60;
  }

  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;

    return '$hours:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return BaseView<ComplimentDetailsVm>(
        onModelReady: (model) => model.setData(
            widget.complaintObj.studentId!,
            widget.complaintObj.categoryId!,
            widget.complaintObj.subcategoryId!),
        builder: (context, model, child) {
          return model.state == ViewState.busy
              ? Material(
                  child: Center(
                      child: CircularProgressIndicator(
                  color: theme.primaryColor,
                )))
              : mainWidget(theme, model);
        });
  }

  Widget mainWidget(ThemeData theme, ComplimentDetailsVm model) {
    List<String> time = widget.complaintObj.remainingTime!.split(':');
    // model.setCategory(
    //     widget.complaintObj.categoryId!, widget.complaintObj.subcategoryId!);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBarWidget.mainAppBarSharedWidget(),
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: time[0].contains("-")
                      ? labelText('', "انتهى الوقت")
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            labelText('ساعة',
                                (remainingTimeInSeconds ~/ 3600).toString()),
                            labelText(
                                'دقيقة',
                                ((remainingTimeInSeconds % 3600) ~/ 60)
                                    .toString()),
                            labelText('ثانية',
                                (remainingTimeInSeconds % 60).toString())
                          ],
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 25, right: 25),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, right: 30, left: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          buildStar(
                              int.parse(widget.complaintObj.priority!) == 3,
                              theme),
                          buildStar(
                              int.parse(widget.complaintObj.priority!) >= 2,
                              theme),
                          buildStar(true, theme),
                        ],
                      ),
                      Text(
                        "${model.returnTitle(widget.complaintObj.title!)} #",
                        style: theme.textTheme.displayLarge,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  width: double.maxFinite,
                  alignment: Alignment.topRight,
                  margin: const EdgeInsets.only(
                      left: 30, right: 30, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[100],
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 1,
                        color: Colors.grey.withOpacity(.2),
                      )
                    ],
                  ),
                  child: Text(widget.complaintObj.description!,
                      style: theme.textTheme.labelLarge),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: itemWidget(
                      widget.complaintObj.allChilds!
                          ? " كل الاولاد"
                          : " ولد واحد فقط",
                      "تخص : ",
                      Icons.boy,
                      theme),
                ),
                itemWidget(model.returnBranch(widget.complaintObj.branchType!),
                    "القسم : ", Icons.school, theme),
                itemWidget(widget.complaintObj.deadline!.split(" ").first,
                    "الموعد النهائي : ", Icons.calendar_month_outlined, theme),
                itemWidget(model.selectedStudent.name!, "الطالب : ",
                    Icons.person, theme),
                itemWidget(model.selectedCategories.name!, "التصنيف الرئيسي : ",
                    Icons.category, theme),
                itemWidget(model.selectedSubCategories.name!,
                    "التصنيف الفرعي : ", Icons.category, theme),
              ],
            ),
            Padding(
                padding:
                    const EdgeInsets.only(bottom: 100, right: 40, left: 40),
                child: widget.complaintObj.state == "closed"
                    ? Text("مغلقة")
                    : actionButton(
                        widget.complaintObj.state.toString(), theme, model)),
          ],
        ));
  }

  Widget labelText(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.grey,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
           Text(
              value,
              style: const TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),

      Visibility(
        visible: label.isNotEmpty ,
        child:Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
            )),
          ),
        ],
      ),
    );
  }

  Widget itemWidget(
      String title, String subject, IconData icon, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              Text(
                title,
                textDirection: TextDirection.rtl,
                style: theme.textTheme.titleMedium,
              ),
              Text(subject,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black)),
            ],
          ),
          SizedBox(
            width: 5,
          ),
          Icon(icon),
        ],
      ),
    );
  }

  Widget buildStar(bool active, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Icon(
        Icons.star_rounded,
        size: 30,
        color: active ? theme.primaryColor : Colors.grey,
      ),
    );
  }

  Widget actionButton(
      String state, ThemeData theme, ComplimentDetailsVm model) {
    String title = "";
    Color color = Colors.green;
    switch (state) {
      case "assigned":
        title = Strings.startProgress;
        color = theme.primaryColor;
      case "in_progress":
        title = Strings.resolved;
        color = Colors.green;
      case "resolved":
        title = Strings.closed;
        color = Colors.redAccent.withOpacity(0.7);
    }

    return SizedBox(
      width: double.maxFinite,
      child: SharedButton(
        buttonLabel: title,
        onClick: () async {
          switch (state) {
            case "assigned":
              var success = await model.startProgress(widget.complaintObj.id!);
              if (success) {
                SnackbarShare.showMessage(Strings.doneAction);
              } else {
                SnackbarShare.showMessage(Strings.systemError);
              }
            case "in_progress":
              var success = await model.startResolve(widget.complaintObj.id!);
              if (success) {
                SnackbarShare.showMessage(Strings.doneAction);
              } else {
                SnackbarShare.showMessage(Strings.systemError);
              }
            case "resolved":
              var success = await model.startClosed(widget.complaintObj.id!);
              if (success) {
                SnackbarShare.showMessage(Strings.doneAction);
              } else {
                SnackbarShare.showMessage(Strings.systemError);
              }
          }
        },
        color: color,
        canClick: true,
        msgCantClick: "",
      ),
    );
  }
}
