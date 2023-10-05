import 'package:attendance/core/viewModels/choose_model.dart';
import 'package:attendance/pages/fill_attendee.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:table_calendar/table_calendar.dart';

import '../constants/app_strings.dart';
import '../core/viewstate.dart';
import '../shared_widget/app_bar_widget.dart';
import '../shared_widget/button_widget.dart';
import '../shared_widget/snackbar.dart';
import '../shared_widget/text_field_widget.dart';
import 'base_view.dart';

import 'package:intl/date_symbol_data_local.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  TextEditingController searchController = TextEditingController();
  final CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    AppBarWidget.init(context, false);
    initializeDateFormatting();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BaseView<ChooseModel>(
        onModelReady: (model) => model.selectedDate,
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

  Widget mainWidget(ChooseModel model, ThemeData theme) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBarWidget.mainAppBarSharedWidget(),
        backgroundColor: Colors.white,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height * 0.12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: SharedButton(
                        buttonLabel:
                            model.step2 != true ? Strings.next : Strings.save,
                        onClick: () {
                          if (model.step2 == true) {
                            if (model.selectedBatch == 0) {
                              SnackbarShare.showMessage(Strings.chooseBatch);
                            } else {
                              model.getAttendeeSheet().then((sheet) {
                                if (sheet != null &&
                                    sheet.students != null &&
                                    sheet.students!.isNotEmpty) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            FillAttendee(obj: sheet)),
                                  );
                                } else {
                                  SnackbarShare.showMessage(
                                      Strings.noAvailableSheet);
                                }
                              });
                            }
                          } else {
                            model.nextStep();
                          }
                        },
                        color: model.step2 != true
                            ? theme.hintColor
                            : theme.primaryColor,
                        canClick: true,
                        msgCantClick: "",
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: SharedButton(
                        buttonLabel: 'السابق',
                        onClick: () {
                          model.previousStep();
                        },
                        color: theme.hintColor,
                        canClick: model.step0 == true ? false : true,
                        msgCantClick: Strings.cantPrevStep,
                      ),
                    ),
                  ],
                )),
            Column(
              children: [
                Visibility(
                    visible: model.step0 == true,
                    child: Align(
                        alignment: Alignment.topRight,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 50,
                            ),
                            Text(
                              "يرجى تحديد التاريخ ",
                              style: theme.textTheme.displayMedium,
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            TableCalendar(
                              firstDay: DateTime.utc(1990, 01, 01),
                              lastDay: DateTime.utc(2222, 01, 01),
                              focusedDay: model.focusedDay,
                              selectedDayPredicate: (day) =>
                                  isSameDay(model.focusedDay, day),
                              calendarFormat: _calendarFormat,
                              // eventLoader: (day) {
                              //
                              //   if(model.focusedDay == day){
                              //     return model.fillEvent(controller.index);
                              //   }else{
                              //     return [] ;
                              //   }
                              //
                              // },
                              locale:
                                  Localizations.localeOf(context).languageCode,
                              startingDayOfWeek: StartingDayOfWeek.sunday,
                              calendarStyle: CalendarStyle(
                                todayDecoration: BoxDecoration(
                                  color: theme.hintColor,
                                  shape: BoxShape.circle,
                                ),
                                selectedDecoration: BoxDecoration(
                                  color: theme.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              onDaySelected:
                                  (DateTime selectedDay, DateTime focusedDay) {
                                onDaySelected(selectedDay, focusedDay, model);
                              },

                              onPageChanged: (focusedDay) {
                                model.focusedDay = focusedDay;
                              },
                            ),
                            // OutlinedButton(
                            //         onPressed: () async {
                            //           DateTime? pickedDate = await showDatePicker(
                            //               context: context,
                            //               builder: (context, child) {
                            //                 return Theme(
                            //                   data: Theme.of(context).copyWith(
                            //                     colorScheme: ColorScheme.light(
                            //                       primary: theme.primaryColor,
                            //                       // header background color
                            //                       onPrimary: Colors.white,
                            //                       // header text color
                            //                       onSurface:
                            //                           Colors.black, // body text color
                            //                     ),
                            //                     textButtonTheme: TextButtonThemeData(
                            //                       style: TextButton.styleFrom(
                            //                         primary:
                            //                             Colors.black, // button text color
                            //                       ),
                            //                     ),
                            //                   ),
                            //                   child: child!,
                            //                 );
                            //               },
                            //               initialDate: DateTime.now(),
                            //               //get today's date
                            //               firstDate: DateTime(2000),
                            //               //DateTime.now() - not to allow to choose before today.
                            //               lastDate: DateTime(2101));
                            //
                            //           if (pickedDate != null) {
                            //             String formattedDate =
                            //                 DateFormat('yyyy-MM-dd').format(pickedDate);
                            //             model.getGrade(formattedDate);
                            //             model.setDateSelected(formattedDate);
                            //
                            //           } else {
                            //             print("Date is not selected");
                            //           }
                            //         },
                            //         style: OutlinedButton.styleFrom(
                            //           side: BorderSide(width: 2, color: theme.primaryColor),
                            //         ),
                            //         child: const Text(
                            //           Strings.chooseDate,
                            //           style: TextStyle(
                            //               fontSize: 13,
                            //               fontWeight: FontWeight.bold,
                            //               fontFamily: "Cairo",
                            //               color: Colors.black),
                            //         ),
                            //
                            //     ),
                          ],
                        ))),
                Visibility(
                    visible: model.step1 == true,
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
                              onChange: model.filterList,
                            ),
                          ),
                        ),
                        chooseGrade(theme, model),
                      ],
                    )),
                Visibility(
                    visible: model.step2 == true,
                    child: chooseBatch(theme, model)),
              ],
            ),
          ],
        ));
  }

  Widget chooseGrade(ThemeData theme, ChooseModel model) {
    return Padding(
        padding: const EdgeInsets.only(top: 30, bottom: 50),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          child: ListView.builder(
              itemCount: model.filteredGrade.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    model.setGradeSelected(model.filteredGrade[index].id!);
                    model.setBatchListSelected(
                        model.filteredGrade[index].batchs!);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(
                        right: 20, left: 20, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: (model.selectedGrade != 0 &&
                              model.selectedGrade ==
                                  model.filteredGrade[index].id)
                          ? Border.all(color: Colors.green, width: 2)
                          : Border.all(color: Colors.transparent, width: 0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      model.filteredGrade[index].name.toString(),
                      style: theme.textTheme.displayMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }),
        ));
  }

  Widget chooseBatch(ThemeData theme, ChooseModel model) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 50),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: ListView.builder(
            itemCount: model.batchList.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  model.setBatchSelected(model.batchList[index].id!);
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(
                      right: 20, left: 20, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: (model.selectedBatch != 0 &&
                            model.selectedBatch == model.batchList[index].id)
                        ? Border.all(color: Colors.green, width: 2)
                        : Border.all(color: Colors.transparent, width: 0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    model.batchList[index].name.toString(),
                    style: theme.textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }),
      ),
    );
  }

  void onDaySelected(
      DateTime selectedDay, DateTime focusedDay, ChooseModel model) {
    if (!isSameDay(model.focusedDay, selectedDay)) {

      model.setDateSelected(focusedDay);
      print(model.focusedDay.day);
    }
  }
}
