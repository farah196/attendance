import 'error_model.dart';

class GradeModel {
  String? jsonrpc;
  Error? error;
  Result? result;

  GradeModel({this.jsonrpc, this.error,this.result});

  GradeModel.fromJson(Map<String, dynamic> json) {
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
  List<GradeData>? gradeData;

  Result({this.success, this.code, this.gradeData});

  Result.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    if (json['message'] != null) {
      gradeData = <GradeData>[];
      json['message'].forEach((v) {
        gradeData!.add(GradeData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['code'] = code;
    if (gradeData != null) {
      data['message'] = gradeData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GradeData {
  int? id;
  String? name;
  List<Batchs>? batchs;

  GradeData({this.id, this.name, this.batchs});

  GradeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['batchs'] != null) {
      batchs = <Batchs>[];
      json['batchs'].forEach((v) {
        batchs!.add(Batchs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (batchs != null) {
      data['batchs'] = batchs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
  @override
  String toString() {
    return name!;
  }
}

class Batchs {
  int? id;
  String? name;

  Batchs({this.id, this.name});

  Batchs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
