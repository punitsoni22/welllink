import 'package:get/get.dart';
import 'package:welllink/view/appointment_view/controller/appointment_controller.dart';

class AppointmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AppointmentController());
  }
}