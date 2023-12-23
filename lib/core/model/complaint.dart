class ComplaintModel {
  String? jsonrpc;

  Result? result;

  ComplaintModel({this.jsonrpc, this.result});

  ComplaintModel.fromJson(Map<String, dynamic> json) {
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
  Details? details;

  Result({this.success, this.code, this.details});

  Result.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    details =
    json['message'] != null ? Details.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['code'] = code;
    if (details != null) {
      data['message'] = details!.toJson();
    }
    return data;
  }
}

class Details {
  int? compliantId;
  String? description;
  String? title;
  String? responsibleGroup;
  String? priority;
  int? branchId;
  String? branchType;
  int? gradeId;
  int? responsibleUserId;
  String? deadline;
  String? remainingTime;
  int? parentId;
  int? studentId;
  bool? allChilds;
  int? categoryId;
  int? subcategoryId;
  List<OtherCategories>? otherCategories;

  Details(
      {this.compliantId,
        this.description,
        this.title,
        this.responsibleGroup,
        this.priority,
        this.branchId,
        this.branchType,
        this.gradeId,
        this.responsibleUserId,
        this.deadline,
        this.remainingTime,
        this.parentId,
        this.studentId,
        this.allChilds,
        this.categoryId,
        this.subcategoryId,
        this.otherCategories});

  Details.fromJson(Map<String, dynamic> json) {
    compliantId = json['compliant_id'];
    description = json['description'];
    title = json['title'];
    responsibleGroup = json['responsible_group'];
    priority = json['priority'];
    branchId = json['branch_id'];
    branchType = json['branch_type'];
    gradeId = json['grade_id'];
    responsibleUserId = json['responsible_user_id'];
    deadline = json['deadline'];
    remainingTime = json['remaining_time'];
    parentId = json['parent_id'];
    studentId = json['student_id'];
    allChilds = json['all_childs'];
    categoryId = json['category_id'];
    subcategoryId = json['subcategory_id'];
    if (json['other_categories'] != null) {
      otherCategories = <OtherCategories>[];
      json['other_categories'].forEach((v) {
        otherCategories!.add(OtherCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['compliant_id'] = compliantId;
    data['description'] = description;
    data['title'] = title;
    data['responsible_group'] = responsibleGroup;
    data['priority'] = priority;
    data['branch_id'] = branchId;
    data['branch_type'] = branchType;
    data['grade_id'] = gradeId;
    data['responsible_user_id'] = responsibleUserId;
    data['deadline'] = deadline;
    data['remaining_time'] = remainingTime;
    data['parent_id'] = parentId;
    data['student_id'] = studentId;
    data['all_childs'] = allChilds;
    data['category_id'] = categoryId;
    data['subcategory_id'] = subcategoryId;
    if (otherCategories != null) {
      data['other_categories'] =
          otherCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OtherCategories {
  int? categoryId;
  String? categoryName;

  OtherCategories({this.categoryId, this.categoryName});

  OtherCategories.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    return data;
  }
}
