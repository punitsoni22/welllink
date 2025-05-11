import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:welllink/utils/common_widgets/common_app_bar.dart';
import 'package:welllink/utils/common_widgets/common_button.dart';
import 'package:welllink/utils/common_widgets/common_textfield.dart';
import 'package:welllink/utils/constant/extensions/text_style_extensions.dart';
import 'package:welllink/utils/routes/app_routes.dart';

import 'controller/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          CommonAppBar(
            title: 'Sign in',
            colorScheme: colorScheme,
            isBackAllowed: false,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 40.h),
                child: Column(
                  children: [
                    _logInWidget(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _logInWidget(BuildContext context) {
    return Column(
      children: [
        CommonTextField(
          label: 'Email',
          hintText: 'example@gmail.com',
          controller: controller.emailController,
          leadingIcon: Icons.email,
        ),
        SizedBox(height: 12.h),
        CommonTextField(
          label: 'Password',
          hintText: '********',
          controller: controller.passwordController,
          leadingIcon: Icons.password,
          initialObscure: true,
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text('Forgot password?', style: context.linkText()),
          ),
        ),
        SizedBox(height: 30.h),
        Obx(
          () => CommonButton(
            onPressed: controller.isLoading.value
                ? null
                : () {
                    controller.login();
                  },
            text: 'Sign in',
            isSaving: controller.isLoading.value,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Dont have an account? ', style: context.mediumBodyText()),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.registerView),
              child: Text('Sign up', style: context.linkText()),
            )
          ],
        ),
      ],
    );
  }
}
