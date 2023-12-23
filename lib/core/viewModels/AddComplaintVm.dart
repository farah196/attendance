import '../../locator.dart';
import '../base_model.dart';
import '../model/categoy_model.dart';
import '../model/get_complaint.dart';
import '../model/select_model.dart';
import '../model/title_model.dart';
import '../services/api_services.dart';
import '../viewstate.dart';

class AddComplimentVm extends BaseModel {
  final ApiService _api = locator<ApiService>();
  bool _disposed = false;
  List<Complaint> complaintList = [];
  List<SelectData> schoolList = [];
  List<SelectData> gradeList = [];
  late SelectData selectedSchool;

  late SelectData selectedGrade;

  List<SelectData> studentsList = [];
  List<SelectData> filteredStudents = [];

  late SelectData selectedStudent;

  late TitleModel selectedTitle;
  late TitleModel selectedBranch;
  late TitleModel selectedResponsible;
  late CategoryData selectedCategories;
  late SubCategories selectedSubCategories;
  List<SubCategories> subCategories = [];
  List<CategoryData> categories = [];
  late CategoryData selectedOtherCategories;

  // List<CategoryData> otherCategories = [];
  late int priorityValue = 3;
  var isAllChild = false;

  List<TitleModel> type = [
    TitleModel(title: "مدرسة", key: "school"),
    TitleModel(title: "روضة", key: "kindergarten"),
    TitleModel(title: "حضانة", key: "nursery"),
  ];

  setRating(int value) {
    priorityValue = value;
    notifyListeners();
  }

  setIsAllChild(bool value) {
    isAllChild = value;
    notifyListeners();
  }

  setSelectedSchool(SelectData school) async {
    selectedSchool = school;
    _api.selectGrade(school.id!.toString()).then((gradeData) {
      if (gradeData.result != null && gradeData.result!.success! == true) {
        gradeList.clear();
        gradeList.addAll(gradeData.result!.selectData!);
        if (gradeList.isEmpty) {
          selectedGrade = SelectData(id: 0, name: "");
        } else {
          selectedGrade = gradeData.result!.selectData!.first;
        }

        notifyListeners();
      }
    });

    notifyListeners();
  }

  setSelectedStudent(SelectData st) {
    selectedStudent = st;
    notifyListeners();
  }

  setSelectedGrade(SelectData grade) {
    selectedGrade = grade;
    notifyListeners();
  }

  setSelectedTitle(TitleModel title) {
    selectedTitle = title;
    notifyListeners();
  }

  setSelectedBranch(TitleModel branch) {
    selectedBranch = branch;
    notifyListeners();
  }

  setSelectedResponsible(TitleModel responsible) {
    selectedResponsible = responsible;
    notifyListeners();
  }

  setSelectedCategories(CategoryData category) {
    selectedCategories = category;
    subCategories = category.subCategories!;
    if (subCategories.isNotEmpty) {
      selectedSubCategories = subCategories.first;
    } else {
      selectedSubCategories = SubCategories(id: 0, name: "");
    }

    notifyListeners();
  }

  setSelectedSubCategories(SubCategories category) {
    selectedSubCategories = category;
    notifyListeners();
  }

  List<TitleModel> title = [
    TitleModel(title: "", key: ""),
    TitleModel(title: "رسالة شكر", key: "thank"),
    TitleModel(title: "طلب", key: "demand"),
    TitleModel(title: "ملاحظة أو إستفسار", key: "remarque"),
    TitleModel(title: "شكوى", key: "complaint"),
  ];
  List<TitleModel> responsible = [
    TitleModel(title: "", key: ""),
    TitleModel(title: "تتعلق بكل المدرسة", key: "school"),
    TitleModel(title: "تتعلق بصف محدد", key: "grade"),
    TitleModel(title: "تتعلق بطالب محدد", key: "student"),
  ];
  List<TitleModel> branch = [
    TitleModel(title: "", key: "", id: 0),
    TitleModel(title: "المدرسة", key: "school", id: 1),
    TitleModel(title: "الروضة", key: "kindergarten", id: 2),
    TitleModel(title: "الحضانة", key: "nursery", id: 3),
  ];

  getStudent(int id) async {
    var studentsData = await _api.getStudents();
    if (studentsData.result != null && studentsData.result!.success! == true) {
      for (var i in studentsData.result!.selectData!) {
        if (id == i.id) {
          setSelectedStudent(i);
          _disposed = true;
          break;
        }
      }
      // selectedStudent = studentsList.first;
    }
  }

