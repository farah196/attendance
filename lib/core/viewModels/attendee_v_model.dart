import 'package:attendance/core/model/attendee_model.dart';
import 'package:attendance/core/viewstate.dart';
import '../../constants/app_strings.dart';
import '../../locator.dart';
import '../base_model.dart';
import '../services/api_services.dart';

class AttendeeVModel extends BaseModel {
  final ApiService _api = locator<ApiService>();

  List<String> selectedReason = [];
  List<String> reasons = ["",Strings.illness, Strings.travel, Strings.dayOff, Strings.other];
  List<Students> filterStudents = [];
  List<Students> students = [];
  List<Students> selectedStudents = [];
  int filledReason = 0;
  List<Students> unSelectedStudents = [];

  fillFilterStdnt(Sheet obj) {
    setState(ViewState.busy);
    students = obj.students!;
    filterStudents.addAll(students);
    selectedStudents.addAll(students);
    setState(ViewState.idle);
  }

  void filterListStudents(String query) {
    filterStudents.clear();
    print(query);
    print(students.length);
    if (query.isEmpty) {
      filterStudents.addAll(students);
    } else {
      for (var stdnt in students) {
        if (stdnt.name!.contains(query)) {
          filterStudents.add(stdnt);
          print(query);
        }
      }
    }
    notifyListeners();
  }

  addSelectedStudent(Students stdnt) {
    selectedStudents.add(stdnt);
    setPresent(stdnt.id!);
    if(unSelectedStudents.contains(stdnt)){
      unSelectedStudents.remove(stdnt);
    }
    notifyListeners();
  }

  removeFromSelectedStudent(Students stdnt) {
    selectedStudents.remove(stdnt);
    unSelectedStudents.add(stdnt);
    notifyListeners();
  }

  // addUnSelectedStudent(Students stdnt) {
  //   unSelectedStudents.add(stdnt);
  //   notifyListeners();
  // }
  //
  // removeFromUnSelectedStudent(Students stdnt) {
  //   unSelectedStudents.remove(stdnt);
  //   notifyListeners();
  // }

  // fillUnSelected() {
  //   unSelectedStudents.clear();
  //   for (var i = 0; i < students.length; i++) {
  //     if (!selectedStudents.contains(students[i])) {
  //       unSelectedStudents.add(students[i]);
  //     }
  //   }
  //   notifyListeners();
  // }

  setSelectedReason(String rsn,int index){
    selectedReason[index] =  rsn;
    if(rsn.isNotEmpty){
      filledReason++;
    }
    notifyListeners();
  }

  Future refreshList(int sheetID) async {
    try {
      setState(ViewState.busy);
      var refreshObj = await _api.refreshList(ApiService.userID, sheetID);

      if (refreshObj.result != null && refreshObj.result!.success! == true) {
        setState(ViewState.idle);
        print("Done");
      } else {
        print("444");
        setState(ViewState.idle);
      }
    } catch (e) {
      setState(ViewState.idle);
    }
  }

  Future setPresent(int stdntID) async {
    try {
      var obj = await _api.setPresent(ApiService.userID, stdntID);

      if (obj.result != null && obj.result!.success! == true) {
        print("Done");
      } else {
        print("444");
      }
      notifyListeners();
    } catch (e) {
      notifyListeners();
    }
  }

  Future<bool> setAbsent(int stdntID, String reason) async {
    try {
      var success = false;
      var obj = await _api.setAbsent(ApiService.userID, stdntID, reason);
      if (obj.result != null && obj.result!.success! == true) {
        success = true;
        print("Done");
      } else {
        success = false;
        print("444");
      }

      notifyListeners();
      return success;
    } catch (e) {
      notifyListeners();
      return false;
    }
  }

  Future <bool> setDayOff( int sheetID) async {
    try {
      var success = false;
      var obj = await _api.setDayOff(ApiService.userID, sheetID);
      if (obj.result != null && obj.result!.success! == true) {
        print("Done Day Off");
        success = true;
      } else {
        print("444");
        success = false;
      }
      notifyListeners();
      return success;
    } catch (e) {
      notifyListeners();
      return false;
    }
  }

  Future <bool> confirmSheet(int sheetID) async {
    try {
      var success = false;
      var obj = await _api.confirmSheet(ApiService.userID, sheetID);
      if (obj.result != null && obj.result!.success! == true) {
        success = true;
        print("Done Confirm");
      } else {
        print("444");
        success = false;
      }
      notifyListeners();
      return success;
    } catch (e) {
      notifyListeners();
      return false;
    }
  }
}
