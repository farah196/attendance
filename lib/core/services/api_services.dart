import 'package:attendance/core/model/grade_model.dart';
import 'package:attendance/core/model/reason_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../../constants/app_strings.dart';
import '../../shared_widget/snackbar.dart';
import '../model/attendee_model.dart';
import '../model/categoy_model.dart';
import '../model/complaint.dart';
import '../model/get_complaint.dart';
import '../model/login_result.dart';
import '../model/select_model.dart';
import '../model/success_model.dart';
import '../model/update_result.dart';
import '../model/update_status.dart';
import 'attendants_prefrence.dart';

class ApiService {
  static const endpoint = 'https://testing.aicsk.edu.jo';
  static var auth = "";
  static var userID = "";

  static Map<String, String> headers(String auth) {
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'X-openerp': auth,
      'Cookie': 'session_id=$auth',
    };
  }

  Future<LoginResult> login(
      String email, String password, BuildContext context) async {
    //"mobile.app@aicsk.edu.jo"   "uxJYf1eSsEvi9jL"

    try {
      SnackbarShare.init(context);
      Map<String, dynamic> requestObject = {
        'jsonrpc': '2.0',
        'params': {
          "db":"testing",
          'login': email,
          'password': password
        },
      };
      var response = await http.post(
        Uri.parse('$endpoint/web/session/authenticate'),
        headers: ApiService.headers(""),
        body: jsonEncode(requestObject),
      );

      String rawCookie = response.headers['set-cookie']!;

      RegExp sessionIdRegex = RegExp(r'session_id=([^;]+)');
      String sessionId = sessionIdRegex.firstMatch(rawCookie)?.group(1) ?? '';

      RegExp expiresRegex = RegExp(r'Expires=([^;]+)');
      String expiresString = expiresRegex.firstMatch(rawCookie)?.group(1) ?? '';

      DateFormat inputFormat = DateFormat("EEE, dd-MMM-yyyy HH:mm:ss 'GMT'");
      DateTime expires = inputFormat.parseUtc(expiresString);

      auth = sessionId;
      AttendantsSharedPreference.setAuth(auth);
      // SchoolSharedPreference.setExpireSession(expires);

      return LoginResult.fromJson(json.decode(response.body));
    } catch (e) {
      if (e is SocketException) {
        SnackbarShare.showMessage(Strings.noInternet);
      } else if (e is TimeoutException) {
        SnackbarShare.showMessage(Strings.systemError);
      } else {
        SnackbarShare.showMessage(Strings.systemError);
      }
      return LoginResult();
    }
  }

  Future<UpdateResult> checkSession(String userAuth) async {
    Map<String, dynamic> data = {"jsonrpc": "2.0", "params": {}};
    var response = await http.post(
      Uri.parse('$endpoint/user/check_session'),
      headers: ApiService.headers(userAuth),
      body: jsonEncode(data),
    );
    auth = userAuth;
    return UpdateResult.fromJson(json.decode(response.body));
  }

  Future<SelectModel> refreshList(String id,int sheetID) async {
    Map<String, dynamic> data = {
      "jsonrpc": "2.0",
      "params": {   "db":"testing","user_id": int.parse(id),"sheet_id":sheetID}
    };

    final response = await http.post(
      Uri.parse('$endpoint/user/get/refresh_list'),
      headers: headers(auth),
      body: json.encode(data),
    );
    return SelectModel.fromJson(json.decode(response.body));
  }

  Future<GradeModel> getGrade(String id, String date) async {
    try {
    Map<String, dynamic> data = {
      "jsonrpc": "2.0",
      "params": {
        "db":"testing",
        "user_id": int.parse(id),
        "date": date,
      }
    };

    final response = await http.post(
      Uri.parse('$endpoint/user/get/grades'),
      headers: headers(auth),
      body: json.encode(data),
    );


    var gradeObj = GradeModel.fromJson(json.decode(response.body));

    if(gradeObj.error != null){
      SnackbarShare.showMessage(Strings.noPermission);
    }
    return gradeObj;}
    catch (e) {
    if (e is SocketException) {
    SnackbarShare.showMessage(Strings.noInternet);
    } else if (e is TimeoutException) {
    SnackbarShare.showMessage(Strings.systemError);
    } else {
    SnackbarShare.showMessage(Strings.systemError);
    }
    return GradeModel();
    }
  }

  Future<AttendeeModel> getAttendeeSheet(
      String id,  String date,int batchID) async {
    Map<String, dynamic> data = {
      "jsonrpc": "2.0",
      "params": {
        "db":"testing",
        "user_id": int.parse(id),
        "date": date,
        "batch_id": batchID
      }
    };

    final response = await http.post(
      Uri.parse('$endpoint/user/get/attendee_sheet'),
      headers: headers(auth),
      body: json.encode(data),
    );
    return AttendeeModel.fromJson(json.decode(response.body));
  }

  Future<UpdateStatus> setPresent(
      String id,  int stdntID) async {
    Map<String, dynamic> data = {
      "jsonrpc": "2.0",
      "params": {
        "db":"testing",
        "user_id": int.parse(id),
        "student_id": stdntID,
      }
    };

    final response = await http.post(
      Uri.parse('$endpoint/user/set/student_present'),
      headers: headers(auth),
      body: json.encode(data),
    );
    return UpdateStatus.fromJson(json.decode(response.body));
  }
  Future<UpdateStatus> setAbsent(
      String id,  int stdntID,String absentReason) async {
    Map<String, dynamic> data = {
      "jsonrpc": "2.0",
      "params": {
        "db":"testing",
        "user_id": int.parse(id),
        "student_id": stdntID,
        "absent_reason": absentReason
      }
    };

    final response = await http.post(
      Uri.parse('$endpoint/user/set/student_absent'),
      headers: headers(auth),
      body: json.encode(data),
    );
    return UpdateStatus.fromJson(json.decode(response.body));
  }

  Future<UpdateStatus> setDayOff(
      String id, int sheetId) async {
    Map<String, dynamic> data = {
      "jsonrpc": "2.0",
      "params": {
        "db":"testing",
        "user_id": int.parse(id),
        "sheet_id": sheetId
      }
    };

    final response = await http.post(
      Uri.parse('$endpoint/user/set/day_off'),
      headers: headers(auth),
      body: json.encode(data),
    );
    return UpdateStatus.fromJson(json.decode(response.body));
  }

  Future<UpdateStatus> confirmSheet(
      String id, int sheetId) async {
    Map<String, dynamic> data = {
      "jsonrpc": "2.0",
      "params": {
        "db":"testing",
        "user_id": int.parse(id),
        "sheet_id": sheetId
      }
    };

    final response = await http.post(
      Uri.parse('$endpoint/user/set/confirm_sheet'),
      headers: headers(auth),
      body: json.encode(data),
    );
    return UpdateStatus.fromJson(json.decode(response.body));
  }
  Future<ReasonsModel> getReasons(
      String id) async {
    Map<String, dynamic> data = {
      "jsonrpc": "2.0",
      "params": {
        "db":"testing",
        "user_id": int.parse(id),
      }
    };

    final response = await http.post(
      Uri.parse('$endpoint/user/get/absent_reasons'),
      headers: headers(auth),
      body: json.encode(data),
    );
    var a = ReasonsModel.fromJson(json.decode(response.body));
    return ReasonsModel.fromJson(json.decode(response.body));
  }


  Future<SelectModel> getSchool() async {
    Map<String, dynamic> data = {
      "jsonrpc": "2.0",
      "params": {"user_id": int.parse(userID),  "db":"testing",}
    };

    final response = await http.post(
      Uri.parse('$endpoint/user/select/school'),
      headers: headers(auth),
      body: json.encode(data),
    );
    return SelectModel.fromJson(json.decode(response.body));
  }

  Future<SelectModel> selectGrade(String schoolID) async {
    Map<String, dynamic> data = {
      "jsonrpc": "2.0",
      "params": {
        "user_id": int.parse(userID),
        "school_id": schoolID,
        "type": "student",
    "db":"testing",
      }
    };

    final response = await http.post(
      Uri.parse('$endpoint/user/select/grade'),
      headers: headers(auth),
      body: json.encode(data),
    );
    var a = SelectModel.fromJson(json.decode(response.body));
    return SelectModel.fromJson(json.decode(response.body));
  }

  Future<CategoryModel> getCategory() async {
    Map<String, dynamic> data = {
      "jsonrpc": "2.0",
      "params": {
        "user_id": int.parse(userID),
        "db":"testing",
      }
    };

    final response = await http.post(
      Uri.parse('$endpoint/user/get/categories'),
      headers: headers(auth),
      body: json.encode(data),
    );
    return CategoryModel.fromJson(json.decode(response.body));
  }

  Future<SelectModel> getStudents() async {
    Map<String, dynamic> data = {
      "jsonrpc": "2.0",
      "params": {
        "user_id": int.parse(userID),
        "db":"testing",
      }
    };
    final response = await http.post(
      Uri.parse('$endpoint/user/get/students'),
      headers: headers(auth),
      body: json.encode(data),
    );
    var a = SelectModel.fromJson(json.decode(response.body));
    return SelectModel.fromJson(json.decode(response.body));
  }

  Future<SuccessModel> addComplaint(
      String desc,
      String title,
      String responsible,
      int gradeID,
      String priority,
      String branchType,
      int branchID,
      int studentID,
      bool allChild,
      int categoryId,
      int subcategory,
      ) async {
    Map<String, dynamic> data = {
      "jsonrpc": "2.0",
      "params": {
        "db":"testing",
        "description": desc,
        "title": title,
        "responsible_group": responsible,
        "grade_id": gradeID,
        "priority": priority,
        "branch_type": branchType,
        "branch_id": branchID,
        "student_id": studentID,
        "all_childs": allChild,
        "category_id": categoryId,
        "subcategory_id": subcategory,
        "other_categories": {"category_id": []}
      }
    };

    final response = await http.post(
      Uri.parse('$endpoint/user/add/complaint'),
      headers: headers(auth),
      body: json.encode(data),
    );
    var a = SuccessModel.fromJson(json.decode(response.body));
    return SuccessModel.fromJson(json.decode(response.body));
  }

  Future<SuccessModel> editComplaint(
      int complaintID,
      String desc,
      String title,
      String responsible,
      int gradeID,
      String priority,
      String branchType,
      int branchID,
      int studentID,
      bool allChild,
      int categoryId,
      int subcategory,
      ) async {
    Map<String, dynamic> data = {
      "jsonrpc": "2.0",
      "params": {
        "db":"testing",
        "complaint_id": complaintID,
        "description": desc,
        "title": title,
        "responsible_group": responsible,
        "grade_id": gradeID,
        "priority": priority,
        "branch_type": branchType,
        "branch_id": branchID,
        "student_id": studentID,
        "all_childs": allChild,
        "category_id": categoryId,
        "subcategory_id": subcategory,
        "other_categories": {"category_id": []}
      }
    };

    final response = await http.post(
      Uri.parse('$endpoint/user/edit/complaint'),
      headers: headers(auth),
      body: json.encode(data),
    );
    var a = SuccessModel.fromJson(json.decode(response.body));
    return SuccessModel.fromJson(json.decode(response.body));
  }

  Future<GetComplaint> getComplaint(String state) async {
    Map<String, dynamic> data = {
      "jsonrpc": "2.0",
      "params": {
        "db":"testing",
        "user_id": int.parse(userID),
        "state":state
      }
    };

    final response = await http.post(
      Uri.parse('$endpoint/user/get/complaints'),
      headers: headers(auth),
      body: json.encode(data),
    );
    var a = GetComplaint.fromJson(json.decode(response.body));
    return GetComplaint.fromJson(json.decode(response.body));
  }

  Future<ComplaintModel> getComplaintDetails(int complaintID) async {
    Map<String, dynamic> data = {
      "jsonrpc": "2.0",
      "params": {  "db":"testing","complaint_id": complaintID}
    };
    final response = await http.post(
      Uri.parse('$endpoint/user/get/complaint/details'),
      headers: headers(auth),
      body: json.encode(data),
    );
    return ComplaintModel.fromJson(json.decode(response.body));
  }

  Future<SuccessModel> setStartProgress(int complaintID) async {
    Map<String, dynamic> data = {
      "jsonrpc": "2.0",
      "params": {  "db":"testing","complaint_id": complaintID,"user_id": int.parse(userID),}
    };
    final response = await http.post(
      Uri.parse('$endpoint/user/set/start_progress'),
      headers: headers(auth),
      body: json.encode(data),
    );
    return SuccessModel.fromJson(json.decode(response.body));
  }

  Future<SuccessModel> setResolved(int complaintID) async {
    Map<String, dynamic> data = {
      "jsonrpc": "2.0",
      "params": {  "db":"testing","complaint_id": complaintID,"user_id": int.parse(userID),}
    };
    final response = await http.post(
      Uri.parse('$endpoint/user/set/resolve_complaint'),
      headers: headers(auth),
      body: json.encode(data),
    );
    return SuccessModel.fromJson(json.decode(response.body));
  }

  Future<SuccessModel> setClosed(int complaintID) async {
    Map<String, dynamic> data = {
      "jsonrpc": "2.0",
      "params": {  "db":"testing","complaint_id": complaintID,"user_id": int.parse(userID),}
    };
    final response = await http.post(
      Uri.parse('$endpoint/user/set/close_complaint'),
      headers: headers(auth),
      body: json.encode(data),
    );
    return SuccessModel.fromJson(json.decode(response.body));
  }

}
