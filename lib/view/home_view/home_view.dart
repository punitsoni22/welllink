import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:welllink/utils/constant/extensions/text_style_extensions.dart';

import '../../utils/constant/app_colors.dart';
import '../../utils/routes/app_routes.dart';
import '../all_news_view/all_news_view.dart';
import 'controller/home_controller.dart';
import 'widget/news_tile.dart';

class HomeScreenView extends GetView<HomeController> {
  const HomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final totalHeight = constraints.maxHeight;
          final headerHeight = totalHeight * 0.35;

          return Stack(
            children: [
              // Decorative background elements
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Header section
              Container(
                height: headerHeight,
                width: double.infinity,
                padding: EdgeInsets.only(
                  left: 24.w,
                  right: 24.w,
                  top: MediaQuery.of(context).padding.top + 16.h,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAnimatedText(
                          'Welcome!',
                          context.mediumTitleText(),
                        ),
                        SizedBox(height: 8.h),
                        _buildAnimatedText(
                          'Dr. Jane Doe',
                          context.superLargeSubtitleText().copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        _buildAnimatedText(
                          'How is it going today?',
                          context.mediumCaptionText(),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Hero(
                      tag: 'doctor_image',
                      child: SizedBox(
                        width: 150.w,
                        height: headerHeight - 20.h,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Image.asset(
                            'assets/images/lady_doctor.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Main content area
              NotificationListener<DraggableScrollableNotification>(
                onNotification: (notification) {
                  // You can add animation effects based on scroll position here
                  return false;
                },
                child: DraggableScrollableSheet(
                  initialChildSize: 0.65,
                  minChildSize: 0.65,
                  maxChildSize: 1.0,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24.r),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24.r),
                        ),
                        child: CustomScrollView(
                          controller: scrollController,
                          slivers: [
                            // Quick access options
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 12.w,
                                  right: 12.w,
                                  top: 24.h,
                                  bottom: 12.h,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Quick Access',
                                      style: context.subtitleText().copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          _buildServiceOption(
                                                () => Get.toNamed(
                                              AppRoutes.hospitalListView,
                                            ),
                                            'assets/icons/hospital.png',
                                            'Find Hospital',
                                            context,
                                            AppColors.primary,
                                          ),
                                          SizedBox(width: 16.w),
                                          _buildServiceOption(
                                                () => Get.toNamed(
                                              AppRoutes.doctorListView,
                                            ),
                                            'assets/icons/doctor.png',
                                            'Find Doctor',
                                            context,
                                            Colors.blue[700]!,
                                          ),
                                          SizedBox(width: 16.w),
                                          _buildServiceOption(
                                                () => Get.toNamed(
                                              AppRoutes.appointmentView,
                                            ),
                                            'assets/icons/hospital.png',
                                            'Book Appointment',
                                            context,
                                            Colors.teal,
                                          ),
                                          SizedBox(width: 16.w),
                                          _buildServiceOption(
                                                () => Get.toNamed(
                                              AppRoutes.userAppointmentsView,
                                            ),
                                            'assets/icons/booking.png',
                                            'My Bookings',
                                            context,
                                            Colors.orange,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // News section
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Healthcare News',
                                      style: context.mediumTitleText().copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder:
                                                (
                                                context,
                                                animation,
                                                secondaryAnimation,
                                                ) => AllNewsScreen(
                                              newsItems:
                                              controller.newsItems,
                                            ),
                                            transitionsBuilder: (
                                                context,
                                                animation,
                                                secondaryAnimation,
                                                child,
                                                ) {
                                              const begin = Offset(0.0, 1.0);
                                              const end = Offset.zero;
                                              const curve =
                                                  Curves.easeInOutCubic;
                                              var tween = Tween(
                                                begin: begin,
                                                end: end,
                                              ).chain(CurveTween(curve: curve));
                                              return SlideTransition(
                                                position: animation.drive(
                                                  tween,
                                                ),
                                                child: child,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'View All',
                                        style: context
                                            .mediumBodyText()
                                            .copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // News list
                            Obx(() {
                              if (controller.isLoading.value) {
                                return const SliverFillRemaining(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              } else if (controller
                                  .newsErrorMessage
                                  .isNotEmpty) {
                                return SliverFillRemaining(
                                  child: _buildErrorState(
                                    controller.newsErrorMessage.value,
                                  ),
                                );
                              } else if (controller.newsItems.isEmpty) {
                                return const SliverFillRemaining(
                                  child: Center(
                                    child: Text('No news available'),
                                  ),
                                );
                              }

                              final newsList =
                              controller.newsItems.take(5).toList();
                              return SliverList(
                                delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                    if (index < newsList.length) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                        ),
                                        child: NewsTile(news: newsList[index]),
                                      );
                                    }
                                    return null;
                                  },
                                  childCount:
                                  newsList.length +
                                      1, // +1 for the "Show More" button
                                ),
                              );
                            }),

                            // Bottom padding
                            SliverToBoxAdapter(child: SizedBox(height: 50.h)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Animated text entry with fade and slide
  Widget _buildAnimatedText(String text, TextStyle style) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: Text(text, style: style),
          ),
        );
      },
    );
  }

  // Enhanced service option buttons with gradients and shadows
  Widget _buildServiceOption(
      void Function() onTap,
      String imagePath,
      String label,
      BuildContext context,
      Color color,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64.w,
            height: 64.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(32),
                splashColor: Colors.white.withOpacity(0.2),
                highlightColor: Colors.white.withOpacity(0.1),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Image.asset(
                    imagePath,
                    width: 32.w,
                    height: 32.h,
                    color: Colors.white,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: context.mediumBodyText().copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Error state widget
  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64.sp,
              color: Colors.red[300],
            ),
            SizedBox(height: 16.h),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: controller.fetchNews,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}