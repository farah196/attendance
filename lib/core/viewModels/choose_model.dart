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

  GradeData selectedGrade = GradeData(id: 00,name: '',batchs: []);
  int selectedBatch = 0;
  String selectedBatchName = "";
  bool step0 = true ;
  bool step1 = false ;
  bool step2 = false ;

  int currentStep = 0;


  Future getGrade() async {
    try {
      print(selectedDate);
      var gradeObj = await _api.getGrade(ApiService.userID, selectedDate);

      if (gradeObj.result != null && gradeObj.result!.success! == true) {
        gradeList = gradeObj.result!.gradeData!;
        filteredGrade.addAll(gradeList);
      } else {
        print("444");
      }
      print("4441");
      notifyListeners();
    } catch (e) {
      notifyListeners();
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
    filteredGrade.clear();
    batchList.clear();
    selectedGrade = GradeData(id: 00,name: '',batchs: []);
    selectedBatchName = "";
    focusedDay = date;
    String formattedDate =
    DateFormat('yyyy-MM-dd').format(date);

    selectedDate = formattedDate;
    getGrade();

  }

  setGradeSelected(GradeData select) {
    batchList.clear();
    selectedGrade = select;
    for(var i in  filteredGrade){
      if(select.id == i.id){
        batchList.addAll(i.batchs!);
        break;
      }
    }
    print("4442");
    print(batchList.length);
    notifyListeners();
  }

  // setBatchListSelected(List<Batchs> list) {
  //    batchList.clear();
  //   batchList.addAll(list);
  //   notifyListeners();
  // }
  setBatchSelected(int select,String name) {
    selectedBatch = select;
    selectedBatchName = name;
    notifyListeners();
  }

}
