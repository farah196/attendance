import 'dart:io';
import 'package:attendance/shared_widget/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/app_strings.dart';
import '../core/model/categoy_model.dart';
import '../core/model/get_complaint.dart';
import '../core/model/select_model.dart';
import '../core/model/title_model.dart';
import '../core/viewModels/AddComplaintVm.dart';
import '../core/viewstate.dart';
import '../shared_widget/app_bar_widget.dart';
import '../shared_widget/button_widget.dart';
import '../shared_widget/text_field_widget.dart';
import 'base_view.dart';

class AddComplaintPage extends StatefulWidget {
  final Complaint complaintObj;
  final bool isEdit;

  const AddComplaintPage(
      {Key? key, required this.complaintObj, required this.isEdit})
      : super(key: key);

  @override
  State<AddComplaintPage> createState() => _AddComplaintPageState();
}

class _AddComplaintPageState extends State<AddComplaintPage> {
  TextEditingController searchController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  @override
  void initState() {
    AppBarWidget.init(true, widget.isEdit ? "تعديل الشكوى" : "اضافة شكوى");
    SnackbarShare.init(context);
    if (widget.isEdit) {
      descController.text = widget.complaintObj.description!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return BaseView<AddComplimentVm>(
        onModelReady: (model) =>
            model.getData(widget.isEdit, widget.complaintObj),
        builder: (context, model, child) {
          return model.state == ViewState.busy
              ? Material(
                  child: Center(
                      child: CircularProgressIndicator(
                  color: theme.primaryColor,
                )))
              : mainWidget(theme, model);
        });
  }

  // fillEditInfo(AddComplimentVm model) {
  //   model.getStudent(widget.complaintObj.studentId!);
  //
  //   for (var i in model.title) {
  //     if (widget.complaintObj.title == i.key) {
  //       model.setSelectedTitle(i);
  //     }
  //   }
  //   model.setRating(int.parse(widget.complaintObj.priority!));
  //   for (var i in model.branch) {
  //     if (widget.complaintObj.branchId == i.id) {
  //       model.setSelectedBranch(i);
  //     }
  //     model.setIsAllChild(widget.complaintObj.allChilds!);
  //   }
  //   for (var i in model.responsible) {
  //     if (widget.complaintObj.responsibleGroup == i.key) {
  //       model.setSelectedResponsible(i);
  //     }
  //   }
  //   // model.getCategory(widget.complaintObj.categoryId!,widget.complaintObj.subcategoryId!);
  // }

  Widget mainWidget(ThemeData theme, AddComplimentVm model) {
    String studentName = (model.selectedStudent.name == null ||
            model.selectedStudent.name!.isEmpty)
        ? 'اختر الطالب'
        : model.selectedStudent.name.toString().length > 13
            ? model.selectedStudent.name.toString().substring(0, 13) +
                '...' // Trim the text if it's longer than 15 characters
            : model.selectedStudent.name.toString();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarWidget.mainAppBarSharedWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 30, left: 30, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<TitleModel>(
                    value: model.selectedTitle,
                    icon: const Icon(Icons.arrow_drop_down_rounded),
                    elevation: 16,
                    alignment: Alignment.topRight,
                    style: const TextStyle(color: Colors.black38),
                    // underline: Container(
                    //   height: 2,
                    //   color: theme.primaryColor,
                    // ),
                    onChanged: (TitleModel? value) {
                      model.setSelectedTitle(value!);
                    },
                    items: model.title
                        .map<DropdownMenuItem<TitleModel>>((TitleModel value) {
                      return DropdownMenuItem<TitleModel>(
                        value: value,
                        child: value.title.isEmpty
                            ? SizedBox()
                            : Text(
                                value.title,
                                style: const TextStyle(
                                    fontFamily: "Tajawal", color: Colors.black),
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                              ),
                      );
                    }).toList(),
                  ),
                  Text(
                    " # العنوان",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 14),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
              child: SharedEditText(
                textEditingController: descController,
                label: Strings.desc,
                line: 3,
                icon: const Icon(
                  Icons.description,
                  size: 20,
                ),
                onChange: (value) {
                  descController.text = value;
                },
                onSubmit: (value) {
                  descController.text = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30, left: 30),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          DropdownButton<SelectData>(
                            value: model.selectedSchool,
                            icon: const Icon(Icons.arrow_drop_down_rounded),
                            elevation: 16,
                            alignment: Alignment.topRight,
                            style: const TextStyle(color: Colors.black38),
                            // underline: Container(
                            //   height: 2,
                            //   color: theme.primaryColor,
                            // ),
                            onChanged: (SelectData? value) {
                              model.setSelectedSchool(value!,0);
                            },
                            items: model.schoolList
                                .map<DropdownMenuItem<SelectData>>(
                                    (SelectData value) {
                              return DropdownMenuItem<SelectData>(
                                value: value,
                                child: Center(
                                  child: Text(
                                    value.name!,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontFamily: "Tajawal",
                                        color: Colors.black),
                                    textDirection: TextDirection.rtl,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          Text(
                            " # المدرسة  ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 14),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          DropdownButton<TitleModel>(
                            value: model.selectedBranch,
                            icon: const Icon(Icons.arrow_drop_down_rounded),
                            elevation: 16,
                            alignment: Alignment.topRight,
                            style: const TextStyle(color: Colors.black38),
                            // underline: Container(
                            //   height: 2,
                            //   color: theme.primaryColor,
                            // ),
                            onChanged: (TitleModel? value) {
                              model.setSelectedBranch(value!);
                            },
                            items: model.branch
                                .map<DropdownMenuItem<TitleModel>>(
                                    (TitleModel value) {
                              return DropdownMenuItem<TitleModel>(
                                value: value,
                                child: Center(
                                  child: Text(
                                    value.title,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontFamily: "Tajawal",
                                        color: Colors.black),
                                    textDirection: TextDirection.rtl,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          Text(
                            " # القسم  ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 14),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DropdownButton<TitleModel>(
                        value: model.selectedResponsible,
                        icon: const Icon(Icons.arrow_drop_down_rounded),
                        elevation: 16,
                        alignment: Alignment.topRight,
                        style: const TextStyle(color: Colors.black38),
                        // underline: Container(
                        //   height: 2,
                        //   color: theme.primaryColor,
                        // ),
                        onChanged: (TitleModel? value) {
                          model.setSelectedResponsible(value!);
                        },
                        items: model.responsible
                            .map<DropdownMenuItem<TitleModel>>(
                                (TitleModel value) {
                          return DropdownMenuItem<TitleModel>(
                            value: value,
                            child: Center(
                              child: Text(
                                value.title,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontFamily: "Tajawal",
                                    color: Colors.black),
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      Text(
                        "# تتعلق  ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 14),
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DropdownButton<SelectData>(
                        value: model.selectedGrade,
                        icon: const Icon(Icons.arrow_drop_down_rounded),
                        elevation: 16,
                        alignment: Alignment.topRight,
                        style: const TextStyle(color: Colors.black38),
                        onChanged: (SelectData? value) {
                          model.setSelectedGrade(value!);
                        },
                        items: model.gradeList
                            .map<DropdownMenuItem<SelectData>>(
                                (SelectData value) {
                          return DropdownMenuItem<SelectData>(
                            value: value,
                            child: Center(
                              child: Text(
                                value.name!,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontFamily: "Tajawal",
                                    color: Colors.black),
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      Text(
                        " # الصف  ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 14),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              buildStar(model, 1, theme),
                              buildStar(model, 2, theme),
                              buildStar(model, 3, theme),
                            ],
                          ),
                        ),
                        Text(
                          " # حدد الأهمية",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 14),
                          textDirection: TextDirection.rtl,
                        ),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showListWithSearchDialog(
                              theme,
                              "اختر الطالب",
                              model.filteredStudents,
                              model,
                            ).then((value) {
                              if (value != null) {
                                model.setSelectedStudent(
                                    model.filteredStudents[value]);
                              }
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.42,
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  studentName,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 14),
                                  textDirection: TextDirection.rtl,
                                ),
                                Icon(Icons.arrow_drop_down),
                              ],
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                  color: theme.primaryColor,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                        ),
                        Text(
                          " # اختر الطالب",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 14),
                          textDirection: TextDirection.rtl,
                        ),
                      ]),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30, left: 30),
              child: Divider(),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Platform.isAndroid
                        ? Switch(
                            value: model.isAllChild,
                            activeColor: theme.primaryColor,
                            onChanged: (bool value) {
                              model.setIsAllChild(value);
                            },
                          )
                        : CupertinoSwitch(
                            activeColor: theme.primaryColor,
                            value: model.isAllChild,
                            onChanged: (bool value) {
                              model.setIsAllChild(value);
                            },
                          ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        " # متعلق بالطالب واخوته ",
                        style: theme.textTheme.titleMedium,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<CategoryData>(
                      value: model.selectedCategories,
                      icon: const Icon(Icons.arrow_drop_down_rounded),
                      elevation: 16,
                      alignment: Alignment.topRight,
                      style: const TextStyle(color: Colors.black38),
                      // underline: Container(
                      //   height: 2,
                      //   color: theme.primaryColor,
                      // ),
                      onChanged: (CategoryData? value) {
                        model.setSelectedCategories(value!);
                      },
                      items: model.categories
                          .map<DropdownMenuItem<CategoryData>>(
                              (CategoryData value) {
                        return DropdownMenuItem<CategoryData>(
                          value: value,
                          child: Center(
                            child: Text(
                              value.name!,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontFamily: "Tajawal",
                                  color: Colors.black),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: Text(
                        " # الأصناف الرئيسية ",
                        style: theme.textTheme.titleMedium,
                        textDirection: TextDirection.rtl,
                      ),
                    )
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<SubCategories>(
                      value: model.selectedSubCategories,
                      icon: const Icon(Icons.arrow_drop_down_rounded),
                      elevation: 16,
                      alignment: Alignment.topRight,
                      style: const TextStyle(color: Colors.black38),
                      // underline: Container(
                      //   height: 2,
                      //   color: theme.primaryColor,
                      // ),
                      onChanged: (SubCategories? value) {
                        model.setSelectedSubCategories(value!);
                      },
                      items: model.subCategories
                          .map<DropdownMenuItem<SubCategories>>(
                              (SubCategories value) {
                        return DropdownMenuItem<SubCategories>(
                          value: value,
                          child: Center(
                            child: Text(
                              value.name!,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontFamily: "Tajawal",
                                  color: Colors.black),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: Text(
                        " # الأصناف الفرعية ",
                        style: theme.textTheme.titleMedium,
                        textDirection: TextDirection.rtl,
                      ),
                    )
                  ],
                )),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: SharedButton(
                    buttonLabel: widget.isEdit ? "تعديل" : 'اضافة',
                    onClick: () async {
                      if (descController.text.isEmpty ||
                          model.selectedTitle.title.isEmpty ||
                          model.selectedResponsible.title.isEmpty ||
                          model.selectedGrade.name == null ||
                          model.selectedBranch.title.isEmpty ||
                          model.selectedStudent.name == null ||
                          model.selectedCategories.name == null ||
                          model.selectedSubCategories.name == null) {
                        SnackbarShare.showMessage(Strings.emptyField);
                      } else {
                        if (widget.isEdit) {
                          bool success = await model.editComplaintData(
                              widget.complaintObj.id!, descController.text);
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: theme.scaffoldBackgroundColor,
                                content: Text(
                                  Strings.editComplaint,
                                  style: theme.textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.rtl,
                                ),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                            // Scaffold.of(context).showSnackBar(SnackBar(
                            //   content: Text(Strings.addComplaint),
                            // ));
                            // SnackbarShare.showMessage(Strings.addComplaint);
                            Navigator.pop(context);
                          } else {
                            SnackbarShare.showMessage(Strings.systemError);
                          }
                        } else {
                          bool success =
                              await model.addComplaintData(descController.text);
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: theme.scaffoldBackgroundColor,
                                content: Text(
                                  Strings.addComplaint,
                                  style: theme.textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.rtl,
                                ),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                            // Scaffold.of(context).showSnackBar(SnackBar(
                            //   content: Text(Strings.addComplaint),
                            // ));
                            // SnackbarShare.showMessage(Strings.addComplaint);
                            Navigator.pop(context);
                          } else {
                            SnackbarShare.showMessage(Strings.systemError);
                          }
                        }
                      }
                    },
                    color: theme.primaryColor,
                    canClick: true,
                    msgCantClick: '',
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Future showListWithSearchDialog(
    ThemeData theme,
    String title,
    List<SelectData> list,
    AddComplimentVm model,
  ) {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                title,
                style: theme.textTheme.displayMedium,
                textAlign: TextAlign.right,
              ),
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.09,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: SharedEditText(
                            textEditingController: searchController,
                            label: Strings.search,
                            icon: const Icon(
                              Icons.search,
                              size: 20,
                            ),
                            onChange: (value) {
                              setState(() {
                                model.filterStudentList(value);
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: ListView.builder(
                            itemCount: list.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    model.setSelectedStudent(list[index]);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(
                                      right: 20, left: 20, top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    border: (model.selectedStudent.id! ==
                                            list[index].id)
                                        ? Border.all(
                                            color: Colors.green, width: 2)
                                        : Border.all(
                                            color: Colors.transparent,
                                            width: 0),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    list[index].name.toString(),
                                    style: theme.textTheme.displayMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                );
              }),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    setState(() {
                      searchController.text = "";
                      model.filterStudentList("");
                    });
                    Navigator.pop(context);
                  },
                  child: Text(
                    Strings.done,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ));
  }

  Widget buildStar(AddComplimentVm model, int index, ThemeData theme) {
    return Padding(
        padding: const EdgeInsets.all(5),
        child: InkWell(
          child: Icon(
            Icons.star_rounded,
            size: 30,
            color:
                model.priorityValue >= index ? theme.primaryColor : Colors.grey,
          ),
          onTap: () {
            model.setRating(index);
          },
        ));
  }
}
