class GetComplaint {
  String? jsonrpc;
  Result? result;

  GetComplaint({this.jsonrpc, this.result});

  GetComplaint.fromJson(Map<String, dynamic> json) {
    jsonrpc = json['jsonrpc'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jsonrpc'] = this.jsonrpc;
   
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  bool? success;
  int? code;
  List<Complaint>? complaint;

  Result({this.success, this.code, this.complaint});

  Result.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    if (json['message'] != null) {
      complaint = <Complaint>[];
      json['message'].forEach((v) {
        complaint!.add(new Complaint.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    if (this.complaint != null) {
      data['message'] = this.complaint!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Complaint {
  int? id;
  String? description;
  String? title;
  String? state;
  String? responsibleGroup;
  String? priority;
  int? branchId;
  String? branchType;
  int? gradeId;
  String? deadline;
  String? remainingTime;
  int? studentId;
  bool? allChilds;
  int? categoryId;
  int? subcategoryId;
  

  Complaint(
      {this.id,
        this.description,
        this.title,
        this.state,
        this.responsibleGroup,
        this.priority,
        this.branchId,
        this.branchType,
        this.gradeId,
        this.deadline,
        this.remainingTime,
        this.studentId,
        this.allChilds,
        this.categoryId,
        this.subcategoryId,});

  Complaint.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    title = json['title'];
    state = json['state'];
    responsibleGroup = json['responsible_group'];
    priority = json['priority'];
    branchId = json['branch_id'];
    branchType = json['branch_type'];
    gradeId = json['grade_id'];
    deadline = json['deadline'];
    remainingTime = json['remaining_time'];
    if(json['student_id'] == false){
      studentId = 0;
    }else{
      studentId = json['student_id'];
    }

    allChilds = json['all_childs'];
    categoryId = json['category_id'];
    subcategoryId = json['subcategory_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['title'] = this.title;
    data['state'] = this.state;
    data['responsible_group'] = this.responsibleGroup;
    data['priority'] = this.priority;
    data['branch_id'] = this.branchId;
    data['branch_type'] = this.branchType;
    data['grade_id'] = this.gradeId;

    data['deadline'] = this.deadline;
    data['remaining_time'] = this.remainingTime;
    data['student_id'] = this.studentId;
    if (this.studentId == false) {
      data['student_id'] = 0;
    }else{
      data['student_id'] = this.studentId;
    }
    data['all_childs'] = this.allChilds;
    data['category_id'] = this.categoryId;
    data['subcategory_id'] = this.subcategoryId;
    return data;
  }
}

