import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:welllink/utils/constant/app_colors.dart';
import 'package:welllink/utils/constant/extensions/text_style_extensions.dart';
import 'package:welllink/utils/routes/app_routes.dart';
import 'controller/hospital_controller.dart';
import 'model/hospital_model.dart';

class HospitalListView extends StatelessWidget {
  const HospitalListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HospitalController());

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(
              Icons.local_hospital,
              color: AppColors.primary,
              size: 24.sp,
            ),
            SizedBox(width: 10.w),
            Text(
              'Hospitals',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.grey.shade700),
            onPressed: () => controller.fetchHospitals(),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
        onPressed: () => Get.toNamed(AppRoutes.addHospitalView),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            color: Colors.white,
            child: TextField(
              onChanged: controller.filterHospitals,
              decoration: InputDecoration(
                hintText: 'Search hospitals...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14.sp,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
              ),
            ),
          ),
          // Hospital List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.hospitals.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.errorMessage.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 60.sp,
                        color: Colors.red,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Error loading hospitals',
                        style: context.mediumTitleText(),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        controller.errorMessage.value,
                        style: context.mediumBodyText(),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              if (controller.filteredHospitals.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_hospital,
                        size: 80.sp,
                        color: Colors.grey.shade400,
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'No hospitals found',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Try searching with different keywords or add a new hospital',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.fetchHospitals(),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  itemCount: controller.filteredHospitals.length,
                  itemBuilder: (context, index) {
                    final hospital = controller.filteredHospitals[index];
                    return _buildHospitalCard(context, hospital);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalCard(BuildContext context, Hospital hospital) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
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
      child: InkWell(
        onTap: () => Get.toNamed(
          AppRoutes.hospitalDetailView,
          arguments: hospital,
        ),
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hospital Name and Type
              Row(
                children: [
                  Expanded(
                    child: Text(
                      hospital.name,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (hospital.isGovernment)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        'Govt',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8.h),
              // Address
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16.sp,
                    color: Colors.grey.shade600,
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      hospital.address,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              // Phone and Beds
              Row(
                children: [
                  Icon(
                    Icons.phone,
                    size: 16.sp,
                    color: Colors.grey.shade600,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    hospital.phone,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  if (hospital.beds > 0) ...[
                    SizedBox(width: 16.w),
                    Icon(
                      Icons.hotel,
                      size: 16.sp,
                      color: Colors.grey.shade600,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '${hospital.beds} Beds',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
              if (hospital.specialties.isNotEmpty) ...[
                SizedBox(height: 12.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: hospital.specialties.take(3).map((specialty) => Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      specialty,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}