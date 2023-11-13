import 'error_model.dart';

class AttendeeModel {
  String? jsonrpc;
  Result? result;
  Error? error;
  AttendeeModel({this.jsonrpc,  this.result,this.error});

  AttendeeModel.fromJson(Map<String, dynamic> json) {
    jsonrpc = json['jsonrpc'];
    result =
    json['result'] != null ? Result.fromJson(json['result']) : null;
    error = json['error'] != null ? Error.fromJson(json['error']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['jsonrpc'] = jsonrpc;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    if (error != null) {
      data['error'] = error!.toJson();
    }
    return data;
  }
}

class Result {
  bool? success;
  int? code;
  List<Sheet>? sheet;

  Result({this.success, this.code, this.sheet});

  Result.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    if (json['message'] != null) {
      sheet = <Sheet>[];
      json['message'].forEach((v) {
        sheet!.add(Sheet.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['code'] = code;
    if (sheet != null) {
      data['message'] = sheet!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sheet {
  int? id;
  String? name;
  String? state;
  List<Students>? students;
  String? date;
  Sheet({this.id, this.name, this.state, this.students,this.date});

  Sheet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    state = json['state'];
    if (json['students'] != null) {
      students = <Students>[];
      json['students'].forEach((v) {
        students!.add(Students.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['state'] = state;
    if (students != null) {
      data['students'] = students!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Students {
  int? id;
  String? name;
  int? sequence;
  String? state;
  String? aicskAbsentReason;

  Students(
      {this.id, this.name, this.sequence, this.state, this.aicskAbsentReason});

  Students.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sequence = json['sequence'];
    state = json['state'];
    aicskAbsentReason = json['aicsk_absent_reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['sequence'] = sequence;
    data['state'] = state;
    data['aicsk_absent_reason'] = aicskAbsentReason;
    return data;
  }
}
