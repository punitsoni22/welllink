import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:welllink/utils/constant/extensions/text_style_extensions.dart';
import 'package:welllink/view/appointment_view/controller/appointment_controller.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../utils/common_widgets/common_button.dart';
import '../../utils/common_widgets/common_textfield.dart';
import '../../utils/constant/app_colors.dart';

class AppointmentBookingView extends StatelessWidget {
  const AppointmentBookingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppointmentController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: AppColors.primary,
              size: 24.sp,
            ),
            SizedBox(width: 10.w),
            Text(
              'Book Appointment',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Info Card
              Obx(() {
                final doctor = controller.selectedDoctor.value;
                final hospital = controller.selectedHospital.value;

                if (doctor == null || hospital == null) {
                  return const SizedBox.shrink();
                }

                return Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 40.sp,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dr. ${doctor.name}',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  doctor.specialization,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Divider(color: Colors.grey.shade200),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Icon(
                            Icons.local_hospital,
                            size: 16.sp,
                            color: Colors.grey.shade600,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              hospital.name,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey.shade600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16.sp,
                            color: Colors.grey.shade600,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              'Available on: ${doctor.availableDays.join(', ')}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              SizedBox(height: 24.h),
              // Patient Information
              Text(
                'Patient Information',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16.h),
              CommonTextField(
                label: 'Full Name',
                hintText: 'Enter your full name',
                controller: controller.patientNameController,
                leadingIcon: Icons.person,
              ),
              SizedBox(height: 16.h),
              CommonTextField(
                label: 'Phone Number',
                hintText: 'Enter your phone number',
                controller: controller.patientPhoneController,
                leadingIcon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16.h),
              CommonTextField(
                label: 'Email (Optional)',
                hintText: 'Enter your email address',
                controller: controller.patientEmailController,
                leadingIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 24.h),
              // Calendar
              Text(
                'Select Date',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.r),
                  child: Obx(() {
                    final firstDay = DateTime.now();
                    final lastDay = DateTime.now().add(const Duration(days: 30));

                    return TableCalendar(
                      firstDay: firstDay,
                      lastDay: lastDay,
                      focusedDay: controller.selectedDate.value ?? DateTime.now(),
                      calendarFormat: CalendarFormat.month,
                      selectedDayPredicate: (day) {
                        return isSameDay(controller.selectedDate.value, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        controller.selectDate(selectedDay);
                      },
                      headerStyle: HeaderStyle(
                        titleCentered: true,
                        formatButtonVisible: false,
                        titleTextStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      calendarStyle: CalendarStyle(
                        selectedDecoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        defaultTextStyle: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 24.h),
              // Time Slots
              Obx(() {
                if (controller.selectedDate.value == null) {
                  return const SizedBox.shrink();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Time Slot',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    if (controller.isLoading.value)
                      Center(
                        child: CircularProgressIndicator(),
                      )
                    else if (controller.availableTimeSlots.isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.h),
                          child: Text(
                            'No available time slots for this date',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      )
                    else
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: controller.availableTimeSlots.map((slot) {
                          final isSelected = controller.selectedTimeSlot.value == slot;
                          return ChoiceChip(
                            label: Text(slot),
                            selected: isSelected,
                            onSelected: (_) {
                              controller.selectedTimeSlot.value = slot;
                            },
                            backgroundColor: Colors.grey.shade100,
                            selectedColor: AppColors.primary.withOpacity(0.2),
                            labelStyle: TextStyle(
                              fontSize: 14.sp,
                              color: isSelected ? AppColors.primary : Colors.black87,
                              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              side: BorderSide(
                                color: isSelected
                                    ? AppColors.primary.withOpacity(0.5)
                                    : Colors.grey.shade300,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                );
              }),
              SizedBox(height: 24.h),
              // Notes
              Text(
                'Additional Notes (Optional)',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller.notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Enter any additional information...',
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade500,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.all(16.r),
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              // Book Appointment Button
              Obx(() => CommonButton(
                onPressed: controller.bookAppointment,
                text: 'Book Appointment',
                isSaving: controller.isLoading.value,
              )),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}