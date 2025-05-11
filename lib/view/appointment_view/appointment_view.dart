import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:welllink/utils/constant/extensions/text_style_extensions.dart';
import 'package:welllink/utils/routes/app_routes.dart';

import '../../utils/common_widgets/common_button.dart';
import '../../utils/constant/app_colors.dart';

class AppointmentView extends StatelessWidget {
  const AppointmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book an Appointment'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Schedule Your Medical Appointment',
              style: context.bigTitleText(),
            ),
            SizedBox(height: 8.h),
            Text(
              'Book an appointment with the best doctors in your area',
              style: context.mediumBodyText().copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
            Center(
              child: Image.asset(
                'assets/images/appointment.png',
                height: 200.h,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 8.h),

            // Steps
            _buildStep(
              context,
              icon: Icons.local_hospital,
              title: 'Select Hospital',
              description: 'Choose from our network of trusted hospitals',
              color: Colors.blue,
              number: 1,
            ),
            SizedBox(height: 10.h),

            _buildStep(
              context,
              icon: Icons.medical_services,
              title: 'Choose Doctor',
              description: 'Find the right specialist for your needs',
              color: Colors.green,
              number: 2,
            ),
            SizedBox(height: 10.h),

            _buildStep(
              context,
              icon: Icons.calendar_today,
              title: 'Book Appointment',
              description: 'Select a convenient date and time',
              color: Colors.orange,
              number: 3,
            ),

            const Spacer(),

            // Start Button
            CommonButton(
              onPressed: () =>
                  Get.toNamed(AppRoutes.appointmentHospitalListView),
              text: 'Start Booking',
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required int number,
  }) {
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.mediumTitleText(),
              ),
              SizedBox(height: 4.h),
              Text(
                description,
                style: context.smallBodyText().copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
            ],
          ),
        ),
        Icon(
          icon,
          color: color,
          size: 24.sp,
        ),
      ],
    );
  }
}
