import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension TextStyleExtensions on BuildContext {
  // Title Styles
  TextStyle bigTitleText({
    Color? color,
    FontWeight? fontWeight,
    String? fontFamily,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: 24.sp,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color ?? Theme.of(this).colorScheme.onSurface,
      fontFamily: fontFamily,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  TextStyle mediumTitleText({
    Color? color,
    FontWeight? fontWeight,
    String? fontFamily,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: 18.sp,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color ?? Theme.of(this).colorScheme.onSurface,
      fontFamily: fontFamily,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  TextStyle smallTitleText({
    Color? color,
    FontWeight? fontWeight,
    String? fontFamily,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: fontWeight ?? FontWeight.w500,
      color: color ?? Theme.of(this).colorScheme.onSurface,
      fontFamily: fontFamily,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  // Subtitle Styles
  TextStyle largeSubtitleText({
    Color? color,
    FontWeight? fontWeight,
    String? fontFamily,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color ?? Colors.grey[800],
      fontFamily: fontFamily,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  TextStyle superLargeSubtitleText({
    Color? color,
    FontWeight? fontWeight,
    String? fontFamily,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: 18.sp,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color ?? Colors.grey[800],
      fontFamily: fontFamily,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  TextStyle subtitleText({
    Color? color,
    FontWeight? fontWeight,
    String? fontFamily,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color ?? Colors.grey[600],
      fontFamily: fontFamily,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  // Body Text Styles
  TextStyle bodyText({
    Color? color,
    FontWeight? fontWeight,
    String? fontFamily,
    double? letterSpacing,
    TextDecoration? decoration,
    double? height,
  }) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Colors.black87,
      fontFamily: fontFamily,
      letterSpacing: letterSpacing,
      decoration: decoration,
      height: height,
    );
  }

  TextStyle mediumBodyText({
    Color? color,
    FontWeight? fontWeight,
    String? fontFamily,
    double? letterSpacing,
    TextDecoration? decoration,
    double? height,
  }) {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Colors.black87,
      fontFamily: fontFamily,
      letterSpacing: letterSpacing,
      decoration: decoration,
      height: height,
    );
  }

  TextStyle smallBodyText({
    Color? color,
    FontWeight? fontWeight,
    String? fontFamily,
    double? letterSpacing,
    TextDecoration? decoration,
    double? height,
  }) {
    return TextStyle(
      fontSize: 12.sp,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Colors.black87,
      fontFamily: fontFamily,
      letterSpacing: letterSpacing,
      decoration: decoration,
      height: height,
    );
  }

  // Caption and Button Text
  TextStyle captionText({
    Color? color,
    FontWeight? fontWeight,
    String? fontFamily,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: 12.sp,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color ?? Colors.grey[600],
      fontFamily: fontFamily,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  TextStyle mediumCaptionText({
    Color? color,
    FontWeight? fontWeight,
    String? fontFamily,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color ?? Colors.grey[600],
      fontFamily: fontFamily,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  TextStyle buttonText({
    Color? color,
    FontWeight? fontWeight,
    String? fontFamily,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color ?? Colors.white,
      fontFamily: fontFamily,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  // Special Text Styles
  TextStyle errorText({
    Color? color,
    FontWeight? fontWeight,
    String? fontFamily,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: 12.sp,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Colors.red,
      fontFamily: fontFamily,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  TextStyle linkText({
    Color? color,
    FontWeight? fontWeight,
    String? fontFamily,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: fontWeight ?? FontWeight.w500,
      color: color ?? Colors.blue,
      fontFamily: fontFamily,
      letterSpacing: letterSpacing,
      decoration: decoration ?? TextDecoration.underline,
    );
  }
}
