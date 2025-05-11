import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:welllink/utils/constant/app_colors.dart';
import 'package:welllink/utils/constant/extensions/text_style_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../hospital_view/model/hospital_model.dart';

class HospitalDetailView extends StatelessWidget {
  const HospitalDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Hospital hospital = Get.arguments;

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
                hospital.name,
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
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hospital Type and Beds
                  Row(
                    children: [
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
                          hospital.isGovernment
                              ? 'Government Hospital'
                              : 'Private Hospital',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      if (hospital.beds > 0) ...[
                        SizedBox(width: 10.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            '${hospital.beds} Beds',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.teal.shade700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // Address Section
                  _buildInfoSection(
                    context,
                    'Address',
                    hospital.address,
                    Icons.location_on,
                    Colors.red.shade400,
                  ),
                  SizedBox(height: 20.h),

                  // Contact Information
                  _buildInfoSection(
                    context,
                    'Contact',
                    hospital.phone,
                    Icons.phone,
                    Colors.green.shade600,
                    onTap: () => _launchUrl('tel:${hospital.phone}'),
                  ),
                  SizedBox(height: 12.h),

                  if (hospital.email.isNotEmpty)
                    _buildInfoSection(
                      context,
                      'Email',
                      hospital.email,
                      Icons.email,
                      Colors.blue.shade600,
                      onTap: () => _launchUrl('mailto:${hospital.email}'),
                    ),

                  if (hospital.website.isNotEmpty) ...[
                    SizedBox(height: 12.h),
                    _buildInfoSection(
                      context,
                      'Website',
                      hospital.website,
                      Icons.web,
                      Colors.purple.shade600,
                      onTap: () => _launchUrl(hospital.website),
                    ),
                  ],
                  SizedBox(height: 24.h),

                  // Specialties Section
                  if (hospital.specialties.isNotEmpty) ...[
                    Text('Specialties', style: context.mediumTitleText()),
                    SizedBox(height: 12.h),
                    Wrap(
                      spacing: 10.w,
                      runSpacing: 10.h,
                      children: hospital.specialties
                          .map((specialty) => Container(
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
                          specialty,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
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
                    color: onTap != null ? Colors.blue.shade700 : Colors.black87,
                    decoration: onTap != null
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

  Future<void> _launchMaps(double lat, double lng, String label) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng&query_place_id=$label';
    await _launchUrl(url);
  }
}