import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? iconPath;
  final ColorScheme colorScheme;
  final bool isBackAllowed;

  const CommonAppBar({
    super.key,
    required this.title,
    this.iconPath,
    required this.colorScheme,
    this.isBackAllowed = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          SizedBox(height: 36.h),
          Row(
            children: [
              isBackAllowed
                  ? GestureDetector(
                      onTap: () => Get.back(),
                      child: Center(
                        child: Image.asset(
                          "assets/icons/back_arrow.png",
                          width: 16.w,
                          height: 16.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (iconPath != null) ...[
                    Container(
                      width: 24.w,
                      height: 24.w,
                      decoration: BoxDecoration(
                        color: colorScheme.onSurface,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Image.asset(
                          iconPath!,
                          width: 12.w,
                          height: 12.w,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                  ],
                  Text(
                    title,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(70.h); // Customize height as needed
}