  getCategory(int id, int subID) async {
    var categoryData = await _api.getCategory();
    if (categoryData.result != null && categoryData.result!.success! == true) {
      for (var i in categoryData.result!.categories!) {
        if (id == i.id) {
          // setSelectedCategories(i);
          selectedCategories = i;
          print(i.name);
          notifyListeners();
          _disposed = true;
          break;
        }
      }
      // if (subCategories.isNotEmpty) {
      //   for (var i in subCategories) {
      //     if (subID == i.id) {
      //       selectedSubCategories=i;
      //      // setSelectedSubCategories(i);
      //       _disposed = true;
      //       break;
      //     } else {
      //       _disposed = true;
      //     }
      //   }
      // }
//notifyListeners();
      // selectedStudent = studentsList.first;
    }
  }

  Future getData(bool isEdit, Complaint complaintObj) async {
    setState(ViewState.busy);
    try {
      if (isEdit) {
        for (var i in title) {
          if (complaintObj.title == i.key) {
            selectedTitle = i;
          }
        }
      } else {
        selectedTitle = title.first;
      }

      if (isEdit) {
        for (var c in branch) {
          if (complaintObj.branchId == c.id) {
            selectedBranch = c;
          }
        }
      } else {
        selectedBranch = branch.first;
      }

      if (isEdit) {
        for (var a in responsible) {
          if (complaintObj.responsibleGroup == a.key) {
            selectedResponsible = a;
          }
        }
      } else {
        selectedResponsible = responsible.first;
      }

      selectedGrade = SelectData(id: 0, name: "");

      selectedOtherCategories = CategoryData(id: 0, name: "");

      var schoolData = await _api.getSchool();
      var categoryData = await _api.getCategory();
      // var otherCategoriesData = await _api.getOtherCategories();
      var studentsData = await _api.getStudents();

      if (schoolData.result != null && schoolData.result!.success! == true) {
        schoolList.addAll(schoolData.result!.selectData!);
        setSelectedSchool(schoolList.first);
      }
      if (categoryData.result != null &&
          categoryData.result!.success! == true) {
        categories = categoryData.result!.categories!;

        if (isEdit) {
          for (var b in categories) {
            if (complaintObj.categoryId == b.id!) {
              selectedCategories = b;
              subCategories = b.subCategories!;
              for (var e in subCategories) {
                if (complaintObj.subcategoryId == e.id) {
                  selectedSubCategories = e;
                }
              }
            }
          }
        } else {
          selectedCategories = categories.first;

          subCategories = categories.first.subCategories!;
          selectedSubCategories = subCategories.first;
        }
      }

      if (studentsData.result != null &&
          studentsData.result!.success! == true) {
        studentsList = studentsData.result!.selectData!;
        if (isEdit) {
          for (var r in studentsList) {
            if (complaintObj.studentId == r.id) {
              selectedStudent = r;
            }
          }
        } else {
          selectedStudent = SelectData(id: 0, name: "");
        }
      }

      if (isEdit) {
        priorityValue = int.parse(complaintObj.priority!);
        isAllChild = complaintObj.allChilds!;
      }

      setState(ViewState.idle);
    } catch (e) {
      setState(ViewState.idle);
    }
  }

  filterStudentList(String query) {
    filteredStudents.clear();
    print(query);
    if (query.isEmpty) {
      filteredStudents.clear();
      notifyListeners();
    } else {
      for (var student in studentsList) {
        if (student.name.toString().contains(query)) {
          filteredStudents.add(student);
          notifyListeners();
        }
      }
    }
    notifyListeners();
  }

  Future<List<SelectData>> searchStudent(filter) async {
    List<SelectData> filterList = [];

    for (var st in studentsList) {
      if (st.name.toString().contains(filter)) {
        filterList.add(st);
      }
    }
    notifyListeners();
    return [];
  }

  Future addComplaintData(
    String desc
  ) async {
    bool success = false;
    try {
      var complaintData = await _api.addComplaint(
          desc,
          selectedTitle.key,
          selectedResponsible.key,
          selectedGrade.id!,
          priorityValue.toString(),
          selectedBranch.key,
          selectedBranch.id!,
          selectedStudent.id!,
          isAllChild,
          selectedCategories.id!,
          selectedSubCategories.id!);

      if (complaintData.result != null &&
          complaintData.result!.success! == true) {
        success = true;
      } else {
        success = false;
      }

      notifyListeners();
    } catch (e) {
      success = false;
      notifyListeners();
    }
    return success;
  }
  Future editComplaintData(
      int complaintID,
      String desc
      ) async {
    bool success = false;
    try {
      var complaintData = await _api.addComplaint(
          desc,
          selectedTitle.key,
          selectedResponsible.key,
          selectedGrade.id!,
          priorityValue.toString(),
          selectedBranch.key,
          selectedBranch.id!,
          selectedStudent.id!,
          isAllChild,
          selectedCategories.id!,
          selectedSubCategories.id!);

      if (complaintData.result != null &&
          complaintData.result!.success! == true) {
        success = true;
      } else {
        success = false;
      }

      notifyListeners();
    } catch (e) {
      success = false;
      notifyListeners();
    }
    return success;
  }
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
