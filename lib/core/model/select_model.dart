import 'error_model.dart';

class SelectModel {
  String? jsonrpc;
  Result? result;
  Error? error;
  SelectModel({this.jsonrpc,this.error, this.result});

  SelectModel.fromJson(Map<String, dynamic> json) {
    jsonrpc = json['jsonrpc'];
    result =
    json['result'] != null ? Result.fromJson(json['result']) : null;
    error =
    json['error'] != null ? Error.fromJson(json['error']) : null;
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
  List<SelectData>? selectData;

  Result({this.success, this.selectData});

  Result.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['message'] != null) {
      selectData = <SelectData>[];
      json['message'].forEach((v) {
        selectData!.add(SelectData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (selectData != null) {
      data['message'] = selectData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SelectData {
  int? id;
  String? name;

  SelectData({this.id, this.name});

  SelectData.fromJson(Map<String, dynamic> json) {

    if (json['id'] != false) {
      id = json['id'];
    }else{
      id = 0;
    }
    if (json['name'] != false) {
      name = json['name'];
    }else{
      name = "";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }

  @override
  String toString() {
    return name??"";
  }
}
