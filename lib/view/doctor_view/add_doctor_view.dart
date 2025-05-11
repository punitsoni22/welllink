import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:welllink/utils/common_widgets/common_app_bar.dart';
import 'package:welllink/utils/common_widgets/common_button.dart';
import 'package:welllink/utils/common_widgets/common_textfield.dart';
import 'package:welllink/utils/constant/app_colors.dart';
import 'package:welllink/utils/constant/extensions/text_style_extensions.dart';

import 'controller/doctor_controller.dart';

class AddDoctorView extends GetView<DoctorController> {
  const AddDoctorView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            CommonAppBar(title: 'Add Doctor', colorScheme: colorScheme),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                // physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(16.w),
                children: [
                  _buildForm(context),
                  // SizedBox(height: 24.h),
                  Obx(
                    () => CommonButton(
                      onPressed: controller.addDoctor,
                      text: 'Add Doctor',
                      isSaving: controller.isLoading.value,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextField(
          label: 'Doctor Name',
          hintText: 'Enter doctor name',
          controller: controller.nameController,
          leadingIcon: Icons.person,
        ),
        SizedBox(height: 16.h),

        CommonTextField(
          label: 'Specialization',
          hintText: 'Enter specialization',
          controller: controller.specializationController,
          leadingIcon: Icons.medical_services,
        ),
        SizedBox(height: 16.h),

        CommonTextField(
          label: 'Qualification',
          hintText: 'Enter qualification (e.g., MBBS, MD)',
          controller: controller.qualificationController,
          leadingIcon: Icons.school,
        ),
        SizedBox(height: 16.h),

        CommonTextField(
          label: 'Experience',
          hintText: 'Enter years of experience',
          controller: controller.experienceController,
          leadingIcon: Icons.work,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 16.h),

        CommonTextField(
          label: 'Phone',
          hintText: 'Enter phone number',
          controller: controller.phoneController,
          leadingIcon: Icons.phone,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 16.h),

        CommonTextField(
          label: 'Email',
          hintText: 'Enter email address',
          controller: controller.emailController,
          leadingIcon: Icons.email,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 16.h),

        // Hospital Dropdown
        Text(
          'Select Hospital',
          style: context.mediumBodyText().copyWith(fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8.h),
        Obx(() {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: Text('Select Hospital'),
                value: controller.selectedHospital.value?.id,
                items:
                    controller.hospitals.map((hospital) {
                      return DropdownMenuItem<String>(
                        value: hospital.id,
                        child: Text(hospital.name),
                      );
                    }).toList(),
                onChanged: (hospitalId) {
                  if (hospitalId != null) {
                    final selectedHospital = controller.hospitals.firstWhere(
                      (hospital) => hospital.id == hospitalId,
                    );
                    controller.selectedHospital.value = selectedHospital;
                  }
                },
              ),
            ),
          );
        }),
        SizedBox(height: 24.h),

        // Available Days
        Text(
          'Available Days',
          style: context.mediumBodyText().copyWith(fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8.h),
        Obx(
          () => Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children:
                controller.daysOfWeek.map((day) {
                  final isSelected = controller.availableDays.contains(day);
                  return FilterChip(
                    label: Text(day),
                    selected: isSelected,
                    onSelected: (_) => controller.toggleDay(day),
                    backgroundColor: Colors.grey.shade100,
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primary : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.w500 : FontWeight.normal,
                    ),
                  );
                }).toList(),
          ),
        ),
        SizedBox(height: 16.h),

        // Availability Toggle
        Obx(
          () => SwitchListTile(
            title: Text(
              'Available for Appointments',
              style: context.mediumBodyText(),
            ),
            value: controller.isAvailable.value,
            onChanged: (value) => controller.isAvailable.value = value,
            activeColor: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
