import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:welllink/utils/constant/app_colors.dart';
import 'package:welllink/utils/constant/extensions/text_style_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/doctor_model.dart';

class DoctorDetailView extends StatelessWidget {
  const DoctorDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final Doctor doctor = Get.arguments;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.h,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Dr. ${doctor.name}",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary.withOpacity(0.3),
                      AppColors.primary,
                    ],
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Specialization Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      doctor.specialization,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Qualification
                  _buildInfoRow(icon: Icons.school, text: doctor.qualification),
                  SizedBox(height: 10.h),

                  // Experience
                  _buildInfoRow(
                    icon: Icons.work,
                    text: "${doctor.experience} years of experience",
                  ),
                  SizedBox(height: 20.h),

                  // Hospital Info
                  Text('Hospital', style: context.mediumTitleText()),
                  SizedBox(height: 10.h),
                  Container(
                    padding: EdgeInsets.all(10.w),
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
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_hospital,
                          color: AppColors.primary,
                          size: 26.sp,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            doctor.hospitalName,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Available Days
                  Text('Available Days', style: context.mediumTitleText()),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children:
                        doctor.availableDays
                            .map(
                              (day) => Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  day,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                  SizedBox(height: 24.h),

                  // Contact Information
                  Text('Contact Information', style: context.mediumTitleText()),
                  SizedBox(height: 16.h),

                  // Phone
                  _buildInfoSection(
                    context,
                    'Phone',
                    doctor.phone,
                    Icons.phone,
                    Colors.green.shade600,
                    onTap: () => _launchUrl('tel:${doctor.phone}'),
                  ),
                  SizedBox(height: 12.h),

                  // Email
                  if (doctor.email.isNotEmpty)
                    _buildInfoSection(
                      context,
                      'Email',
                      doctor.email,
                      Icons.email,
                      Colors.blue.shade600,
                      onTap: () => _launchUrl('mailto:${doctor.email}'),
                    ),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: Colors.grey.shade600),
        SizedBox(width: 10.w),
        Text(
          text,
          style: TextStyle(fontSize: 15.sp, color: Colors.grey.shade800),
        ),
      ],
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String title,
    String content,
    IconData icon,
    Color iconColor, {
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 22.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  content,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color:
                        onTap != null ? Colors.blue.shade700 : Colors.black87,
                    decoration:
                        onTap != null
                            ? TextDecoration.underline
                            : TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
