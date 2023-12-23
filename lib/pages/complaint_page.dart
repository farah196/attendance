import 'package:attendance/core/model/title_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../constants/app_strings.dart';
import '../core/model/get_complaint.dart';
import '../core/viewModels/complaint_vm.dart';
import '../core/viewstate.dart';
import '../shared_widget/app_bar_widget.dart';
import 'add_complaint_page.dart';
import 'base_view.dart';
import 'complaint_details.dart';

class ComplaintPage extends StatefulWidget {
  const ComplaintPage({Key? key}) : super(key: key);

  @override
  State<ComplaintPage> createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  @override
  void initState() {
    AppBarWidget.init(true, "الشكاوي");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return BaseView<ComplaintVm>(
        onModelReady: (model) => model.getComplaintData(""),
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

  Widget mainWidget(ThemeData theme, ComplaintVm model) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBarWidget.mainAppBarSharedWidget(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
          tooltip: 'إضافة شكوى',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AddComplaintPage(
                        isEdit: false,
                        complaintObj: Complaint(),
                      )),
            ).then((value) {
              AppBarWidget.init(true, "الشكاوي");
              model.getComplaintData("");
            });
          },
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 25, right: 25),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: Image.asset(
                        'assets/images/filter.png',
                        width: MediaQuery.of(context).size.width * 0.13,
                        height: MediaQuery.of(context).size.height * 0.034,
                      ),
                      onTap: () {
                        final RenderBox button =
                            context.findRenderObject() as RenderBox;
                        showMenu(
                            context: context,
                            position: RelativeRect.fromRect(
                              Rect.fromPoints(
                                button.localToGlobal(Offset.zero),
                                button.localToGlobal(
                                    button.size.bottomRight(Offset.zero)),
                              ),
                              Offset.zero & MediaQuery.of(context).size,
                            ),
                            items: model.stateList.map((TitleModel item) {
                              return PopupMenuItem(
                                child: GestureDetector(
                                  onTap: () {
                                    model.getComplaintData(item.key);
                                    Navigator.pop(context);
                                  },
                                  child: ListTile(
                                    title: Text(" شكوى ${item.title}"),
                                  ),
                                ),
                              );
                            }).toList());

                        // <PopupMenuEntry>[
                        //   PopupMenuItem(
                        //     child: ListTile(
                        //       leading: Icon(Icons.add),
                        //       title: Text('Option 1'),
                        //     ),
                        //   ),
                        //   PopupMenuItem(
                        //     child: ListTile(
                        //       leading: Icon(Icons.remove),
                        //       title: Text('Option 2'),
                        //     ),
                        //   ),
                        //   // Add more menu items as needed
                        // ],
                      },
                    ),
                    Text(
                      "الشكاوى الحديثة",
                      style: theme.textTheme.displayLarge,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: model.complaintList.isNotEmpty
                  ? ListView.builder(
                      itemCount: model.complaintList.length,
                      itemBuilder: (context, index) {
                        late TitleModel state;
                        for (var st in model.stateList) {
                          if (model.complaintList[index].state.toString() ==
                              st.key) {
                            state = st;
                            break;
                          }
                        }

                        return Padding(
                            padding: EdgeInsets.only(
                                bottom: index == model.complaintList.length - 1
                                    ? MediaQuery.of(context).size.height * 0.1
                                    : 0),
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ComplaintDetails(
                                              complaintObj:
                                                  model.complaintList[index],
                                            )),
                                  ).then((value) =>
                                      model.getComplaintData(""));
                                },
                                child: Slidable(
                                  key: Key('anyString'),
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (BuildContext context) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        AddComplaintPage(
                                                          isEdit: true,
                                                          complaintObj:
                                                          model.complaintList[index],
                                                        )),
                                          ).then((value) {

                                            AppBarWidget.init(true, "الشكاوي");
                                            model.getComplaintData("");
                                          });

                                        },
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                        label: Strings.edit,
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(
                                        left: 25, right: 25, top: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[50],
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 1,
                                          color: Colors.grey.withOpacity(.2),
                                        )
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Align(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                              model.returnTitle(model
                                                  .complaintList[index].title
                                                  .toString()),
                                              style:
                                                  theme.textTheme.displayMedium,
                                            )),
                                        Align(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                                model.complaintList[index]
                                                    .description
                                                    .toString(),
                                                style: theme
                                                    .textTheme.bodyMedium)),
                                        Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text(state.title,
                                                style: TextStyle(
                                                    color: state.color,
                                                    fontWeight:
                                                        FontWeight.w600))),
                                      ],
                                    ),
                                  ),
                                )));
                      },
                    )
                  : Center(
                      child: Text("No data .."),
                    ),
            )
          ],
        ));
  }

  @override
  void dispose() {
    AppBarWidget.init(false, "الحضور والغياب");
    super.dispose();
  }
}
