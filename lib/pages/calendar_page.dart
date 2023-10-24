import 'package:attendance/core/viewModels/choose_model.dart';
import 'package:attendance/pages/fill_attendee.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:table_calendar/table_calendar.dart';
import '../constants/app_strings.dart';
import '../core/model/grade_model.dart';
import '../core/viewstate.dart';
import '../shared_widget/app_bar_widget.dart';
import '../shared_widget/button_widget.dart';
import '../shared_widget/circule_paint.dart';
import '../shared_widget/snackbar.dart';
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
        onModelReady: (model) => model.initDateSelected(DateTime.now()),
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

  Widget mainWidget(ChooseModel model, ThemeData theme) {


    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBarWidget.mainAppBarSharedWidget(),
        backgroundColor: Colors.white,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height * 0.2,
              child: CustomPaint(
                painter: CirclePainter(),
              ),
            ),
            Column(
              children: [
                Align(
                    alignment: Alignment.topRight,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              "  التاريخ #",
                              style: TextStyle(
                                  color: theme.primaryColor, fontSize: 20),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
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
                          locale: Localizations.localeOf(context).languageCode,
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
                      ],
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Column(
                    children: [
                      Visibility(
                          visible: model.filteredGrade.isNotEmpty,
                          child: Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, right: 10),
                                child: Text(" # الصف ",
                                    style: TextStyle(
                                      color: theme.primaryColor,
                                      fontSize: 20,
                                    ),
                                    textDirection: TextDirection.rtl),
                              ))),
                      Padding(
                        padding: const EdgeInsets.only(top:5,right: 20, left: 20),
                        child: model.filteredGrade.isNotEmpty
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(right: 20, left: 20),
                                child: dropDown(theme, model, true),
                              )
                            : Padding(
                                padding: EdgeInsets.only(top: 40),
                                child: noDataWidget(
                                    "لا يوجد قائمة بهذا التاريخ يرجى اختيار تاريخ اخر ",
                                    theme)),
                      ),
                      Visibility(
                          visible: model.filteredGrade.isNotEmpty,
                          child: Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, right: 10),
                                child: Text(" # الشعبة ",
                                    style: TextStyle(
                                      color: theme.primaryColor,
                                      fontSize: 20,
                                    ),
                                    textDirection: TextDirection.rtl),
                              ))),
                      Visibility(
                          visible: model.filteredGrade.isNotEmpty,
                          child: Padding(
                            padding: const EdgeInsets.only(top:5,right: 40, left: 40),
                            child: dropDown(theme, model, false),
                          )),
                    ],
                  ),
                ),
                Visibility(
                  visible: model.filteredGrade.isNotEmpty,
                  child:  Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: SharedButton(
                      buttonLabel: "تأكيد",
                      onClick: () {
                        model.getAttendeeSheet().then((sheet) {
                                              if (sheet.students != null &&
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

                      },
                      color: theme.primaryColor,
                      canClick: true,
                      msgCantClick: '')),
                )
              ],
            ),
          ],
        ));
  }



  void onDaySelected(
      DateTime selectedDay, DateTime focusedDay, ChooseModel model) {
    if (!isSameDay(model.focusedDay, selectedDay)) {
      model.setDateSelected(focusedDay);
      print(model.focusedDay.day);
    }
  }


  Widget noDataWidget(String text, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(22),
      width: double.maxFinite,
      margin: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget dropDown(ThemeData theme, ChooseModel model, bool isGrade) {
    return DropdownSearch<dynamic>(
      popupProps: PopupProps.dialog(
          showSearchBox: true,
          fit: FlexFit.tight,
          emptyBuilder: (context,String){
            return Center(child: Text("يرجى اختيار الصف أولا"));
          },
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              hintText: Strings.search,
              alignLabelWithHint: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.hintColor,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: theme.hintColor,
                ),
              ),
              hintStyle: TextStyle(color: Colors.black54),
              prefixIcon: Icon(
                Icons.search,
                color: theme.hintColor,
              ),
            ),
            textAlign: TextAlign.right,
          ),
          itemBuilder: (ctx, item, isSelected) {
            return ListTile(
                selected: isSelected,
                title: Text(
                  item.name.toString(),
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
            );
          }),
      items: isGrade ? model.filteredGrade : model.batchList,
      dropdownDecoratorProps:
          DropDownDecoratorProps(textAlign: TextAlign.center),
     dropdownButtonProps: DropdownButtonProps(color: theme.hintColor),
     onChanged: (dynamic){
       Future.delayed(Duration.zero, () {

         if (mounted) {
           if(isGrade){
             GradeData a = dynamic as GradeData;
             model.setGradeSelected(a);
           }else{
             Batchs a = dynamic as Batchs;
             model.setBatchSelected(a.id!,a.name!);
           }
         }
       });
     },
      selectedItem: isGrade ? model.selectedGrade : model.selectedBatchName,
    );
  }
}
