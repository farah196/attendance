import '../../locator.dart';
import '../base_model.dart';
import '../model/categoy_model.dart';
import '../model/select_model.dart';
import '../services/api_services.dart';
import '../viewstate.dart';

class ComplimentDetailsVm extends BaseModel {
  final ApiService _api = locator<ApiService>();
  var selectedCategories = CategoryData();
  var selectedSubCategories = SubCategories();
  var selectedStudent = SelectData();

  String returnBranch(String key) {
    String branch = "";
    switch (key) {
      case "school":
        branch = "المدرسة";
        break;
      case "kindergarten":
        branch = "الروضة";
        break;
      case "nursery":
        branch = "الحضانة";
        break;
    }
    return branch;
  }

  String returnTitle(String key) {
    String title = "";
    switch (key) {
      case "thank":
        title = "رسالة شكر";
        break;
      case "demand":
        title = "طلب";
        break;
      case "remarque":
        title = "ملاحظة أو إستفسار";
        break;
      case "complaint":
        title = "شكوى";
        break;
    }
    return title;
  }

  Future setData(int studentID, int categoryID, int subCategoryID) async {
    setState(ViewState.busy);
    var studentsData = await _api.getStudents();
    if (studentsData.result != null && studentsData.result!.success! == true) {
      for (var i = 0; i < studentsData.result!.selectData!.length; i++) {
        if (studentID == studentsData.result!.selectData![i].id!) {
          selectedStudent = studentsData.result!.selectData![i];
          break;
        }
      }
    }
    var categoryData = await _api.getCategory();
    if (categoryData.result != null && categoryData.result!.success! == true) {
      for (var i = 0; i < categoryData.result!.categories!.length; i++) {
        if (categoryID == categoryData.result!.categories![i].id!) {
          selectedCategories = categoryData.result!.categories![i];
          for (var i = 0; i < selectedCategories.subCategories!.length; i++) {
            if (subCategoryID == selectedCategories.subCategories![i].id!) {
              selectedSubCategories = selectedCategories.subCategories![i];
              break;
            }
          }
        }
      }
    }
    setState(ViewState.idle);
  }

  Future<bool> startProgress(
    int complaintID,
  ) async {
    var response = await _api.setStartProgress(complaintID);

    var success = response.result != null && response.result!.success!;

    notifyListeners();
    return success;
  }

  Future<bool> startResolve(
      int complaintID,
      ) async {
    var response = await _api.setResolved(complaintID);

    var success = response.result != null && response.result!.success!;

    notifyListeners();
    return success;
  }

  Future<bool> startClosed(
      int complaintID,
      ) async {
    var response = await _api.setClosed(complaintID);

    var success = response.result != null && response.result!.success!;

    notifyListeners();
    return success;
  }
}
