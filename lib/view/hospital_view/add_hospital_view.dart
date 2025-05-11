import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:welllink/utils/common_widgets/common_app_bar.dart';
import 'package:welllink/utils/common_widgets/common_button.dart';
import 'package:welllink/utils/common_widgets/common_textfield.dart';
import 'package:welllink/utils/constant/extensions/text_style_extensions.dart';

import 'controller/hospital_controller.dart';

class AddHospitalView extends GetView<HospitalController> {
  const AddHospitalView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            CommonAppBar(
              title: 'Add Hospital',
              colorScheme: colorScheme,
              isBackAllowed: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 20.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [_buildForm(context)],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    // Common specialties list
    final commonSpecialties = [
      'Cardiology',
      'Neurology',
      'Orthopedics',
      'Pediatrics',
      'Gynecology',
      'Oncology',
      'Dermatology',
      'Ophthalmology',
      'ENT',
      'Psychiatry',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextField(
          label: 'Hospital Name',
          hintText: 'Enter hospital name',
          controller: controller.nameController,
          leadingIcon: Icons.local_hospital,
        ),
        SizedBox(height: 16.h),

        CommonTextField(
          label: 'Address',
          hintText: 'Enter hospital address',
          controller: controller.addressController,
          leadingIcon: Icons.location_on,
          // maxLines: 2,
        ),
        SizedBox(height: 16.h),

        CommonTextField(
          label: 'Phone Number',
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

        CommonTextField(
          label: 'Website',
          hintText: 'Enter website URL (optional)',
          controller: controller.websiteController,
          leadingIcon: Icons.web,
          keyboardType: TextInputType.url,
        ),
        SizedBox(height: 16.h),

        CommonTextField(
          label: 'Number of Beds',
          hintText: 'Enter number of beds',
          controller: controller.bedsController,
          leadingIcon: Icons.bed,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 16.h),

        // Government Hospital Checkbox
        Obx(
          () => CheckboxListTile(
            title: Text('Government Hospital', style: context.mediumBodyText()),
            value: controller.isGovernment.value,
            onChanged:
                (value) => controller.isGovernment.value = value ?? false,
            activeColor: Theme.of(context).colorScheme.primary,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
        SizedBox(height: 16.h),

        // Specialties Section
        Text('Specialties', style: context.subtitleText()),
        SizedBox(height: 8.h),
        Text(
          'Select the specialties available at this hospital',
          style: context.smallBodyText().copyWith(color: Colors.grey.shade600),
        ),
        SizedBox(height: 12.h),

        Obx(
          () => Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children:
                commonSpecialties.map((specialty) {
                  final isSelected = controller.specialties.contains(specialty);
                  return GestureDetector(
                    onTap: () => controller.toggleSpecialty(specialty),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        specialty,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),

        SizedBox(height: 24.h),

        // Submit Button
        Obx(
          () => CommonButton(
            onPressed:
                controller.isLoading.value
                    ? null
                    : () => controller.addHospital(),
            text: 'Add Hospital',
            isSaving: controller.isLoading.value,
          ),
        ),
      ],
    );
  }
}
