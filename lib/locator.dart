import 'package:attendance/core/viewModels/AddComplaintVm.dart';
import 'package:attendance/core/viewModels/choose_model.dart';
import 'package:attendance/core/viewModels/complaint_details.dart';
import 'package:attendance/core/viewModels/complaint_vm.dart';
import 'package:get_it/get_it.dart';
import 'core/services/api_services.dart';
import 'core/viewModels/attendee_v_model.dart';
import 'core/viewModels/login_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => ApiService());
  locator.registerFactory(() => LoginModel());
  locator.registerFactory(() => ChooseModel());
  locator.registerFactory(() => AttendeeVModel());
  locator.registerFactory(() => ComplaintVm());
  locator.registerFactory(() => AddComplimentVm());
  locator.registerFactory(() => ComplimentDetailsVm());
}