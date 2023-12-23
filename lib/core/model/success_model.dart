class SuccessModel {
  String? jsonrpc;
  Result? result;

  SuccessModel({this.jsonrpc, this.result});

  SuccessModel.fromJson(Map<String, dynamic> json) {
    jsonrpc = json['jsonrpc'];
    result =
    json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['jsonrpc'] = jsonrpc;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  bool? success;
  int? code;
  // String? iD;

  Result({this.success, this.code});

  Result.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['code'] = code;
    return data;
  }
}
