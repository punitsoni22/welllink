import 'package:get/get.dart';
import 'package:welllink/view/home_view/binding/home_binding.dart';
import 'package:welllink/view/home_view/home_view.dart';
import 'package:welllink/view/hospital_view/add_hospital_view.dart';
import 'package:welllink/view/hospital_view/controller/hospital_controller.dart';
import 'package:welllink/view/hospital_view/hospital_detail_view.dart';
import 'package:welllink/view/hospital_view/hospital_list_view.dart';
import 'package:welllink/view/register_view/register_view.dart';

import '../../view/appointment_view/appointment_booking_view.dart';
import '../../view/appointment_view/appointment_doctor_list_view.dart';
import '../../view/appointment_view/appointment_hospital_list_view.dart';
import '../../view/appointment_view/appointment_view.dart';
import '../../view/appointment_view/binding/appointment_binding.dart';
import '../../view/appointment_view/user_appointments_view.dart';
import '../../view/doctor_view/add_doctor_view.dart';
import '../../view/doctor_view/controller/doctor_controller.dart';
import '../../view/doctor_view/doctor_detail_view.dart';
import '../../view/doctor_view/doctor_list_view.dart';
import '../../view/login_view/binding/login_binding.dart';
import '../../view/login_view/login_view.dart';
import '../../view/splash_view/splash_view.dart';

class AppRoutes {
  static const String initialRoute = '/';
  static const String loginView = '/login_view';
  static const String registerView = '/register_view';
  static const String homeScreenView = '/home_screen_view';
  static const String hospitalListView = '/hospital_list_view';
  static const String hospitalDetailView = '/hospital_detail_view';
  static const String addHospitalView = '/add_hospital_view';
  static const String doctorListView = '/doctor_list_view';
  static const String doctorDetailView = '/doctor_detail_view';
  static const String addDoctorView = '/add_doctor_view';
  static const String appointmentView = '/appointment';
  static const String appointmentHospitalListView = '/appointment/hospitals';
  static const String appointmentDoctorListView = '/appointment/doctors';
  static const String appointmentBookingView = '/appointment/booking';
  static const String userAppointmentsView = '/appointment/user';

  static List<GetPage> routes = [
    GetPage(name: initialRoute, page: () => const SplashScreen()),
    GetPage(
      name: loginView,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: userAppointmentsView,
      page: () => const UserAppointmentsView(),
      binding: AppointmentBinding(),
    ),
    GetPage(
      name: registerView,
      page: () => const RegisterView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: homeScreenView,
      page: () => const HomeScreenView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: hospitalListView,
      page: () => const HospitalListView(),
      binding: BindingsBuilder(() {
        Get.put(HospitalController());
      }),
    ),
    GetPage(name: hospitalDetailView, page: () => const HospitalDetailView()),
    GetPage(name: addHospitalView, page: () => const AddHospitalView()),
    GetPage(
      name: doctorListView,
      page: () => const DoctorListView(),
      binding: BindingsBuilder(() {
        Get.put(DoctorController());
      }),
    ),
    GetPage(name: doctorDetailView, page: () => const DoctorDetailView()),
    GetPage(
      name: addDoctorView,
      page: () => const AddDoctorView(),
      binding: BindingsBuilder(() {
        Get.put(DoctorController());
      }),
    ),
    // Appointment Routes
    GetPage(
      name: appointmentView,
      page: () => const AppointmentView(),
      binding: AppointmentBinding(),
    ),
    GetPage(
      name: appointmentHospitalListView,
      page: () => const AppointmentHospitalListView(),
      binding: AppointmentBinding(),
    ),
    GetPage(
      name: appointmentDoctorListView,
      page: () => const AppointmentDoctorListView(),
    ),
    GetPage(
      name: appointmentBookingView,
      page: () => const AppointmentBookingView(),
    ),
  ];
}
