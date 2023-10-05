import 'package:attendance/core/model/grade_model.dart';
import 'package:attendance/core/viewstate.dart';
import 'package:intl/intl.dart';

import '../../constants/app_strings.dart';
import '../../locator.dart';
import '../../shared_widget/snackbar.dart';
import '../base_model.dart';
import '../model/attendee_model.dart';
import '../services/api_services.dart';


class ChooseModel extends BaseModel {
  final ApiService _api = locator<ApiService>();


  var selectedDate = "";
  List<GradeData> gradeList = [];
  List<GradeData> filteredGrade = [];
  DateTime focusedDay = DateTime.now();
  List<Batchs> batchList = [];

  int selectedGrade = 0;
  int selectedBatch = 0;

  bool step0 = true ;
  bool step1 = false ;
  bool step2 = false ;

  int currentStep = 0;


  Future getGrade(String date) async {
    try {
      setState(ViewState.busy);
      print(date);
      var gradeObj = await _api.getGrade(ApiService.userID, date);

      if (gradeObj.result != null && gradeObj.result!.success! == true) {
        gradeList = gradeObj.result!.gradeData!;
        filteredGrade.addAll(gradeList);
        nextStep();
      } else {
        print("444");
      }
      setState(ViewState.idle);
    } catch (e) {
      setState(ViewState.idle);
    }
  }

  Future<Sheet> getAttendeeSheet() async {
    try {
      var sheet = await _api.getAttendeeSheet(ApiService.userID, selectedDate,selectedBatch);

      if (sheet.result != null && sheet.result!.success! == true) {
        if(sheet.result!.sheet!.isEmpty || sheet.result!.sheet![0].state == "done"){
          return Sheet();
        }else{

          return sheet.result!.sheet![0];
        }
      } else {
        print("444");

        return Sheet();
      }

    } catch (e) {
      notifyListeners();
      return Sheet();
    }
  }

  void filterList(String query) {
    filteredGrade.clear();
    print(query);
    if (query.isEmpty) {
      filteredGrade.addAll(gradeList);
    } else {
      for (var grade in gradeList) {
        if (grade.name.toString().contains(query)) {
          filteredGrade.add(grade);
        }
      }
    }
    notifyListeners();
  }


  setDateSelected(DateTime date) {
    focusedDay = date;
    String formattedDate =
    DateFormat('yyyy-MM-dd').format(date);
    getGrade(formattedDate);
    selectedDate = formattedDate;
    notifyListeners();
  }
  setGradeSelected(int select) {
    selectedGrade = select;
    notifyListeners();
  }

  setBatchListSelected(List<Batchs> list) {
    // batchList.clear();
    batchList = list;
    notifyListeners();
  }
  setBatchSelected(int select) {
    selectedBatch = select;
    notifyListeners();
  }

  previousStep(){
    switch(currentStep)
    {
      case 0 :
        step0 = true;
        step1 = false;
        step2 = false ;
        currentStep = 0;
        break;
      case 1 :
        step0 = true;
        step1 = false;
        step2 = false ;
        currentStep = 0;
        break;
      case 2 :
        step0 = false;
        step1 = true;
        step2 = false ;
        currentStep = 1;
        break;
    }
    notifyListeners();
  }

  nextStep(){
    switch(currentStep)
    {
      case 0 :
        if(selectedDate.isEmpty){

          setDateSelected(DateTime.now());
          print(focusedDay.day);
        }else{
            step0 = false;
            step1 = true;
            step2 = false ;
            currentStep = 1;

        }

        break;
      case 1 :
        if(selectedGrade == 0){
          SnackbarShare.showMessage(Strings.chooseGrade);
        }else{
          step0 = false;
          step1 = false;
          step2 = true ;
          currentStep = 2;
        }
        break;
      case 2 :
        if(selectedGrade == 0){
          SnackbarShare.showMessage(Strings.chooseBatch);
        }else{
          step0 = false;
          step1 = false;
          step2 = false ;
          currentStep = 2;
        }
        break;

    }
    notifyListeners();
  }
}
