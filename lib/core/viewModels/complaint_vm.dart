import 'package:flutter/material.dart';
import '../../locator.dart';
import '../base_model.dart';
import '../model/get_complaint.dart';
import '../model/title_model.dart';
import '../services/api_services.dart';
import '../viewstate.dart';

class ComplaintVm extends BaseModel {
  final ApiService _api = locator<ApiService>();
  List<Complaint> complaintList = [];

  List<TitleModel> title = [
    TitleModel(title: "", key: ""),
    TitleModel(title: "رسالة شكر", key: "thank"),
    TitleModel(title: "طلب", key: "demand"),
    TitleModel(title: "ملاحظة أو إستفسار", key: "remarque"),
    TitleModel(title: "شكوى", key: "complaint"),
  ];

  List<TitleModel> stateList = [

    TitleModel(title: "مسندة", key: "assigned",color: Colors.grey),
    TitleModel(title: "تحت المعالجة", key: "in_progress",color: Colors.amber),
    TitleModel(title: "تم حلها", key: "resolved",color: Colors.green),
    TitleModel(title: "أغلقت", key: "closed",color: Colors.red),
  ];

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



  Future getComplaintData(String state) async {
    setState(ViewState.busy);
    try {
      var complaintData = await _api.getComplaint(state);
      if (complaintData.result != null &&
          complaintData.result!.success! == true) {
        complaintList = complaintData.result!.complaint!;
      }
      setState(ViewState.idle);
    } catch (e) {
      setState(ViewState.idle);
    }
  }
}
